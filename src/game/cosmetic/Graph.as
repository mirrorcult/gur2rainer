package game.cosmetic
{
   import flash.display.BitmapData;
   import game.engine.Assets;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Text;
   import net.flashpunk.tweens.misc.Alarm;
   import net.flashpunk.utils.Draw;
   import net.flashpunk.utils.Input;
   
   public class Graph extends Entity
   {
       
      
      private var coins:Image;
      
      private const TEXT2_X:int = 75;
      
      private const TEXT_X:int = 5;
      
      private var realDeathsData:BitmapData;
      
      private var deathsData:BitmapData;
      
      private var time:Image;
      
      private var timeData:BitmapData;
      
      private var coinsData:BitmapData;
      
      private var realCoinsData:BitmapData;
      
      private var list:Graphiclist;
      
      private var win:YouWin;
      
      private var realTimeData:BitmapData;
      
      private const WIDTH:int = 300;
      
      private const HEIGHT:int = 120;
      
      private var progress:int = 0;
      
      private var mode:int = -1;
      
      private var deaths:Image;
      
      public function Graph(win:YouWin, x:int, y:int)
      {
         var i:int = 0;
         var highest:int = 0;
         var levels:int = 0;
         var xAdd:Number = NaN;
         var yAdd:Number = NaN;
         super(x,y);
         this.win = win;
         addTween(new Alarm(60,this.doDeaths,Tween.ONESHOT),true);
         graphic = this.list = new Graphiclist();
         if(Main.saveData.mode == 1 && Main.saveData.s_time[Assets.LEVELS[1] - 1] == 0)
         {
            levels = Assets.LEVELS[1] - 1;
         }
         else
         {
            levels = Assets.LEVELS[Main.saveData.mode];
         }
         xAdd = this.WIDTH / (levels - 1);
         this.realDeathsData = new BitmapData(this.WIDTH,this.HEIGHT + 1,true,0);
         Draw.setTarget(this.realDeathsData);
         highest = 0;
         for(i = 1; i < levels; i++)
         {
            if(Main.saveData.s_deaths[i] > highest)
            {
               highest = Main.saveData.s_deaths[i];
            }
         }
         if(highest == 0)
         {
            yAdd = 0;
         }
         else
         {
            yAdd = this.HEIGHT / highest;
         }
         for(i = 1; i < levels; i++)
         {
            Draw.line((i - 1) * xAdd,this.HEIGHT - Main.saveData.s_deaths[i - 1] * yAdd,i * xAdd,this.HEIGHT - Main.saveData.s_deaths[i] * yAdd,16711680);
         }
         Draw.resetTarget();
         this.deathsData = new BitmapData(this.WIDTH,this.HEIGHT + 1,true,0);
         this.deaths = new Image(this.deathsData);
         this.list.add(this.deaths);
         this.realCoinsData = new BitmapData(this.WIDTH,this.HEIGHT + 1,true,0);
         Draw.setTarget(this.realCoinsData);
         highest = 0;
         for(i = 1; i < levels; i++)
         {
            if(Main.saveData.s_coins[i] > highest)
            {
               highest = Main.saveData.s_coins[i];
            }
         }
         if(highest == 0)
         {
            yAdd = 0;
         }
         else
         {
            yAdd = this.HEIGHT / highest;
         }
         for(i = 1; i < levels; i++)
         {
            Draw.line((i - 1) * xAdd,this.HEIGHT - Main.saveData.s_coins[i - 1] * yAdd,i * xAdd,this.HEIGHT - Main.saveData.s_coins[i] * yAdd,16776960);
         }
         Draw.resetTarget();
         this.coinsData = new BitmapData(this.WIDTH,this.HEIGHT + 1,true,0);
         this.coins = new Image(this.coinsData);
         this.list.add(this.coins);
         this.realTimeData = new BitmapData(this.WIDTH,this.HEIGHT + 1,true,0);
         Draw.setTarget(this.realTimeData);
         highest = 0;
         for(i = 1; i < levels; i++)
         {
            if(Main.saveData.s_time[i] > highest)
            {
               highest = Main.saveData.s_time[i];
            }
         }
         if(highest == 0)
         {
            yAdd = 0;
         }
         else
         {
            yAdd = this.HEIGHT / highest;
         }
         for(i = 1; i < levels; i++)
         {
            Draw.line((i - 1) * xAdd,this.HEIGHT - Main.saveData.s_time[i - 1] * yAdd,i * xAdd,this.HEIGHT - Main.saveData.s_time[i] * yAdd,65535);
         }
         Draw.resetTarget();
         this.timeData = new BitmapData(this.WIDTH,this.HEIGHT + 1,true,0);
         this.time = new Image(this.timeData);
         this.list.add(this.time);
      }
      
      override public function update() : void
      {
         if(this.mode == 0)
         {
            this.progress = this.progress + 2;
            FP.rect.x = FP.rect.y = 0;
            FP.rect.height = this.HEIGHT + 1;
            FP.rect.width = this.progress;
            FP.point.x = FP.point.y = 0;
            this.deathsData.copyPixels(this.realDeathsData,FP.rect,FP.point);
            this.deaths.updateBuffer();
            if(this.progress == this.WIDTH)
            {
               this.mode = -1;
               addTween(new Alarm(90,this.doCoins,Tween.ONESHOT),true);
            }
         }
         else if(this.mode == 1)
         {
            this.progress = this.progress + 2;
            FP.rect.x = FP.rect.y = 0;
            FP.rect.height = this.HEIGHT + 1;
            FP.rect.width = this.progress;
            FP.point.x = FP.point.y = 0;
            this.coinsData.copyPixels(this.realCoinsData,FP.rect,FP.point);
            this.coins.updateBuffer();
            if(this.progress == this.WIDTH)
            {
               this.mode = -1;
               addTween(new Alarm(90,this.doTime,Tween.ONESHOT),true);
            }
         }
         else if(this.mode == 2)
         {
            this.progress = this.progress + 2;
            FP.rect.x = FP.rect.y = 0;
            FP.rect.height = this.HEIGHT + 1;
            FP.rect.width = this.progress;
            FP.point.x = FP.point.y = 0;
            this.timeData.copyPixels(this.realTimeData,FP.rect,FP.point);
            this.time.updateBuffer();
            if(this.progress == this.WIDTH)
            {
               this.mode = 3;
               this.win.finishStep();
            }
         }
         else if(this.mode == 3)
         {
            if(Input.pressed("up"))
            {
               if(this.coins.alpha == 1)
               {
                  this.deaths.alpha = 1;
                  this.coins.alpha = 0.3;
                  this.time.alpha = 0.3;
                  this.list.add(this.list.remove(this.deaths));
               }
               else if(this.time.alpha == 1)
               {
                  this.deaths.alpha = 0.3;
                  this.coins.alpha = 1;
                  this.time.alpha = 0.3;
                  this.list.add(this.list.remove(this.coins));
               }
            }
            else if(Input.pressed("down"))
            {
               if(this.deaths.alpha == 1)
               {
                  this.deaths.alpha = 0.3;
                  this.coins.alpha = 1;
                  this.time.alpha = 0.3;
                  this.list.add(this.list.remove(this.coins));
               }
               else if(this.coins.alpha == 1)
               {
                  this.deaths.alpha = 0.3;
                  this.coins.alpha = 0.3;
                  this.time.alpha = 1;
                  this.list.add(this.list.remove(this.time));
               }
            }
         }
      }
      
      private function doTime() : void
      {
         var text:Text = null;
         this.coins.alpha = 0.3;
         this.mode = 2;
         this.progress = 0;
         var oldSize:int = Text.size;
         Text.size = 16;
         text = new Text("Time:",this.TEXT_X,8);
         text.color = 65535;
         this.list.add(text);
         text = new Text(Main.formatTime(Main.saveData.time),this.TEXT2_X,8);
         text.color = 65535;
         this.list.add(text);
         Text.size = oldSize;
      }
      
      private function doDeaths() : void
      {
         var text:Text = null;
         this.mode = 0;
         this.progress = 0;
         var oldSize:int = Text.size;
         Text.size = 16;
         text = new Text("Deaths:",this.TEXT_X,-20);
         text.color = 16711680;
         this.list.add(text);
         text = new Text(String(Main.saveData.deaths),this.TEXT2_X,-20);
         text.color = 16711680;
         this.list.add(text);
         Text.size = oldSize;
      }
      
      private function doCoins() : void
      {
         var text:Text = null;
         this.deaths.alpha = 0.3;
         this.mode = 1;
         this.progress = 0;
         var oldSize:int = Text.size;
         Text.size = 16;
         text = new Text("Coins:",this.TEXT_X,-6);
         text.color = 16776960;
         this.list.add(text);
         text = new Text(String(Main.saveData.coins),this.TEXT2_X,-6);
         text.color = 16776960;
         this.list.add(text);
         Text.size = oldSize;
      }
   }
}
