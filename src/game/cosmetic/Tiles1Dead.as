package game.cosmetic
{
   import game.engine.Level;
   import net.flashpunk.graphics.Tilemap;
   
   public class Tiles1Dead extends Tiler
   {
      
      private static const ImgTilesDead:Class = Tiles1Dead_ImgTilesDead;
       
      
      public function Tiles1Dead(level:Level)
      {
         var t:Tilemap = null;
         t = new Tilemap(ImgTilesDead,level.width,level.height,4,4);
         graphic = t;
         super(level,t.setTile);
      }
   }
}
