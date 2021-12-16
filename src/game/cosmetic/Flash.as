package game.cosmetic
{
   import flash.display.BitmapData;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Image;
   
   public class Flash extends Entity
   {
       
      
      private var image:Image;
      
      private var long:Boolean;
      
      public function Flash(color:uint = 4.294967295E9, long:Boolean = false)
      {
         super();
         layer = Main.DEPTH_FUZZ + 1;
         this.long = long;
         var bd:BitmapData = new BitmapData(320,240,true,color);
         graphic = this.image = new Image(bd);
         this.image.scrollX = this.image.scrollY = 0;
         this.image.alpha = 1;
      }
      
      override public function update() : void
      {
         if(this.long)
         {
            this.image.alpha = this.image.alpha - 0.005;
         }
         else
         {
            this.image.alpha = this.image.alpha - 0.05;
         }
         if(this.image.alpha <= 0)
         {
            FP.world.remove(this);
         }
      }
   }
}
