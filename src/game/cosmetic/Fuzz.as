package game.cosmetic
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import net.flashpunk.graphics.Image;
   
   public class Fuzz extends Image
   {
       
      
      private const MAX:int = 4;
      
      private var data:BitmapData;
      
      private var count:int = 0;
      
      public function Fuzz()
      {
         this.data = new BitmapData(320,240);
         super(this.data);
         scrollY = 0;
         scrollX = 0;
         relative = false;
         active = true;
      }
      
      override public function render(point:Point, camera:Point) : void
      {
         super.render(point,camera);
      }
      
      override public function update() : void
      {
         if(this.count == 0)
         {
            this.data.noise(Math.random() * 100,50,180,7,true);
            updateBuffer();
            this.count = this.MAX;
         }
         this.count--;
      }
   }
}
