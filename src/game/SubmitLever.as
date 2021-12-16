package game
{
   import flash.display.BitmapData;
   import game.cosmetic.SpeechBubble;
   import game.engine.Assets;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.tweens.misc.Alarm;
   import net.flashpunk.utils.Input;
   
   public class SubmitLever extends Block
   {
      
      public static const MODE_ADULTSWIM:uint = 0;
      
      public static const ImgFacebook:Class = SubmitLever_ImgFacebook;
      
      public static const ImgTwitter:Class = SubmitLever_ImgTwitter;
      
      public static const MODE_FACEBOOK:uint = 2;
      
      public static const MODE_TWITTER:uint = 1;
      
      public static const ImgAdultSwim:Class = SubmitLever_ImgAdultSwim;
       
      
      private const C_PULL:Array = [16770304,16383848,16766976];
      
      private const MAX_DOWN:Number = 0.6;
      
      private var sprite:Spritemap;
      
      private const ACCEL:Number = 0.01;
      
      private var image:Image;
      
      private var endY:int;
      
      private const C_NORMAL:Array = [16743107,7719679,5735628];
      
      private var list:Graphiclist;
      
      private var vSpeed:Number = 0;
      
      private var mode:uint;
      
      private var talk:Boolean = true;
      
      private const DISTANCE:int = 32;
      
      private var startY:int;
      
      private const MAX_UP:Number = -1.0;
      
      private const C_DONE:Array = [65280,11665269,7785559];
      
      public function SubmitLever(player:Player, x:int, y:int, mode:uint)
      {
         super(player,x,y,16,16);
         this.mode = mode;
         visible = true;
         active = true;
         layer = Main.DEPTH_ACTORS;
         this.startY = y;
         this.endY = y + this.DISTANCE;
         graphic = this.list = new Graphiclist();
         var bd:BitmapData = new BitmapData(4,this.DISTANCE + 12,true,4294967295);
         this.image = new Image(bd);
         this.image.relative = false;
         this.image.x = x + 6;
         this.image.y = y + 2;
         this.image.color = this.C_NORMAL[mode];
         this.image.alpha = 0.4;
         this.list.add(this.image);
         if(mode == MODE_ADULTSWIM)
         {
            this.sprite = new Spritemap(ImgAdultSwim,16,16);
         }
         else if(mode == MODE_TWITTER)
         {
            this.sprite = new Spritemap(ImgTwitter,16,16);
         }
         else if(mode == MODE_FACEBOOK)
         {
            this.sprite = new Spritemap(ImgFacebook,16,16);
         }
         this.sprite.add("normal",[0]);
         this.sprite.add("pull",[1]);
         this.sprite.add("done",[2]);
         this.sprite.play("normal");
         this.list.add(this.sprite);
      }
      
      override public function added() : void
      {
         if(collideWith(player,x,y))
         {
            if(player.grapple)
            {
               player.grapple.destroy();
            }
            player.y = player.y + 32;
         }
      }
      
      override public function update() : void
      {
         if(grapple)
         {
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
         if(this.vSpeed > 0 && y >= this.endY)
         {
            shake = 10;
            y = this.endY;
            this.vSpeed = 0;
            this.sprite.play("done");
            this.image.color = this.C_DONE[this.mode];
            active = false;
            Input.clear();
            Assets.SndLeverBottom.play();
            if(this.mode == MODE_ADULTSWIM)
            {
               Main.link("intermission");
            }
            else if(this.mode == MODE_TWITTER)
            {
               Main.submitTwitter();
            }
            else if(this.mode == MODE_FACEBOOK)
            {
               Main.submitFacebook();
            }
         }
         else if(this.vSpeed < 0 && y <= this.startY)
         {
            Assets.SndLeverTop.play();
            shake = 10;
            y = this.startY;
            this.vSpeed = 0;
         }
      }
      
      private function doTalk() : void
      {
         if(grapple)
         {
            this.talk = false;
            if(this.mode == MODE_ADULTSWIM)
            {
               FP.world.add(new SpeechBubble(x + 32,y - 10,"Play more\ngames!"));
            }
            else if(this.mode == MODE_TWITTER)
            {
               FP.world.add(new SpeechBubble(x + 32,y - 10,"Post score\non Twitter!"));
            }
            else if(this.mode == MODE_FACEBOOK)
            {
               FP.world.add(new SpeechBubble(x + 32,y - 10,"Share with\nFacebook!"));
            }
         }
      }
      
      override public function onRelease() : void
      {
         if(active)
         {
            this.sprite.play("normal");
            this.image.color = this.C_NORMAL[this.mode];
         }
      }
      
      override public function onGrapple() : void
      {
         if(active)
         {
            this.sprite.play("pull");
            this.image.color = this.C_PULL[this.mode];
            if(this.talk)
            {
               clearTweens();
               addTween(new Alarm(10,this.doTalk,Tween.ONESHOT),true);
            }
         }
      }
   }
}
