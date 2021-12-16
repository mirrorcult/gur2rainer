package game.engine
{
   import game.Block;
   import game.Player;
   import net.flashpunk.masks.Grid;
   
   public class Blocks extends Block
   {
       
      
      public var grid:Grid;
      
      public function Blocks(player:Player, level:Level)
      {
         super(player,0,0,level.width,level.height);
         mask = this.grid = new Grid(level.width,level.height,8,8);
      }
   }
}
