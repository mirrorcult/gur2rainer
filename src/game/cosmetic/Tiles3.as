package game.cosmetic
{
   import game.engine.Level;
   import net.flashpunk.graphics.Tilemap;
   
   public class Tiles3 extends Tiler
   {
      
      public static const ImgTiles:Class = Tiles3_ImgTiles;
       
      
      public function Tiles3(level:Level)
      {
         var t:Tilemap = null;
         t = new Tilemap(ImgTiles,level.width,level.height,4,4);
         graphic = t;
         super(level,t.setTile);
      }
   }
}
