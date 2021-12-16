package game.cosmetic
{
   import flash.display.BitmapData;
   import game.engine.Level;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Text;
   import net.flashpunk.utils.Input;
   import net.flashpunk.utils.Key;
   
   public class LevelComplete extends Entity
   {
       
      
      private var C_BG:uint = 6729505;
      
      private var bg:Image;
      
      private var coins:Text;
      
      private var C_TEXT:uint = 16777013;
      
      private var time:Text;
      
      private var sine:Number = 0;
      
      private var title:Text;
      
      private var list:Graphiclist;
      
      public function LevelComplete()
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
         this.title = new Text("Level Complete!",160,40);
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
         Text.size = 8;
         text = new Text("ENTER - Restart              ESC - Menu",160,234);
         text.scrollX = text.scrollY = 0;
         text.color = this.C_TEXT;
         text.centerOO();
         this.list.add(text);
      }
      
      override public function update() : void
      {
         this.sine = (this.sine + Math.PI / 64) % (Math.PI * 2);
         this.bg.alpha = Math.min(0.75,this.bg.alpha + 0.1);
         this.coins.alpha = this.time.alpha = this.title.alpha = Math.min(1,this.title.alpha + 0.1);
         if(Input.pressed(Key.ENTER))
         {
            FP.world.add(new Transition((FP.world as Level).restart));
         }
      }
   }
}
