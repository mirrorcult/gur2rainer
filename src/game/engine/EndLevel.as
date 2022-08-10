package game.engine
{
   import game.EdgeBlock;
   import game.EndKey;
   
   public class EndLevel extends Level
   {
      public function EndLevel(num:uint)
      {
         super(0,num);
         Main.LevelType = Main.TYPE_START_OR_END;
      }
      
      override protected function specifics() : void
      {
         add(new EndKey(player,160,height - 144));
         add(new EdgeBlock(320,0,8,height));
      }
      
      override protected function loadLevel(mode:uint, num:uint) : void
      {
         var world:uint = 0;
         if(num >= WORLD3)
         {
            world = 2;
         }
         else if(num >= WORLD2)
         {
            world = 1;
         }
         load(new Assets["E" + world]());
         _countTime = false;
      }
   }
}
