package game.cosmetic
{
   import game.engine.Level;
   import net.flashpunk.Entity;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Text;
   
   public class DrawTime extends Entity
   {
       
      
      private const Y:int = 6;
      
      private var level:Level;
      
      private var text:Text;
      
      private var bTextA:Text;
      
      private var bTextB:Text;
      
      private var bTextC:Text;
      
      private var bTextD:Text;
      
      private const X:int = 2;
      
      private var list:Graphiclist;
      
      public function DrawTime(level:Level)
      {
         super();
         layer = Main.DEPTH_HUD;
         this.level = level;
         graphic = this.list = new Graphiclist();
         var str:String = "9999999999999999999";
         Text.size = 8;
         this.bTextA = new Text(str);
         this.bTextA.scrollX = this.bTextA.scrollY = 0;
         this.bTextA.x = this.X + 1;
         this.bTextA.y = this.Y - 5;
         this.bTextA.color = 0;
         this.list.add(this.bTextA);
         this.bTextB = new Text(str);
         this.bTextB.scrollX = this.bTextB.scrollY = 0;
         this.bTextB.x = this.X + 3;
         this.bTextB.y = this.Y - 5;
         this.bTextB.color = 0;
         this.list.add(this.bTextB);
         this.bTextC = new Text(str);
         this.bTextC.scrollX = this.bTextC.scrollY = 0;
         this.bTextC.x = this.X + 2;
         this.bTextC.y = this.Y - 4;
         this.bTextC.color = 0;
         this.list.add(this.bTextC);
         this.bTextD = new Text(str);
         this.bTextD.scrollX = this.bTextD.scrollY = 0;
         this.bTextD.x = this.X + 2;
         this.bTextD.y = this.Y - 6;
         this.bTextD.color = 0;
         this.list.add(this.bTextD);
         this.text = new Text(str);
         this.text.scrollX = this.text.scrollY = 0;
         this.text.x = this.X + 2;
         this.text.y = this.Y - 5;
         this.text.color = 16777215;
         this.list.add(this.text);
         this.updateTotal();
      }
      
      public function updateTotal() : void
      {
         this.text.text = this.bTextA.text = this.bTextB.text = this.bTextC.text = this.bTextD.text = Main.formatTime(Main.saveData.time + this.level.time);
      }
   }
}
