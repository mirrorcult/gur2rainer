package game
{
   import flash.geom.Point;
   import game.cosmetic.Flash;
   import game.cosmetic.GetKey;
   import game.cosmetic.PlayerFly;
   import game.cosmetic.WorldComplete;
   import game.engine.Assets;
   import game.engine.Grabbable;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class EndKey extends Grabbable
   {
      
      public static const ImgKey:Class = EndKey_ImgKey;
       
      
      private var sprite:Spritemap;
      
      private const ACCEL:Number = 0.05;
      
      private const C_GLOW:uint = 16776960;
      
      private var glow:Image;
      
      private var flying:Boolean = false;
      
      private var done:Boolean = false;
      
      private var sine:Number = 0;
      
      private const MAX_V:Number = -5;
      
      private var player:Player;
      
      private var list:Graphiclist;
      
      private var vSpeed:Number = 0;
      
      private var startY:Number;
      
      private var startX:Number;
      
      public function EndKey(player:Player, x:int, y:int)
      {
         super(x,y);
         this.player = player;
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
         this.glow.originX = this.glow.originY = 12;
         this.glow.x = -12;
         this.glow.y = -9;
         this.glow.scale = 3;
         this.glow.color = this.C_GLOW;
         this.glow.alpha = 0.5;
         this.list.add(this.glow);
         this.sprite = new Spritemap(ImgKey,12,16);
         this.sprite.add("go",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],0.15);
         this.sprite.add("fly",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],0.3);
         this.sprite.play("go");
         this.sprite.originX = 6;
         this.sprite.originY = 3;
         this.sprite.x = -6;
         this.sprite.y = -8;
         this.sprite.scale = 2;
         this.list.add(this.sprite);
      }
      
      override public function update() : void
      {
         if(this.done)
         {
            return;
         }
         if(!this.flying)
         {
            this.glow.angle = this.glow.angle - 1;
            this.sine = (this.sine + Math.PI / 32) % (Math.PI * 4);
            x = this.startX + Math.sin(this.sine / 2) * 6;
            y = this.startY + Math.sin(this.sine) * 6;
         }
         else
         {
            this.glow.angle = this.glow.angle - 3;
            Main.screenShake(0);
            this.vSpeed = Math.max(this.vSpeed - this.ACCEL,this.MAX_V);
         }
         if(this.vSpeed != 0)
         {
            y = y + this.vSpeed;
            grapple.move(0,this.vSpeed);
         }
         if(this.player.y < -6)
         {
            this.player.active = false;
            this.done = true;
            FP.world.add(new PlayerFly(-160,250));
            addTween(new Alarm(90,this.onAlarm,Tween.ONESHOT),true);
         }
      }
      
      override public function onGrapple() : void
      {
         Assets.SndGetKey.play();
         this.player.canRelease = false;
         this.flying = true;
         FP.world.add(new GetKey(this));
         this.sprite.frame = 0;
         this.glow.alpha = 1;
         Assets.setMusic();
      }
      
      private function onAlarm() : void
      {
         FP.world.remove(this);
         FP.world.add(new WorldComplete());
      }
      
      public function fly() : void
      {
         FP.world.add(new Flash());
         this.sprite.angle = 180;
         this.sprite.play("fly");
         this.glow.y = -22;
         this.glow.alpha = 0.5;
         Assets.setMusic(Assets.MusGetKey,false);
      }
   }
}
