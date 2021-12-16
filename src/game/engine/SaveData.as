package game.engine
{
   import net.flashpunk.FP;
   
   public class SaveData
   {
       
      
      public var coins:uint;
      
      private const SCORE_COIN:int = 100;
      
      public var startLevel:Boolean;
      
      public var level:uint;
      
      public var time:uint;
      
      public var s_deaths:Vector.<uint>;
      
      private const SCORE_LEVEL:int = 144000;
      
      public var s_time:Vector.<uint>;
      
      public var mode:uint;
      
      public var keyLevel:Boolean;
      
      public var s_coins:Vector.<uint>;
      
      private const SCORE_TIME:int = 2;
      
      public var deaths:uint;
      
      public function SaveData(obj:Object = null)
      {
         super();
         if(obj)
         {
            this.level = obj.level;
            this.mode = obj.mode;
            this.coins = obj.coins;
            this.deaths = obj.deaths;
            this.time = obj.time;
            this.keyLevel = obj.keyLevel;
            this.startLevel = obj.startLevel;
            this.s_deaths = obj.s_deaths;
            this.s_coins = obj.s_coins;
            this.s_time = obj.s_time;
         }
         else
         {
            this.clearStats();
         }
      }
      
      public function getScoreString() : String
      {
         return Main.convertScoreString(this.getScore());
      }
      
      public function getScore() : int
      {
         var score:int = 0;
         score = score + this.SCORE_COIN * this.coins;
         score = score + this.SCORE_LEVEL * (this.level - 1);
         score = score - this.SCORE_TIME * this.time;
         return score;
      }
      
      private function clearStats() : void
      {
         this.level = 1;
         this.mode = 0;
         this.coins = 0;
         this.deaths = 0;
         this.time = 0;
         this.keyLevel = false;
         this.startLevel = false;
         this.s_deaths = new Vector.<uint>();
         this.s_coins = new Vector.<uint>();
         this.s_time = new Vector.<uint>();
      }
      
      public function addDeath() : void
      {
         this.deaths++;
         this.s_deaths[this.level - 1]++;
         this.s_time[this.level - 1] = this.s_time[this.level - 1] + (FP.world as Level).time;
         this.time = this.time + (FP.world as Level).time;
         Main.saveGame();
      }
      
      public function beatLevel(coins:uint, time:uint) : void
      {
         this.coins = this.coins + coins;
         if(!this.keyLevel && !this.startLevel)
         {
            this.s_coins[this.level - 1] = coins;
            this.time = this.time + time;
            this.s_time[this.level - 1] = this.s_time[this.level - 1] + time;
         }
         if(this.startLevel)
         {
            this.startLevel = false;
         }
         else if(this.keyLevel)
         {
            this.startLevel = true;
            this.keyLevel = false;
         }
         else
         {
            this.level++;
            if(this.mode == 0 && (this.level == Level.WORLD2 || this.level == Level.WORLD3))
            {
               this.keyLevel = true;
            }
         }
         Main.saveGame();
      }
      
      public function newGame(mode:uint) : void
      {
         this.clearStats();
         this.level = 1;
         this.mode = mode;
         for(var i:int = 0; i < Assets.LEVELS[mode]; i++)
         {
            this.s_deaths[i] = 0;
            this.s_coins[i] = 0;
            this.s_time[i] = 0;
         }
      }
   }
}
