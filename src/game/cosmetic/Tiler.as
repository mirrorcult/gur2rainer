package game.cosmetic
{
   import game.engine.Level;
   import net.flashpunk.Entity;
   import net.flashpunk.masks.Grid;
   
   public class Tiler extends Entity
   {
       
      
      private var level:Level;
      
      public function Tiler(level:Level, func:Function = null)
      {
         super();
         layer = Main.DEPTH_TILES;
         this.level = level;
         if(func != null)
         {
            this.autoTile(func);
         }
      }
      
      protected function autoTile(func:Function) : void
      {
         var j:int = 0;
         var atTop:* = false;
         var atBottom:* = false;
         var atLeft:* = false;
         var atRight:* = false;
         var above:Boolean = false;
         var below:Boolean = false;
         var left:Boolean = false;
         var right:Boolean = false;
         var row:int = 0;
         var col:int = 0;
         this.level.updateLists();
         var grid:Grid = this.level.blocks.grid;
         for(var i:int = 0; i < grid.columns; i++)
         {
            for(j = 0; j < grid.rows; j++)
            {
               if(grid.getCell(i,j))
               {
                  atTop = j == 0;
                  atBottom = j == grid.rows - 1;
                  atLeft = i == 0;
                  atRight = i == grid.columns - 1;
                  above = atTop || grid.getCell(i,j - 1);
                  below = atBottom || grid.getCell(i,j + 1);
                  left = atLeft || grid.getCell(i - 1,j);
                  right = atRight || grid.getCell(i + 1,j);
                  row = i * 2;
                  col = j * 2;
                  if(above)
                  {
                     if(left)
                     {
                        if(!atTop && !atLeft && !grid.getCell(i - 1,j - 1))
                        {
                           func(row,col,4);
                        }
                        else
                        {
                           func(row,col,3);
                        }
                     }
                     else
                     {
                        func(row,col,2);
                     }
                  }
                  else if(left)
                  {
                     func(row,col,1);
                  }
                  else
                  {
                     func(row,col,0);
                  }
                  if(above)
                  {
                     if(right)
                     {
                        if(!atTop && !atRight && !grid.getCell(i + 1,j - 1))
                        {
                           func(row + 1,col,9);
                        }
                        else
                        {
                           func(row + 1,col,8);
                        }
                     }
                     else
                     {
                        func(row + 1,col,7);
                     }
                  }
                  else if(right)
                  {
                     func(row + 1,col,6);
                  }
                  else
                  {
                     func(row + 1,col,5);
                  }
                  if(below)
                  {
                     if(left)
                     {
                        if(!atBottom && !atLeft && !grid.getCell(i - 1,j + 1))
                        {
                           func(row,col + 1,14);
                        }
                        else
                        {
                           func(row,col + 1,13);
                        }
                     }
                     else
                     {
                        func(row,col + 1,12);
                     }
                  }
                  else if(left)
                  {
                     func(row,col + 1,11);
                  }
                  else
                  {
                     func(row,col + 1,10);
                  }
                  if(below)
                  {
                     if(right)
                     {
                        if(!atBottom && !atRight && !grid.getCell(i + 1,j + 1))
                        {
                           func(row + 1,col + 1,19);
                        }
                        else
                        {
                           func(row + 1,col + 1,18);
                        }
                     }
                     else
                     {
                        func(row + 1,col + 1,17);
                     }
                  }
                  else if(right)
                  {
                     func(row + 1,col + 1,16);
                  }
                  else
                  {
                     func(row + 1,col + 1,15);
                  }
               }
            }
         }
      }
   }
}
