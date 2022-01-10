package game.cosmetic
{
   import game.engine.Level;
   import game.engine.Stats;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.tweens.misc.Alarm;
   import flash.utils.Dictionary;
   
   public class Win extends Entity
   {
       
      
      private var timer:Alarm;
      
      public function Win()
      {
         this.timer = new Alarm(20,this.done,Tween.ONESHOT);
         super();
         addTween(this.timer,true);
      }
      
      private function done() : void
      {
         var level:Level = (FP.world as Level);
         if(level.practice && Main.saveData.time != 0)
         {
            var string:String = level.toString();
            var stats:Object = Stats.getStats();
            if (stats.best_times == null)
            {
               stats.best_times = new Dictionary();
            }
            if ((stats.best_times[string] == null ||
                stats.best_times[string] > Main.saveData.time) &&
                Main.saveData.time > 0)
            {
               Stats.logBestTime(string, Main.saveData.time);
               FP.world.add(new LevelComplete(true));
               return;
            }
            FP.world.add(new LevelComplete(false));
         }
         else
         {
            FP.world.add(new Transition(Main.getLevel()));
         }
      }
   }
}
