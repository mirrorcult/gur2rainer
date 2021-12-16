package game.cosmetic
{
   import flash.display.BitmapData;
   import game.engine.Level;
   import net.flashpunk.graphics.Backdrop;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   
   public class BackgroundHard extends Background
   {
      
      public static const ImgBG:Class = BackgroundHard_ImgBG;
       
      
      private const STAR_HEIGHT:int = 180;
      
      private const STAR_WIDTH:int = 240;
      
      private const STARS_PER_FIELD:int = 60;
      
      public function BackgroundHard(level:Level)
      {
         var bg:Backdrop = null;
         var img:Image = null;
         layer = Main.DEPTH_BG;
         graphic = list = new Graphiclist();
         img = new Image(ImgBG);
         img.scrollX = img.scrollY = 0;
         list.add(img);
         super(level,12303291,0,0.1);
         bg = new Backdrop(this.generateStarfield(4286019447));
         bg.scrollX = bg.scrollY = 0.2;
         bg.x = Math.random() * 160;
         bg.y = Math.random() * 120;
         list.add(bg);
         bg = new Backdrop(this.generateStarfield(4290493371));
         bg.scrollX = bg.scrollY = 0.4;
         bg.x = Math.random() * 160;
         bg.y = Math.random() * 120;
         list.add(bg);
         bg = new Backdrop(this.generateStarfield(4293848814));
         bg.scrollX = bg.scrollY = 0.6;
         bg.x = Math.random() * 160;
         bg.y = Math.random() * 120;
         list.add(bg);
      }
      
      private function generateStarfield(starColor:uint) : BitmapData
      {
         var bd:BitmapData = new BitmapData(this.STAR_WIDTH,this.STAR_HEIGHT,true,0);
         for(var i:int = 0; i < this.STARS_PER_FIELD; i++)
         {
            bd.setPixel32(Math.random() * this.STAR_WIDTH,Math.random() * this.STAR_HEIGHT,starColor);
         }
         return bd;
      }
   }
}
