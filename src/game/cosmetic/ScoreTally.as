package game.cosmetic
{
   import net.flashpunk.Entity;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Text;
   
   public class ScoreTally extends Entity
   {
       
      
      private var scoreX:int;
      
      private var scoreY:int;
      
      private var sine:Number = 0;
      
      private var coinsText:Text;
      
      private var coinsX:int;
      
      private var coinsY:int;
      
      private var timeText:Text;
      
      private var scoreText:Text;
      
      private var list:Graphiclist;
      
      private const C_TEXT:uint = 0;
      
      private var timeX:int;
      
      private const C_TEXT2:uint = 16777215;
      
      private var timeY:int;
      
      public function ScoreTally()
      {
         var text:Text = null;
         super();
         layer = Main.DEPTH_BGEFFECT;
         graphic = this.list = new Graphiclist();
         var oldSize:int = Text.size;
         Text.size = 8;
         text = new Text("score");
         text.color = this.C_TEXT2;
         text.x = 160;
         text.y = 16;
         text.centerOO();
         this.list.add(text);
         Text.size = 24;
         this.scoreText = new Text(String(Main.saveData.getScoreString()));
         this.scoreText.color = this.C_TEXT;
         this.scoreText.x = 162;
         this.scoreText.y = 30;
         this.scoreText.centerOO();
         this.scoreX = this.scoreText.x;
         this.scoreY = this.scoreText.y;
         this.list.add(this.scoreText);
         Text.size = 8;
         text = new Text("coins");
         text.color = this.C_TEXT2;
         text.x = 160;
         text.y = 50;
         text.centerOO();
         this.list.add(text);
         Text.size = 16;
         this.coinsText = new Text(String(Main.saveData.coins));
         this.coinsText.color = this.C_TEXT;
         this.coinsText.x = 162;
         this.coinsText.y = 60;
         this.coinsText.centerOO();
         this.coinsX = this.coinsText.x;
         this.coinsY = this.coinsText.y;
         this.list.add(this.coinsText);
         Text.size = 8;
         text = new Text("time");
         text.color = this.C_TEXT2;
         text.x = 160;
         text.y = 75;
         text.centerOO();
         this.list.add(text);
         Text.size = 16;
         this.timeText = new Text(Main.formatTime(Main.saveData.time));
         this.timeText.color = this.C_TEXT;
         this.timeText.x = 162;
         this.timeText.y = 85;
         this.timeText.centerOO();
         this.timeX = this.timeText.x;
         this.timeY = this.timeText.y;
         this.list.add(this.timeText);
         Text.size = oldSize;
      }
      
      override public function update() : void
      {
         this.sine = (this.sine + Math.PI / 64) % (Math.PI * 4);
         this.scoreText.x = this.scoreX + Math.sin(this.sine / 2) * 3;
         this.coinsText.x = this.coinsX + Math.sin(this.sine / 2) * 2;
         this.timeText.x = this.timeX + Math.sin(this.sine / 2) * 2;
         this.scoreText.y = this.scoreY + Math.sin(this.sine) * 3;
         this.coinsText.y = this.coinsY + Math.sin(this.sine) * 2;
         this.timeText.y = this.timeY + Math.sin(this.sine) * 2;
         this.scoreText.angle = Math.sin(this.sine / 2) * 8;
         this.coinsText.angle = Math.sin(this.sine) * 4;
         this.timeText.angle = Math.sin(this.sine) * 4;
      }
   }
}
