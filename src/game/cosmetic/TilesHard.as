package game.cosmetic
{
   import game.engine.Level;
   import net.flashpunk.graphics.Tilemap;
   
   public class TilesHard extends Tiler
   {
      
      private static const ImgTiles:Class = TilesHard_ImgTiles;
       
      
      public function TilesHard(level:Level)
      {
         var t:Tilemap = null;
         t = new Tilemap(ImgTiles,level.width,level.height,4,4);
         graphic = t;
         super(level,t.setTile);
      }
   }
}
