package game.cosmetic
{
   import flash.display.BitmapData;
   import game.engine.Level;
   import game.engine.Stats;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Text;
   import net.flashpunk.utils.Input;
   import net.flashpunk.utils.Key;
   import game.Options;
   
   public class LevelComplete extends Entity
   {
       
      
      private var C_BG:uint = 0x1a7574;
      
      private var bg:Image;
      
      private var coins:Text;
      
      private var C_TEXT:uint = 0xffffff;
      
      private var time:Text;

      private var bestTime:Text;
      
      private var sine:Number = 0;
      
      private var title:Text;
      
      // bottom text
      private var bottomText:Text;

      private var savedTas:Boolean;
      
      private var list:Graphiclist;
      
      public function LevelComplete(newHighScore:Boolean=false)
      {
         var text:Text = null;
         super();
         layer = Main.DEPTH_FUZZ + 2;
         graphic = this.list = new Graphiclist();
         var bd:BitmapData = new BitmapData(320,240,true,4294967295);
         this.bg = new Image(bd);
         this.bg.color = this.C_BG;
         this.bg.scrollX = this.bg.scrollY = 0;
         this.bg.alpha = 0;
         this.list.add(this.bg);
         Text.size = 32;
         this.title = new Text("TAS",160,40);
         this.title.scrollX = this.title.scrollY = 0;
         this.title.color = this.C_TEXT;
         this.title.alpha = 0;
         this.title.centerOO();
         this.list.add(this.title);
         Text.size = 24;
         this.coins = new Text("Coins: " + Main.saveData.coins,160,120);
         this.coins.scrollX = this.coins.scrollY = 0;
         this.coins.color = this.C_TEXT;
         this.coins.alpha = 0;
         this.coins.centerOO();
         this.list.add(this.coins);
         this.time = new Text(Main.formatTime(Main.saveData.time),160,150);
         this.time.scrollX = this.time.scrollY = 0;
         this.time.color = this.C_TEXT;
         this.time.alpha = 0;
         this.time.centerOO();
         this.list.add(this.time);
         var stats:Object = Stats.getStats();
         if (stats.best_times[(FP.world as Level).toString()] != null)
         {
            this.bestTime = new Text((newHighScore ? "New Best! " : "Best: ") + Main.formatTime(stats.best_times[(FP.world as Level).toString()]), 160, 180)
         }
         else
         {
            this.bestTime = new Text("No Best Time",160,180);
         }

         this.bestTime.scrollX = this.bestTime.scrollY = 0;
         this.bestTime.color = this.C_TEXT;
         this.bestTime.alpha = 0;
         this.bestTime.centerOO();
         this.list.add(this.bestTime);
         
         Text.size = 8;
         this.bottomText = new Text("ENTER - Restart                T - Save TAS File",160,234);

         this.bottomText.scrollX = this.bottomText.scrollY = 0;
         this.bottomText.color = this.C_TEXT;
         this.bottomText.centerOO();
         this.list.add(this.bottomText);

         var level:Level = (FP.world as Level);
         if (Options.tasRecordingState == Options.tasRecordingStateAll
         || (Options.tasRecordingState == Options.tasRecordingStateFastest && newHighScore))
         {
            this.savedTas = true;
            FP.tas.Write(level);
            this.bottomText.text = "ENTER - Restart                Saved TAS file!  ";
            this.bottomText.centerOO();
         }
      }
      
      override public function update() : void
      {
         this.sine = (this.sine + Math.PI / 64) % (Math.PI * 2);
         this.bg.alpha = Math.min(0.75,this.bg.alpha + 0.1);
         this.coins.alpha = this.time.alpha = this.title.alpha = this.bestTime.alpha = Math.min(1,this.title.alpha + 0.1);
         if(Input.pressed(Key.ENTER))
         {
            FP.world.add(new Transition((FP.world as Level).restart));
         }
         if (Input.pressed("tas") && !savedTas)
         {
            // Save tas file
            FP.tas.Write(FP.world as Level);
            this.bottomText.text = "ENTER - Restart                Saved TAS file!  ";
            this.bottomText.centerOO();
            savedTas = true;
         }
      }
   }
}
