package game
{
   import game.cosmetic.SpeechBubble;
   import game.engine.Assets;
   import game.engine.Grabbable;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Spritemap;
   
   public class Cloud extends Grabbable
   {
      
      private static const ImgCloud:Class = Cloud_ImgCloud;
       
      
      private const FALL_MAX:Number = 0.4;
      
      private var player:Player;
      
      private const C_SIT:uint = 13227263;
      
      private var sprite:Spritemap;
      
      private const ACCEL:Number = 0.01;
      
      private const RISE:Number = -0.6;
      
      private var startY:int;
      
      private var vSpeed:Number = 0;
      
      private const C_SAD:uint = 10726606;
      
      public function Cloud(player:Player, x:int, y:int)
      {
         super(x,y);
         this.player = player;
         this.startY = y;
         layer = Main.DEPTH_ENVIRON;
         type = "cloud";
         width = 32;
         height = 16;
         graphic = this.sprite = new Spritemap(ImgCloud,32,16,this.animationEnd);
         this.sprite.originX = 16;
         this.sprite.originY = 8;
         this.sprite.add("sit",[0]);
         this.sprite.add("laugh",[1,2],0.15);
         this.sprite.add("surprised",[3],0.06);
         this.sprite.add("sad",[4],0.02);
         this.sprite.play("sit");
      }
      
      override public function update() : void
      {
         if(this.sprite.scale > 1)
         {
            this.sprite.scale = Math.max(1,this.sprite.scale - 0.05);
         }
         if(grapple)
         {
            if(this.player.onGround)
            {
               this.vSpeed = 0;
            }
            else
            {
               this.vSpeed = Math.min(this.FALL_MAX,this.vSpeed + this.ACCEL);
            }
         }
         else if(y > this.startY)
         {
            this.vSpeed = Math.max(this.vSpeed - this.ACCEL,this.startY - y,this.RISE);
         }
         else
         {
            this.vSpeed = 0;
         }
         y = y + this.vSpeed;
         if(grapple)
         {
            grapple.move(0,this.vSpeed);
         }
      }
      
      override public function onRelease() : void
      {
         this.sprite.play("sad");
         this.sprite.scale = 1.5;
      }
      
      private function animationEnd() : void
      {
         if(this.sprite.currentAnim == "surprised")
         {
            if(FP.choose(true,true,false))
            {
               Assets.SndCloudTalk.play();
               FP.world.add(new SpeechBubble(x + 40,y - 12,FP.choose("Use me!","Don\'t stop!","That tickles!","Oh, my!","Hold me!","That\'s the\nspot!","Oooooh!","Harder!")));
            }
            this.sprite.play("laugh");
         }
         else if(this.sprite.currentAnim == "sad")
         {
            this.sprite.play("sit");
         }
      }
      
      override public function onGrapple() : void
      {
         this.sprite.play("surprised");
         this.sprite.scale = 1.5;
      }
   }
}
