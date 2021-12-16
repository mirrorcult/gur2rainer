package game.cosmetic
{
   import game.engine.Level;
   import net.flashpunk.graphics.Tilemap;
   
   public class Tiles2 extends Tiler
   {
      
      public static const ImgTiles:Class = Tiles2_ImgTiles;
       
      
      public function Tiles2(level:Level)
      {
         var t:Tilemap = null;
         t = new Tilemap(ImgTiles,level.width,level.height,4,4);
         graphic = t;
         super(level,t.setTile);
      }
   }
}
