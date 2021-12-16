package game
{
   import flash.geom.Point;
   import game.cosmetic.SpeechBubble;
   import game.engine.Assets;
   import game.engine.Grabbable;
   import game.engine.Level;
   import game.particles.ParticleType;
   import net.flashpunk.*;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class Missile extends Grabbable
   {
      
      private static const ImgMissile:Class = Missile_ImgMissile;
       
      
      private const EXPLODE:int = 48;
      
      private var sprite:Spritemap;
      
      private var speed:Number = 5;
      
      private const ACCEL:Number = 0.2;
      
      private var timer:Alarm;
      
      private const LAUNCH_SPEED:Number = 5;
      
      private var tempPoint:Point;
      
      private var launcher:Launcher;
      
      private var player:Player;
      
      private var particles:Boolean = false;
      
      private var part:ParticleType;
      
      private var cantCollide:uint = 24;
      
      private const FLY_SPEED:Number = 1;
      
      public function Missile(player:Player, launcher:Launcher, x:int, y:int, direction:Number)
      {
         this.tempPoint = new Point();
         this.timer = new Alarm(60,this.stopLaughing,Tween.PERSIST);
         super(x,y);
         this.player = player;
         this.launcher = launcher;
         type = "missile";
         width = 16;
         height = 16;
         originX = 8;
         originY = 8;
         layer = Main.DEPTH_ACTORS;
         grapplePoint = new Point();
         graphic = this.sprite = new Spritemap(ImgMissile,26,26);
         this.sprite.x = -13;
         this.sprite.y = -13;
         this.sprite.originX = 13;
         this.sprite.originY = 13;
         this.sprite.angle = direction;
         this.sprite.add("laugh",[0,1],0.1);
         this.sprite.add("happy",[2]);
         this.sprite.add("upset",[3]);
         this.sprite.add("flashing",[3,4],0.1);
         this.sprite.play("laugh");
         addTween(this.timer,true);
         this.part = Main.particles.getType("missileTravel");
      }
      
      public function die() : void
      {
         FP.world.remove(this);
         if(grapple)
         {
            grapple.destroy();
         }
         this.launcher.startTimer();
      }
      
      private function talkAgain() : void
      {
         Assets.SndMissileTalk.play();
         if(FP.choose(true,true,false))
         {
            FP.world.add(new SpeechBubble(x + 32,y - 24,FP.choose("Seriously,\nnot cool!","WATCH OUT!","This is\njust rude.","I am NOT\na toy!","I hope you\nhave a plan."),0.2));
         }
      }
      
      override public function update() : void
      {
         var obj:Entity = null;
         this.speed = Math.max(this.speed - this.ACCEL,this.FLY_SPEED);
         if(this.speed == this.FLY_SPEED)
         {
            if(this.particles)
            {
               this.part.direction = this.sprite.angle + 178;
               Main.particles.addParticlesArea("missileTravel",x - 2,y - 2,4,4);
            }
            this.particles = !this.particles;
         }
         FP.angleXY(this.tempPoint,this.sprite.angle,this.speed);
         x = x + this.tempPoint.x;
         y = y + this.tempPoint.y;
         if(grapple)
         {
            if(this.player.onGround)
            {
               grapple.looseMove(this.tempPoint.x,this.tempPoint.y);
            }
            else
            {
               grapple.move(this.tempPoint.x,this.tempPoint.y);
            }
            this.sprite.angle = this.sprite.angle + Main.rotateToward(this.sprite.angle,FP.angle(x,y,this.player.x,this.player.y),2);
         }
         if(this.cantCollide > 0)
         {
            this.cantCollide--;
         }
         else if(!grapple && (y > (FP.world as Level).height + 24 || x > (FP.world as Level).width + 24 || x < -24 || y < -24))
         {
            this.die();
         }
         else if((obj = collide("solid",x,y)) != null && !(obj is EdgeBlock))
         {
            this.explode();
         }
         else if((obj = collide("missile",x,y)) != null)
         {
            this.explode();
            (obj as Missile).explode();
         }
      }
      
      private function stopLaughing() : void
      {
         this.sprite.play("happy");
      }
      
      public function explode() : void
      {
         if(!active)
         {
            return;
         }
         active = false;
         Assets.SndMissileExplode.play();
         Main.screenShake(1);
         this.die();
         var vec:Vector.<Entity> = new Vector.<Entity>();
         FP.world.collideRectInto("solid",x - this.EXPLODE / 2,y - this.EXPLODE / 2,this.EXPLODE,this.EXPLODE,vec);
         for(var i:int = 0; i < vec.length; i++)
         {
            if(vec[i] is CrackedBlock)
            {
               (vec[i] as CrackedBlock).blowUp();
            }
         }
         Main.particles.addParticlesArea("missileExplode",x - 6,y - 6,12,12,10);
      }
      
      private function talk() : void
      {
         if(FP.choose(true,true,false))
         {
            Assets.SndMissileTalk.play();
            FP.world.add(new SpeechBubble(x + 32,y - 24,FP.choose("WHAT ARE\nYOU DOING!?","AHHHHHHH!!","GET IT OFF!","THIS ISN\'T\nSAFE!!","F*&%!!","I\'M BEING\nHIJACKED!")));
         }
         this.timer.complete = this.talkAgain;
         this.timer.reset(240);
         this.timer.start();
      }
      
      override public function onRelease() : void
      {
         this.sprite.play("upset");
         this.timer.active = false;
      }
      
      override public function onGrapple() : void
      {
         this.sprite.play("flashing");
         this.timer.active = true;
         this.timer.complete = this.talk;
         this.timer.reset(30);
         this.timer.start();
      }
   }
}
