package game
{
   import flash.geom.Point;
   import game.cosmetic.DeadBoss;
   import game.cosmetic.Flash;
   import game.engine.Assets;
   import game.engine.Grabbable;
   import game.engine.Level;
   import game.particles.ParticleType;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.tweens.misc.Alarm;
   import game.tas.TASCommand;
   
   public class Boss extends Grabbable
   {
      
      public static const ImgFace:Class = Boss_ImgFace;
      
      public static const ImgBody:Class = Boss_ImgBody;
       
      
      private const BLAST_FRICTION:Number = 0.03;
      
      private var faceAlarm:Alarm;
      
      private const FALL_ACCEL:Number = 0.1;
      
      private const NORM_ACCEL:Number = 1;
      
      private const MAX_H:Number = 1.5;
      
      private const BOUNCE:Number = 0.7;
      
      private const H_ACCEL:Number = 0.2;
      
      private var sine:Number = 0;
      
      private var list:Graphiclist;
      
      private var vCounter:Number = 0;
      
      private var body:Spritemap;
      
      private const THRUST_REDUCE:Number = 0.03;
      
      private const GOTO_THRUST:Number = 0.1;
      
      public var hSpeed:Number = 0;
      
      private var particles:Boolean = true;
      
      private var leftPoint:Point;
      
      private var partTypeStrong:ParticleType;
      
      private var alarm:Alarm;
      
      private var rightPoint:Point;
      
      private const BLAST:Number = 2.4;
      
      public var health:uint;
      
      private var face:Spritemap;
      
      public var thrust:Number = 0;

      public var timesThrusted:Number = 0;
      
      private const MAX_PULL:Number = 0.4;
      
      private var player:Player;
      
      private var partTypeWeak:ParticleType;
      
      public var vSpeed:Number = 0;
      
      private var hCounter:Number = 0;
      
      private const START_THRUST:Number = 0.5;
      
      private const FRICTION:Number = 0.05;
      
      public function Boss(player:Player, x:int, y:int, difficulty:uint)
      {
         this.alarm = new Alarm(160,this.onAlarm,Tween.PERSIST);
         this.faceAlarm = new Alarm(120,this.onFaceAlarm,Tween.PERSIST);
         super(x,y);
         this.player = player;
         layer = Main.DEPTH_ENVIRON;
         width = 24;
         height = 24;
         originX = originY = 12;
         grapplePoint = new Point(0,12);
         type = "boss";
         graphic = this.list = new Graphiclist();
         this.body = new Spritemap(ImgBody,34,33);
         this.body.x = -17;
         this.body.y = -16;
         this.body.originX = 17;
         this.body.originY = 28;
         this.body.add("normal",[0]);
         this.body.add("flash",[1,2],0.2);
         this.body.play("normal");
         this.list.add(this.body);
         this.face = new Spritemap(ImgFace,16,16);
         this.face.x = -8;
         this.face.y = -8;
         this.face.originX = 8;
         this.face.originY = 20;
         this.face.add("smile",[6]);
         this.face.add("laugh",[0,1],0.15);
         this.face.add("sad",[2]);
         this.face.add("dead",[3],0.12);
         this.face.add("angry",[4],0.15);
         this.face.add("angry_talk",[4,5],0.15);
         this.face.play("smile");
         this.list.add(this.face);
         if((FP.world as Level).attempt == 1)
         {
            addTween(new Alarm(5,this.intro,Tween.ONESHOT),true);
         }
         addTween(this.alarm);
         addTween(this.faceAlarm);
         addTween(new Alarm(14,this.checkTalking,Tween.LOOPING),true);
         this.partTypeWeak = Main.particles.getType("bossFireWeak");
         this.partTypeStrong = Main.particles.getType("bossFireStrong");
         this.health = 2 + difficulty;
         this.leftPoint = new Point();
         this.rightPoint = new Point();
      }
      
      private function die() : void
      {
         active = false;
         (FP.world as Level).countTime = false;
         if(grapple)
         {
            grapple.destroy();
         }
         FP.world.remove(this);
         FP.world.add(new DeadBoss(x,y,this.hSpeed,this.vSpeed,Main.saveData.level < 50));
         var arr:Array = new Array();
         FP.world.getClass(FireBall,arr);
         FP.world.getClass(Mine,arr);
         for(var i:int = 0; i < arr.length; i++)
         {
            FP.world.remove(arr[i]);
         }
         var vec2:Vector.<LaserH> = new Vector.<LaserH>();
         FP.world.getClass(LaserH,vec2);
         for(i = 0; i < vec2.length; i++)
         {
            vec2[i].deactivate();
         }
         var vec3:Vector.<LaserV> = new Vector.<LaserV>();
         FP.world.getClass(LaserV,vec3);
         for(i = 0; i < vec3.length; i++)
         {
            vec3[i].deactivate();
         }
         var vec4:Vector.<NoGrapple> = new Vector.<NoGrapple>();
         FP.world.getClass(NoGrapple,vec4);
         for(i = 0; i < vec4.length; i++)
         {
            vec4[i].deactivate();
         }
         var vec5:Vector.<Launcher> = new Vector.<Launcher>();
         FP.world.getClass(Launcher,vec5);
         for(i = 0; i < vec5.length; i++)
         {
            vec5[i].deactivate();
         }
         var vec6:Vector.<Missile> = new Vector.<Missile>();
         FP.world.getClass(Missile,vec6);
         for(i = 0; i < vec6.length; i++)
         {
            vec6[i].die();
         }
         Assets.SndBossDie.play();
         FP.world.add(new Flash(4294967295,true));
         Main.screenShake(2);
         Assets.setMusic();
      }
      
      private function checkTalking() : void
      {
         if(Assets.voice.playing)
         {
            this.body.scale = 1.2;
         }
         else if(this.face.currentAnim == "angry_talk")
         {
            this.face.play("angry");
         }
         else if(this.face.currentAnim == "laugh")
         {
            this.face.play("smile");
         }
      }
      
      private function hit() : void
      {
         this.health--;
         this.thrust = 0;
         Assets.playHitBoss();
         if(this.health == 0)
         {
            this.die();
            return;
         }
         FP.world.add(new Flash());
         Main.screenShake(1);
         if(grapple)
         {
            this.alarm.reset(120);
            this.alarm.start();
         }
         this.face.play("dead");
      }
      
      public function moveV(num:Number, onCollide:Function = null) : Boolean
      {
         var s:Entity = null;
         this.vCounter = this.vCounter + num;
         var go:int = Math.round(this.vCounter);
         this.vCounter = this.vCounter - go;
         var sign:int = go > 0?1:-1;
         var moved:int = 0;
         while(go != 0)
         {
            if((s = collide("solid",x,y + sign)) != null)
            {
               this.vSpeed = 0;
               return false;
            }
            y = y + sign;
            moved = moved + sign;
            go = go - sign;
         }
         if(grapple)
         {
            grapple.move(0,moved);
         }
         return true;
      }
      
      public function moveH(num:Number) : Boolean
      {
         var s:Entity = null;
         this.hCounter = this.hCounter + num;
         var go:int = Math.round(this.hCounter);
         this.hCounter = this.hCounter - go;
         var sign:int = go > 0?1:-1;
         var moved:int = 0;
         while(go != 0)
         {
            if((s = collide("solid",x + sign,y)) != null)
            {
               this.hSpeed = this.hSpeed * this.BOUNCE;
               return false;
            }
            x = x + sign;
            moved = moved + sign;
            go = go - sign;
         }
         if(grapple)
         {
            grapple.move(moved,0);
         }
         return true;
      }
      
      private function onAlarm() : void
      {
         Assets.SndBossThrust.play();
         var mine:Mine = FP.world.nearestToEntity("mine",this) as Mine;
         if(mine.x == x)
         {
            this.thrust = FP.choose(this.START_THRUST,-this.START_THRUST);
         }
         else
         {
            this.thrust = mine.x < x?Number(this.START_THRUST):Number(-this.START_THRUST);
         }
         this.thrust = this.thrust - 0.05;

         // TAS EDIT
         if (FP.tas.SeededBossThrusts == null)
         {
            var thrusts:Vector.<Number> = new Vector.<Number>();
            thrusts.push(0);
            FP.tas.TryRecordStartCommand(new TASCommand(TASCommand.THRUSTS, thrusts));
            FP.tas.SeededBossThrusts = thrusts;
         }

         var extraThrustAmt:Number = 0;
         if (FP.tas.SeededBossThrusts != null)
         {
            if (timesThrusted >= FP.tas.SeededBossThrusts.length)
            {
               extraThrustAmt = 0;
            }
            else
            {
               extraThrustAmt = FP.tas.SeededBossThrusts[timesThrusted];
            }
         }
         this.thrust = this.thrust + 0.1 * extraThrustAmt;
         this.alarm.reset(160);
         this.alarm.start();
         this.face.play("angry_talk");
         timesThrusted += 1;
         Assets.playGrappleBoss();
      }
      
      private function onAnimationEnd() : void
      {
         if(this.face.currentAnim == "dead")
         {
            this.face.play("angry");
            this.faceAlarm.start();
         }
      }
      
      override public function update() : void
      {
         var pt:Point = null;
         var pt2:Point = null;
         var dir:Number = NaN;
         this.sine = (this.sine + Math.PI / 64) % (Math.PI * 2);
         if(grapple)
         {
            this.body.angle = FP.approach(this.body.angle,FP.angle(x,y + 12,this.player.x,this.player.y) - 270,6);
         }
         else
         {
            this.body.angle = FP.approach(this.body.angle,0,3);
         }
         this.body.angle = this.body.angle + this.thrust * -5;
         this.face.angle = this.body.angle;
         if(this.body.scale > 1)
         {
            this.body.scale = Math.max(1,this.body.scale - 0.05);
         }
         if(this.thrust > this.GOTO_THRUST)
         {
            this.thrust = Math.max(this.thrust - this.THRUST_REDUCE,this.GOTO_THRUST);
         }
         else if(this.thrust < -this.GOTO_THRUST)
         {
            this.thrust = Math.min(this.thrust + this.THRUST_REDUCE,-this.GOTO_THRUST);
         }
         FP.angleXY(FP.point,90 + this.body.angle,12);
         var obj:Entity = FP.world.collideRect("mine",x + FP.point.x - 16,y + FP.point.y + 2,32,32);
         if(obj is Mine)
         {
            pt = FP.angleXY(new Point(),FP.angle(obj.x,obj.y,x,y),this.BLAST);
            this.hSpeed = pt.x;
            this.vSpeed = pt.y;
            (obj as Mine).explode();
            this.hit();
         }
         else
         {
            obj = FP.world.collideRect("missile",x + FP.point.x - 16,y + FP.point.y + 2,32,32);
            if(obj != null)
            {
               pt2 = FP.angleXY(new Point(),FP.angle(obj.x,obj.y,x,y),this.BLAST / 2);
               this.hSpeed = this.hSpeed + pt2.x;
               this.vSpeed = this.vSpeed + pt2.y;
               (obj as Missile).explode();
            }
         }
         if(Math.abs(this.hSpeed) >= this.MAX_H)
         {
            this.hSpeed = FP.approach(this.hSpeed,0,this.BLAST_FRICTION);
         }
         else if(grapple)
         {
            dir = FP.angleXY(new Point(),FP.angle(grapple.x,grapple.y,this.player.x,this.player.y)).x * this.MAX_H;
            this.hSpeed = FP.approach(this.hSpeed,dir,this.H_ACCEL);
            this.hSpeed = Math.min(Math.max(-this.MAX_H,this.hSpeed + this.thrust),this.MAX_H);
         }
         else
         {
            this.hSpeed = Math.min(Math.max(-this.MAX_H,this.hSpeed + this.thrust),this.MAX_H);
            this.hSpeed = FP.approach(this.hSpeed,0,this.FRICTION);
         }
         if(this.vSpeed < 0 || this.vSpeed > this.MAX_PULL)
         {
            this.vSpeed = FP.approach(this.vSpeed,0,this.BLAST_FRICTION);
         }
         else if(grapple)
         {
            this.vSpeed = FP.approach(this.vSpeed,this.MAX_PULL,this.FALL_ACCEL);
         }
         else
         {
            this.vSpeed = FP.approach(this.vSpeed,Math.sin(this.sine) * 0.5 - 0.1,this.NORM_ACCEL);
         }
         this.moveH(this.hSpeed);
         this.moveV(this.vSpeed);
         if(this.particles)
         {
            FP.angleXY(this.leftPoint,FP.angle(0,0,-12,-1) + this.body.angle,FP.distance(0,0,-12,-1));
            FP.angleXY(this.rightPoint,FP.angle(0,0,9,-1) + this.body.angle,FP.distance(0,0,9,-1));
            if(this.thrust < 0)
            {
               this.partTypeStrong.direction = 310 + this.body.angle;
               Main.particles.addParticlesArea("bossFireStrong",x + this.rightPoint.x + this.hSpeed,y + 12 + this.rightPoint.y + this.vSpeed,4,4);
            }
            else
            {
               this.partTypeWeak.direction = 310 + this.body.angle;
               Main.particles.addParticlesArea("bossFireWeak",x + this.rightPoint.x + this.hSpeed,y + 12 + this.rightPoint.y + this.vSpeed,4,4);
            }
            if(this.thrust > 0)
            {
               this.partTypeStrong.direction = 220 + this.body.angle;
               Main.particles.addParticlesArea("bossFireStrong",x + this.leftPoint.x + this.hSpeed,y + 12 + this.leftPoint.y + this.vSpeed,4,4);
            }
            else
            {
               this.partTypeWeak.direction = 220 + this.body.angle;
               Main.particles.addParticlesArea("bossFireWeak",x + this.leftPoint.x + this.hSpeed,y + 12 + this.leftPoint.y + this.vSpeed,4,4);
            }
         }
         this.particles = !this.particles;
      }
      
      override public function onRelease() : void
      {
         this.alarm.active = false;
         this.body.play("normal");
         this.face.play("smile");
      }
      
      private function onFaceAlarm() : void
      {
         this.face.play("sad");
      }
      
      private function intro() : void
      {
         this.face.play("laugh");
         Assets.playVoice(Assets["VcBossIntro" + (FP.world as Level).levelNum / 20]);
      }
      
      override public function onGrapple() : void
      {
         this.alarm.start();
         this.face.play("sad");
         this.body.play("flash");
         this.body.scale = 1.4;
         Assets.setMusic(Assets.MusBoss);
      }
   }
}
