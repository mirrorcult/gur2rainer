package game.cosmetic
{
   import flash.display.BitmapData;
   import game.Player;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Image;
   
   public class IntroShadow extends Image
   {
       
      
      private var player:Player;
      
      private var data:BitmapData;
      
      public function IntroShadow(player:Player)
      {
         this.player = player;
         this.data = new BitmapData(32,24,true,4278190080);
         super(this.data);
         active = true;
         scrollY = 0;
         scrollX = 0;
         scale = 10;
         alpha = 0.5;
      }
      
      override public function update() : void
      {
         FP.rect.x = 0;
         FP.rect.y = 0;
         FP.rect.width = 32;
         FP.rect.height = 24;
         this.data.fillRect(FP.rect,4278190080);
         if(this.player && this.player.active)
         {
            FP.rect.x = Math.round((this.player.x - FP.camera.x - 40) / 10);
            FP.rect.y = Math.round((this.player.y - FP.camera.y - 40) / 10);
            FP.rect.width = 8;
            FP.rect.height = 8;
            this.data.fillRect(FP.rect,3137339392);
            FP.rect.x++;
            FP.rect.y++;
            FP.rect.width = FP.rect.width - 2;
            FP.rect.height = FP.rect.height - 2;
            this.data.fillRect(FP.rect,1711276032);
            FP.rect.x++;
            FP.rect.y++;
            FP.rect.width = FP.rect.width - 2;
            FP.rect.height = FP.rect.height - 2;
            this.data.fillRect(FP.rect,0);
         }
         updateBuffer();
      }
   }
}
