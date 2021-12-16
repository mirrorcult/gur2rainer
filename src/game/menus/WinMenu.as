package game.menus
{
   import game.cosmetic.MenuBG;
   import game.cosmetic.YouWin;
   import game.engine.Assets;
   import game.engine.MattWorld;
   import game.engine.Stats;
   
   public class WinMenu extends MattWorld
   {
       
      
      private var canMove:Boolean = false;
      
      private var menu:uint = 0;
      
      public function WinMenu()
      {
         super();
      }
      
      override public function begin() : void
      {
         super.begin();
         Main.clearGame();
         if(Main.saveData.mode == 0)
         {
            Main.beatNormal();
         }
         else
         {
            Main.beatHard();
         }
         Stats.logCompletion(Main.saveData.mode,Main.saveData.deaths,Main.saveData.coins,Main.saveData.time,Main.saveData.getScore());
         add(new MenuBG());
         add(new YouWin(0,0));
         Assets.SndWorldComplete.play();
         Assets.setMusic(Assets.MusBoss);
      }
   }
}
