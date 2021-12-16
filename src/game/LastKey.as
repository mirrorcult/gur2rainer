package game
{
   import flash.geom.Point;
   import game.cosmetic.Flash;
   import game.cosmetic.GetLastKey;
   import game.cosmetic.PlayerFly;
   import game.engine.Assets;
   import game.engine.Grabbable;
   import game.engine.Level;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.tweens.misc.Alarm;
   import net.flashpunk.tweens.motion.QuadMotion;
   import net.flashpunk.utils.Ease;
   
   public class LastKey extends Grabbable
   {
       
      
      private var sprite:Spritemap;
      
      private var done:Boolean = false;
      
      private var glow:Image;
      
      private var finish:Boolean = false;
      
      private var sine:Number = 0;
      
      private var list:Graphiclist;
      
      private var player:Player;
      
      private var quadTween:QuadMotion;
      
      private var boss:BossChase;
      
      private var vSpeed:Number = 0;
      
      private var grabbed:Boolean = false;
      
      private var startX:Number;
      
      private var startY:Number;
      
      public function LastKey(player:Player, boss:BossChase, x:int, y:int)
      {
         super(x,y);
         this.player = player;
         this.boss = boss;
         this.startX = x;
         this.startY = y;
         type = "key";
         width = 20;
         height = 20;
         originX = 10;
         originY = 10;
         layer = Main.DEPTH_ITEMS;
         grapplePoint = new Point();
         graphic = this.list = new Graphiclist();
         this.glow = new Image(Jetpack.ImgBG);
         this.glow.centerOO();
         this.glow.scale = 3;
         this.glow.color = 16776960;
         this.glow.alpha = 0.5;
         this.list.add(this.glow);
         this.sprite = new Spritemap(EndKey.ImgKey,12,16);
         this.sprite.add("go",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],0.15);
         this.sprite.add("fly",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],0.6);
         this.sprite.play("go");
         this.sprite.centerOO();
         this.sprite.scale = 2;
         this.list.add(this.sprite);
      }
      
      private function theEnd() : void
      {
         this.player.win();
      }
      
      override public function update() : void
      {
         if(this.done)
         {
            return;
         }
         if(this.grabbed)
         {
            this.glow.angle = this.glow.angle - 3;
            if(this.quadTween && this.quadTween.active)
            {
               x = this.quadTween.x;
               y = this.quadTween.y;
               this.sprite.angle = FP.angle(this.player.x,this.player.y,x,y) + 90;
            }
            else
            {
               this.sprite.angle = this.sprite.angle + Main.rotateToward(this.sprite.angle,180,5);
               if(this.finish)
               {
                  if(this.vSpeed == 0)
                  {
                     this.vSpeed = -0.01;
                  }
                  else
                  {
                     this.vSpeed = Math.max(this.vSpeed * 1.2,-5);
                  }
                  y = y + this.vSpeed;
                  if(this.player.y < -32)
                  {
                     this.done = true;
                     this.player.active = false;
                     FP.world.add(new PlayerFly(-160,250));
                     addTween(new Alarm(120,this.theEnd,Tween.ONESHOT),true);
                  }
               }
            }
            if(grapple)
            {
               FP.angleXY(FP.point,90 + this.sprite.angle,5 * this.sprite.scale);
               grapple.x = x + FP.point.x;
               grapple.y = y + FP.point.y;
            }
            if(!this.player.active && !this.finish)
            {
               this.player.lastKeyUpdate();
            }
            return;
         }
         if(x > FP.camera.x + 360)
         {
            return;
         }
         this.glow.angle = this.glow.angle - 1;
         this.sine = (this.sine + Math.PI / 32) % (Math.PI * 4);
         x = this.startX + Math.sin(this.sine / 2) * 6;
         y = this.startY + Math.sin(this.sine) * 6;
      }
      
      private function updatePositions() : void
      {
         x = this.quadTween.x;
         y = this.quadTween.y;
         if(this.boss.quadTween)
         {
            this.boss.x = this.boss.quadTween.x;
            this.boss.y = this.boss.quadTween.y;
         }
      }
      
      private function attack3() : void
      {
         this.updatePositions();
         Assets.SndKeyHitBoss.play();
         Assets.playHitBoss();
         Main.particles.addParticlesArea("missileExplode",x,y,32,24,8);
         Main.screenShake(1);
         this.boss.quadTween = new QuadMotion(null,Tween.ONESHOT);
         this.boss.quadTween.setMotion(this.boss.x,this.boss.y,this.boss.x + 64,this.boss.y + 128,this.boss.x,this.boss.y + 24,30,Ease.quadOut);
         this.boss.addTween(this.boss.quadTween,true);
         this.quadTween = new QuadMotion(this.attack4,Tween.ONESHOT);
         this.quadTween.setMotion(x,y,x + 64,-64,x,y + 24,30,Ease.quadIn);
         addTween(this.quadTween,true);
      }
      
      private function attack7() : void
      {
         this.updatePositions();
         this.quadTween = new QuadMotion(this.attack8,Tween.ONESHOT);
         this.quadTween.setMotion(x,y,x - 96,y - 256,x + 64,y - 128,50,Ease.quadOut);
         addTween(this.quadTween,true);
         Main.screenShake(2);
         FP.world.add(new Flash());
         Assets.SndBossDie.play();
         Main.particles.addParticlesArea("missileExplode",this.boss.x + 16,this.boss.y + 4,32,24,20);
         FP.world.remove(this.boss);
      }
      
      override public function onGrapple() : void
      {
         if(Assets.voice.playing)
         {
            Assets.voice.stop();
         }
         Assets.SndGetKey.play();
         Assets.setMusic();
         (FP.world as Level).countTime = false;
         this.sprite.frame = 0;
         this.glow.alpha = 1;
         this.player.grabLastKey();
         FP.world.add(new GetLastKey(this));
         this.boss.endMode();
      }
      
      private function attack5() : void
      {
         this.updatePositions();
         Assets.SndKeyHitBoss.play();
         Assets.playHitBoss();
         Main.particles.addParticlesArea("missileExplode",x,y,32,24,8);
         Main.screenShake(1);
         this.boss.quadTween = new QuadMotion(null,Tween.ONESHOT);
         this.boss.quadTween.setMotion(this.boss.x,this.boss.y,this.boss.x - 22,this.boss.y + 160,this.boss.x,this.boss.y - 48,90,Ease.quadOut);
         this.boss.addTween(this.boss.quadTween,true);
         this.quadTween = new QuadMotion(this.attack6,Tween.ONESHOT);
         this.quadTween.setMotion(x,y,x + 64,-64,x + 48,y - 224,60,Ease.quadOut);
         addTween(this.quadTween,true);
      }
      
      private function attack1() : void
      {
         this.quadTween = new QuadMotion(this.attack2,Tween.ONESHOT);
         this.quadTween.setMotion(x,y,this.boss.x + 12,y - 20,this.boss.x + 32,this.boss.y + 16,20,Ease.quadIn);
         addTween(this.quadTween,true);
      }
      
      private function attack2() : void
      {
         this.updatePositions();
         Assets.SndKeyHitBoss.play();
         Assets.playHitBoss();
         Main.particles.addParticlesArea("missileExplode",x,y,32,24,8);
         Main.screenShake(1);
         this.boss.quadTween = new QuadMotion(null,Tween.ONESHOT);
         this.boss.quadTween.setMotion(this.boss.x,this.boss.y,this.boss.x - 48,this.boss.y + 128,this.boss.x,this.boss.y + 32,60,Ease.quadOut);
         this.boss.addTween(this.boss.quadTween,true);
         this.quadTween = new QuadMotion(this.attack3,Tween.ONESHOT);
         this.quadTween.setMotion(x,y,x + 64,-64,x,y + 32,60,Ease.quadIn);
         addTween(this.quadTween,true);
      }
      
      public function fly() : void
      {
         FP.world.add(new Flash());
         this.grabbed = true;
         this.sprite.angle = 180;
         this.sprite.play("fly");
         this.glow.alpha = 0.5;
         addTween(new Alarm(60,this.attack1,Tween.ONESHOT),true);
         Assets.setMusic(Assets.MusGetKey,false);
      }
      
      private function attack4() : void
      {
         this.updatePositions();
         Assets.SndKeyHitBoss.play();
         Assets.playHitBoss();
         Main.particles.addParticlesArea("missileExplode",x,y,32,24,8);
         Main.screenShake(1);
         this.boss.quadTween = new QuadMotion(null,Tween.ONESHOT);
         this.boss.quadTween.setMotion(this.boss.x,this.boss.y,this.boss.x - 32,this.boss.y + 80,this.boss.x,this.boss.y + 40,42,Ease.quadOut);
         this.boss.addTween(this.boss.quadTween,true);
         this.quadTween = new QuadMotion(this.attack5,Tween.ONESHOT);
         this.quadTween.setMotion(x,y,x + 64,-64,x,y + 40,42,Ease.quadIn);
         addTween(this.quadTween,true);
      }
      
      private function attack6() : void
      {
         this.updatePositions();
         this.quadTween = new QuadMotion(this.attack7,Tween.ONESHOT);
         this.quadTween.setMotion(x,y,x - 128,y - 128,x - 48,y + 176,30,Ease.cubeIn);
         addTween(this.quadTween,true);
      }
      
      private function attack8() : void
      {
         this.player.active = true;
         this.player.canRelease = false;
         this.player.momentum = 0;
         this.finish = true;
         var arr:Array = new Array();
         FP.world.getClass(EdgeBlock,arr);
         for(var i:int = 0; i < arr.length; i++)
         {
            FP.world.remove(arr[i]);
         }
      }
   }
}
