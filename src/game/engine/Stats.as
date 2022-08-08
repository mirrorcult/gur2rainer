package game.engine
{
   import flash.net.SharedObject;
   import flash.utils.Dictionary;
   import game.menus.MenuButton;
   
   public class Stats
   {
       
      
      public function Stats()
      {
         super();
      }

      public static function resetStats(button:MenuButton=null) : void
      {
         var obj:SharedObject = SharedObject.getLocal("data");
         obj.data.stats = null;
         initStats();
      }

      public static function logBestTime(key:String, time:uint) : void
      {
         var obj:SharedObject = SharedObject.getLocal("data");
         obj.data.stats.best_times[key] = time;
      }
      
      public static function logDeath() : void
      {
         var obj:SharedObject = SharedObject.getLocal("data");
         obj.data.stats.deaths++;
      }
      
      public static function getStats() : Object
      {
         var obj:SharedObject = SharedObject.getLocal("data");
         return obj.data.stats;
      }
      
      public static function logCompletion(mode:uint, deaths:uint, coins:uint, time:uint, score:uint) : void
      {
         var obj:SharedObject = SharedObject.getLocal("data");
         var s:Object = obj.data.stats;
         if(mode == 0)
         {
            if(s.comp_normal == 0)
            {
               s.best_coins_normal = coins;
               s.best_deaths_normal = deaths;
               s.best_time_normal = time;
               s.best_score_normal = score;
            }
            else
            {
               s.best_coins_normal = Math.max(s.best_coins_normal,coins);
               s.best_deaths_normal = Math.min(s.best_deaths_normal,deaths);
               s.best_time_normal = Math.min(s.best_time_normal,time);
               s.best_score_normal = Math.max(s.best_score_normal,score);
            }
            s.comp_normal++;
         }
         else if(mode == 1)
         {
            if(s.comp_hard == 0)
            {
               s.best_coins_hard = coins;
               s.best_deaths_hard = deaths;
               s.best_time_hard = time;
               s.best_score_hard = score;
            }
            else
            {
               s.best_coins_hard = Math.max(s.best_coins_hard,coins);
               s.best_deaths_hard = Math.min(s.best_deaths_hard,deaths);
               s.best_time_hard = Math.min(s.best_time_hard,time);
               s.best_score_hard = Math.max(s.best_score_hard,score);
            }
            s.comp_hard++;
         }
      }
      
      public static function initStats() : void
      {
         var s:Object = null;
         var obj:SharedObject = SharedObject.getLocal("data");
         if(obj.data.stats == null)
         {
            obj.data.stats = new Object();
            s = obj.data.stats;
            s.deaths = 0;
            s.comp_normal = 0;
            s.comp_hard = 0;
            s.best_coins_normal = 0;
            s.best_coins_hard = 0;
            s.best_deaths_normal = 0;
            s.best_deaths_hard = 0;
            s.best_time_normal = 0;
            s.best_time_hard = 0;
            s.best_score_normal = 0;
            s.best_score_hard = 0;
            s.best_times = new Dictionary();
         }
      }
   }
}
