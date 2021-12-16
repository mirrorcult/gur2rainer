package game
{
   import game.engine.Assets;
   import game.engine.Level;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.graphics.TiledSpritemap;
   import net.flashpunk.tweens.misc.Alarm;
   import net.flashpunk.tweens.motion.QuadMotion;
   import net.flashpunk.utils.Ease;
   
   public class BossChase extends Entity
   {
      
      private static const ImgBossChase:Class = BossChase_ImgBossChase;
      
      private static const ImgBossChaseHard:Class = BossChase_ImgBossChaseHard;
      
      private static const ImgBigLaser:Class = BossChase_ImgBigLaser;
       
      
      private const PLAYER_X:int = 160;
      
      private var talkAlarm:Alarm;
      
      private var laser:TiledSpritemap;
      
      private var sine:Number = 0;
      
      private const END_X:int = 2952;
      
      private const END_Y:int = 120;
      
      private const START_X:int = -64;
      
      private const START_Y:int = 240;
      
      private var face:Spritemap;
      
      private var list:Graphiclist;
      
      private var introTween:QuadMotion;
      
      private var player:Player;
      
      private var body:Spritemap;
      
      public var quadTween:QuadMotion;
      
      private const INTRO_X:int = 128;
      
      private const INTRO_Y:int = 20;
      
      private var end:Boolean = false;
      
      private var wait:Boolean = true;
      
      public function BossChase(player:Player)
      {
         super(this.START_X,this.START_Y);
         layer = Main.DEPTH_ENVIRON;
         this.player = player;
         graphic = this.list = new Graphiclist();
         this.laser = new TiledSpritemap(ImgBigLaser,32,16,32,240);
         this.laser.add("go",[0,1,2,3,2,1],0.5);
         this.laser.play("go");
         this.laser.x = 16;
         this.laser.y = 29;
         this.laser.visible = false;
         this.list.add(this.laser);
         if(Main.saveData.mode == 0)
         {
            this.body = new Spritemap(ImgBossChase,64,32);
         }
         else
         {
            this.body = new Spritemap(ImgBossChaseHard,64,32);
         }
         this.body.add("go",[0,1,2,3,4,5],0.2);
         this.body.play("go");
         this.body.centerOrigin();
         this.list.add(this.body);
         if(Main.saveData.mode == 0)
         {
            this.face = new Spritemap(Boss.ImgFace,16,16);
            this.face.x = 24;
            this.face.y = 8;
            this.face.add("smile",[6]);
            this.face.add("laugh",[0,1],0.15);
            this.face.add("sad",[2]);
            this.face.add("dead",[3],0.12);
            this.face.add("angry",[4],0.15);
            this.face.add("angry_talk",[4,5],0.15);
            this.face.play("angry");
            this.face.centerOrigin();
            this.list.add(this.face);
         }
         if(Main.saveData.mode == 0)
         {
            addTween(new Alarm(14,this.checkTalking,Tween.LOOPING),true);
         }
      }
      
      override public function update() : void
      {
         var obj:Entity = null;
         if(this.end)
         {
            if(this.quadTween && this.quadTween.active)
            {
               this.body.angle = this.face.angle = Math.sin(this.quadTween.scale * Math.PI * 6) * 16;
               x = this.quadTween.x;
               y = this.quadTween.y;
            }
            return;
         }
         if(this.wait)
         {
            if(this.player.x >= this.PLAYER_X)
            {
               this.startIntro();
            }
            return;
         }
         if(this.introTween.active)
         {
            x = this.introTween.x;
            y = this.introTween.y;
            this.body.scale = 4 - this.introTween.scale * 3;
            if(this.face)
            {
               this.face.scale = this.body.scale;
            }
            return;
         }
         this.sine = (this.sine + 0.05) % (Math.PI * 2);
         if(this.body.scale > 1)
         {
            this.body.scale = Math.max(1,this.body.scale - 0.05);
         }
         if(this.player.x > x + 24)
         {
            if(x < FP.camera.x)
            {
               x = x + 2.6;
            }
            else
            {
               x = x + 1.5;
            }
         }
         else
         {
            x = x - 0.6;
         }
         y = this.INTRO_Y + Math.sin(this.sine) * 10;
         if(this.laser.visible)
         {
            this.laser.offsetY = (this.laser.offsetY + 3) % 16;
            if((obj = FP.world.collideRect("player",x + 20,0,12,240)) != null)
            {
               (obj as Player).die();
            }
         }
      }
      
      private function checkTalking() : void
      {
         if(this.end)
         {
            return;
         }
         if(Assets.voice.playing)
         {
            this.body.scale = 1.4;
         }
         else if(this.face.currentAnim == "angry_talk")
         {
            this.face.play("angry");
         }
      }
      
      private function startLaser() : void
      {
         Assets.SndBossLaser.play();
         this.laser.visible = true;
      }
      
      private function quip() : void
      {
         if(this.end)
         {
            removeTween(this.talkAlarm);
            return;
         }
         this.face.play("angry_talk");
         this.talkAlarm.reset(180 + Math.random() * 180);
         this.talkAlarm.start();
         Assets.playBossChase();
      }
      
      private function openDoor() : void
      {
         var arr:Array = new Array();
         FP.world.getClass(Door,arr);
         arr[0].open();
      }
      
      private function finishIntro() : void
      {
         this.openDoor();
         addTween(new Alarm(40,this.startLaser,Tween.ONESHOT),true);
         if(Main.saveData.mode == 0)
         {
            if((FP.world as Level).attempt == 1)
            {
               Assets.playVoice(Assets.VcBossIntro4);
               addTween(this.talkAlarm = new Alarm(280,this.quip,Tween.PERSIST),true);
            }
            else
            {
               addTween(this.talkAlarm = new Alarm(20 + Math.random() * 60,this.quip,Tween.PERSIST),true);
            }
         }
      }
      
      public function endMode() : void
      {
         this.laser.visible = false;
         if(this.face)
         {
            this.face.play("sad");
         }
         this.end = true;
         this.quadTween = new QuadMotion(null,Tween.ONESHOT);
         if(x < 2816)
         {
            x = 2816;
         }
         this.quadTween.setMotion(x,y,this.END_X,this.END_Y,this.END_X,this.END_Y,90,Ease.quadInOut);
         addTween(this.quadTween,true);
      }
      
      private function startIntro() : void
      {
         this.wait = false;
         this.body.scale = 4;
         if(this.face)
         {
            this.face.scale = 4;
         }
         this.introTween = new QuadMotion(this.finishIntro,Tween.ONESHOT);
         this.introTween.setMotion(x,y,x,this.INTRO_Y,this.INTRO_X,this.INTRO_Y,90,Ease.backOut);
         addTween(this.introTween,true);
         Assets.setMusic(Assets.MusBoss);
      }
   }
}
