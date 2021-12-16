package game.cosmetic
{
   import flash.display.BitmapData;
   import net.flashpunk.graphics.Spritemap;
   
   public class Face extends Spritemap
   {
      
      private static const ImgFaces:Class = Face_ImgFaces;
      
      private static const DataFaces:BitmapData = new ImgFaces().bitmapData;
       
      
      public function Face(x:int, y:int, callback:Function = null)
      {
         super(DataFaces,8,8,callback);
         this.x = x - 4;
         this.y = y - 4;
         originX = 4;
         originY = 4;
         add("happy",[0]);
         add("surprised",[1]);
         add("sad",[6]);
         add("horrified",[2]);
         add("pain",[3]);
         add("laughing",[4,5],0.15);
         add("dont",[7]);
         add("surprised_talk",[1,7,1,7,1,7,1,7,1,7],0.15,false);
         play("happy");
      }
   }
}
