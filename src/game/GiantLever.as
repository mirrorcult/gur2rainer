package game
{
   import flash.display.BitmapData;
   import game.cosmetic.Background1;
   import game.cosmetic.Face;
   import game.cosmetic.Flash;
   import game.cosmetic.SpeechBubble;
   import game.cosmetic.Tiles1;
   import game.engine.Assets;
   import game.engine.Level;
   import game.particles.ParticleType;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class GiantLever extends Block
   {
      
      private static const ImgGiantLever:Class = GiantLever_ImgGiantLever;
       
      
      private var imageRight:Image;
      
      private var tiles:Tiles1;
      
      private var imageLeft:Image;
      
      private var alarmTalk:Alarm;
      
      private var mode:int = -1;
      
      private var startY:int;
      
      private const SPEECH_X:int = 75;
      
      private const SPEECH_Y:int = 8;
      
      private const MAX_DOWN:Number = 0.2;
      
      private const C_PULL:uint = 16776960;
      
      private const C_SIT:uint = 16711680;
      
      private var sprite:Spritemap;
      
      private const ACCEL:Number = 0.01;
      
      private var bg:Background1;
      
      private var canMove:Boolean = true;
      
      private var face:Face;
      
      private var endY:int;
      
      private const SHAKE_DIST:int = 50;
      
      private var vSpeed:Number = 0;
      
      private var part:ParticleType;
      
      private const DISTANCE:int = 200;
      
      private const MAX_UP:Number = -1.2;
      
      private const C_DONE:uint = 65535;
      
      public function GiantLever(player:Player, x:int, y:int, bg:Background1, tiles:Tiles1)
      {
         var list:Graphiclist = null;
         var bd:BitmapData = null;
         this.alarmTalk = new Alarm(80,this.talk,Tween.PERSIST);
         super(player,x,y,64,64);
         this.bg = bg;
         this.tiles = tiles;
         active = true;
         visible = true;
         layer = Main.DEPTH_ACTORS;
         this.startY = y;
         this.endY = this.startY + this.DISTANCE;
         list = new Graphiclist();
         graphic = list;
         bd = new BitmapData(6,this.DISTANCE + 56,true,4294967295);
         this.imageLeft = new Image(bd);
         this.imageLeft.relative = false;
         this.imageLeft.x = x + 6;
         this.imageLeft.y = y + 4;
         this.imageLeft.color = this.C_SIT;
         this.imageLeft.alpha = 0.4;
         list.add(this.imageLeft);
         this.imageRight = new Image(bd);
         this.imageRight.relative = false;
         this.imageRight.x = x + 52;
         this.imageRight.y = y + 2;
         this.imageRight.color = this.C_SIT;
         this.imageRight.alpha = 0.4;
         list.add(this.imageRight);
         this.sprite = new Spritemap(ImgGiantLever,64,64);
         this.sprite.add("sit",[0]);
         this.sprite.add("pull",[1]);
         this.sprite.add("done",[2]);
         this.sprite.play("sit");
         list.add(this.sprite);
         this.face = new Face(32,28);
         this.face.scale = 3;
         list.add(this.face);
         addTween(this.alarmTalk);
         this.part = Main.particles.getType("giantLeverSparks");
         Assets.MusPowerOn.loop(0);
      }
      
      private function done() : void
      {
         var i:int = 0;
         player.cameraOffsetY = 320;
         addTween(new Alarm(280,this.openDoors,Tween.ONESHOT),true);
         (FP.world as Level).setTheme(this.tiles,this.bg);
         FP.world.remove(Main.tutorial);
         Main.tutorial = null;
         var vec:Vector.<FireBall> = new Vector.<FireBall>();
         FP.world.getClass(FireBall,vec);
         for(i = 0; i < vec.length; i++)
         {
            FP.world.remove(vec[i]);
         }
         var arr:Vector.<NoGrapple> = new Vector.<NoGrapple>();
         FP.world.getClass(NoGrapple,arr);
         for(i = 0; i < arr.length; i++)
         {
            arr[i].activate();
         }
         Assets.SndGiantLeverDone.play();
         Main.screenShake(2);
         FP.world.add(new Flash(4294967295,true));
         Assets.MusPowerOn.stop();
         Assets.setMusic(Assets.MusWorld1);
         addTween(new Alarm(15,this.playVoice,Tween.ONESHOT),true);
      }
      
      override public function onRelease() : void
      {
         if(this.canMove)
         {
            this.sprite.play("sit");
            this.face.play("surprised");
            this.imageLeft.color = this.C_SIT;
            this.imageRight.color = this.C_SIT;
         }
      }
      
      private function talk() : void
      {
         if(this.face.currentAnim == "surprised" && grapple)
         {
            Assets.SndGiantLeverTalk.play();
            this.face.play("surprised_talk");
            this.alarmTalk.reset(180);
            this.alarmTalk.start();
            FP.world.add(new SpeechBubble(x + this.SPEECH_X,y + this.SPEECH_Y,FP.choose("Whoa,\nget off!","No, don\'t pull\nme down!","I want to\nstay up here!")));
         }
         else if(this.face.currentAnim == "surprised_talk" && grapple)
         {
            Assets.SndGiantLeverTalk.play();
            this.face.play("surprised_talk",true);
            FP.world.add(new SpeechBubble(x + this.SPEECH_X,y + this.SPEECH_Y,FP.choose("Please, no!","I don\'t want\nto go back in!","Anything\nbut this!","Think about\nthis!","Don\'t\nmake me!","Stop!\nPlease!")));
            this.alarmTalk.reset(300);
            this.alarmTalk.start();
         }
      }
      
      override public function update() : void
      {
         var perc:Number = NaN;
         if(!this.canMove)
         {
            this.mode++;
            if(this.mode == 0)
            {
               this.part.direction = -20;
               Main.particles.addParticlesArea("giantLeverSparks",x + 62,y + 6,0,52,1);
            }
            else if(this.mode == 1)
            {
               this.part.direction = 70;
               Main.particles.addParticlesArea("giantLeverSparks",x + 6,y + 2,52,0,1);
            }
            else if(this.mode == 2)
            {
               this.part.direction = 160;
               Main.particles.addParticlesArea("giantLeverSparks",x + 2,y + 6,0,52,1);
            }
            else if(this.mode == 3)
            {
               this.part.direction = 250;
               Main.particles.addParticlesArea("giantLeverSparks",x + 6,y + 62,52,0,1);
               this.mode = -1;
            }
            return;
         }
         if(grapple)
         {
            if(this.endY - y <= 60)
            {
               Main.screenShake(0);
            }
            if(player.onGround)
            {
               this.vSpeed = 0;
            }
            else
            {
               this.vSpeed = Math.min(this.vSpeed + this.ACCEL,this.MAX_DOWN,this.endY - y);
            }
         }
         else
         {
            this.vSpeed = Math.max(this.vSpeed - this.ACCEL,this.MAX_UP,this.startY - y);
         }
         moveV(this.vSpeed);
         if(this.vSpeed != 0)
         {
            perc = (y - this.startY) / (this.endY - this.startY);
            if (Assets.musicPlaying) Assets.music.volume = Math.max(0,1 - perc * 2);
            Assets.MusPowerOn.volume = Math.max(0,perc - 0.5) * 1.8;
         }
         if(this.vSpeed > 0 && y >= this.endY)
         {
            y = this.endY;
            this.vSpeed = 0;
            this.sprite.play("done");
            this.face.play("horrified");
            this.imageLeft.color = this.C_DONE;
            this.imageRight.color = this.C_DONE;
            this.canMove = false;
            this.done();
         }
         else if(this.vSpeed < 0 && y <= this.startY)
         {
            shake = 10;
            y = this.startY;
            this.vSpeed = 0;
            this.face.play("happy");
            Assets.SndLeverTop.play();
         }
         else if(this.vSpeed > 0 && y >= this.endY - this.SHAKE_DIST && shake == 0)
         {
            this.face.play("pain");
            shake = -1;
            Assets.SndGiantLeverAlmost.play();
            FP.world.add(new SpeechBubble(x + this.SPEECH_X,y + this.SPEECH_Y,"ARGH!!1!"));
         }
      }
      
      private function openDoors() : void
      {
         var arr:Array = new Array();
         FP.world.getClass(Door,arr);
         for(var i:int = 0; i < arr.length; i++)
         {
            arr[i].open();
         }
      }
      
      private function playVoice() : void
      {
         Assets.playVoice(Assets.VcPowerOn);
      }
      
      override public function onGrapple() : void
      {
         if(this.canMove)
         {
            shake = 10;
            this.sprite.play("pull");
            this.face.play("surprised");
            this.imageLeft.color = this.C_PULL;
            this.imageRight.color = this.C_PULL;
            this.alarmTalk.reset(80);
            this.alarmTalk.start();
         }
      }
   }
}
