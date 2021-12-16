package game.cosmetic
{
   import game.Block;
   import game.Boss;
   import game.Door;
   import game.engine.Assets;
   import game.engine.Level;
   import game.engine.Moveable;
   import game.particles.ParticleType;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class DeadBoss extends Moveable
   {
       
      
      private var makePart:Boolean = false;
      
      private var body:Spritemap;
      
      private const ACCEL:Number = -0.02;
      
      private var partType:ParticleType;
      
      private var flying:Boolean = false;
      
      private var getUp:Boolean;
      
      private var checkTalk:Alarm;
      
      private const MAX_FALL:Number = 4;
      
      private const MAX_FLY:Number = -3;
      
      private var face:Spritemap;
      
      private var list:Graphiclist;
      
      private var particles:Boolean = false;
      
      private const GRAVITY:Number = 0.16;
      
      private var vSpeed:Number;
      
      private var hitGround:Boolean = false;
      
      private var hSpeed:Number;
      
      public function DeadBoss(x:int, y:int, h:Number, v:Number, getUp:Boolean = true)
      {
         super(x,y);
         this.hSpeed = h;
         this.vSpeed = v;
         this.getUp = getUp;
         layer = Main.DEPTH_ACTORS;
         width = 24;
         height = 24;
         originX = originY = 12;
         graphic = this.list = new Graphiclist();
         this.body = new Spritemap(Boss.ImgBody,34,33);
         this.body.x = -17;
         this.body.y = -16;
         this.body.originX = 17;
         this.body.originY = 16;
         this.body.add("sad",[3]);
         this.body.add("flash",[1,2],0.2);
         this.body.play("flash");
         this.list.add(this.body);
         this.face = new Spritemap(Boss.ImgFace,16,16);
         this.face.x = -8;
         this.face.y = -8;
         this.face.originX = 8;
         this.face.originY = 8;
         this.face.add("smile",[6]);
         this.face.add("laugh",[0,1],0.15);
         this.face.add("sad",[2]);
         this.face.add("dead",[3],0.05);
         this.face.add("angry",[4,5],0.15);
         this.face.play("dead");
         this.list.add(this.face);
         this.partType = Main.particles.getType("bossFireWeak");
         addTween(this.checkTalk = new Alarm(14,this.checkTalking,Tween.LOOPING),true);
      }
      
      private function checkTalking() : void
      {
         if(Assets.voice.playing)
         {
            this.body.scale = 1.2;
         }
      }
      
      private function finish() : void
      {
         removeTween(this.checkTalk);
         this.openDoor();
         if(this.getUp)
         {
            Assets.SndBossThrustEnd.play();
            layer = Main.DEPTH_ACTORS;
            this.makePart = true;
            this.flying = true;
         }
         else
         {
            this.face.play("dead");
         }
      }
      
      private function hitH(b:Block) : void
      {
         if(this.flying)
         {
            return;
         }
         Assets.SndBossBounce.play();
         this.hSpeed = this.hSpeed * -0.9;
      }
      
      private function openDoor() : void
      {
         var arr:Array = new Array();
         FP.world.getClass(Door,arr);
         arr[0].open();
      }
      
      private function hitV(b:Block) : void
      {
         if(this.flying)
         {
            return;
         }
         if(y >= 720)
         {
            this.land();
         }
         else
         {
            Assets.SndBossBounce.play();
            this.vSpeed = this.vSpeed * -0.7;
         }
      }
      
      override public function update() : void
      {
         if(!this.hitGround)
         {
            this.body.angle = this.body.angle + 4;
            this.face.angle = this.face.angle + 4;
         }
         if(this.flying)
         {
            this.body.angle = this.face.angle = this.face.angle + Main.rotateToward(this.face.angle,0,12);
            this.vSpeed = Math.max(this.MAX_FLY,this.vSpeed + this.ACCEL);
         }
         else if(!this.hitGround && getBelow() == null)
         {
            this.vSpeed = Math.min(this.vSpeed + this.GRAVITY,this.MAX_FALL);
         }
         if(this.body.scale > 1)
         {
            this.body.scale = Math.max(1,this.body.scale - 0.05);
         }
         moveH(this.hSpeed,this.hitH);
         moveV(this.vSpeed,this.hitV);
         if(this.makePart)
         {
            if(this.particles)
            {
               FP.angleXY(FP.point,FP.angle(0,0,8,6) + this.body.angle,FP.distance(0,0,8,6));
               this.partType.direction = 310 + this.body.angle;
               Main.particles.addParticlesArea("bossFireWeak",x + FP.point.x + this.hSpeed,y + FP.point.y + this.vSpeed,4,4);
               FP.angleXY(FP.point,FP.angle(0,0,-12,6) + this.body.angle,FP.distance(0,0,-12,6));
               this.partType.direction = 220 + this.body.angle;
               Main.particles.addParticlesArea("bossFireWeak",x + FP.point.x + this.hSpeed,y + FP.point.y + this.vSpeed,4,4);
            }
            this.particles = !this.particles;
         }
         if(y < -40)
         {
            visible = false;
            active = false;
         }
      }
      
      private function land() : void
      {
         this.body.angle = this.face.angle = (this.face.angle + 360) % 360;
         this.hSpeed = 0;
         this.vSpeed = 0;
         this.makePart = false;
         this.hitGround = true;
         this.body.play("sad");
         Main.screenShake(1);
         layer = Main.DEPTH_BGEFFECT;
         Assets.SndBossLand.play();
         addTween(new Alarm(120,this.talk,Tween.ONESHOT),true);
      }
      
      private function talk() : void
      {
         this.face.play("sad");
         addTween(new Alarm(!!this.getUp?Number(180):Number(640),this.finish,Tween.ONESHOT),true);
         Assets.playVoice(Assets["VcBossDead" + (FP.world as Level).levelNum / 20]);
      }
   }
}
