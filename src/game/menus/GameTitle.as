package game.menus
{
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Text;
   
   public class GameTitle extends Entity
   {
       
      
      private var sine:Number;
      
      private var two:Text;
      
      private var text:Text;
      
      private var list:Graphiclist;
      
      public function GameTitle()
      {
         super(160,36);
         graphic = this.list = new Graphiclist();
         Text.size = 36;
         this.two = new Text("1.0");
         this.two.color = 16777215;
         this.two.centerOO();
         this.two.y = this.two.y + 28;
         this.list.add(this.two);
         Text.size = 24;
         this.text = new Text("Gur2Rainer");
         this.text.color = 16777215;
         this.text.centerOO();
         this.list.add(this.text);
         this.sine = Math.random() * Math.PI * 2;
      }
      
      override public function update() : void
      {
         this.sine = (this.sine + Math.PI / 64) % (Math.PI * 2);
         this.text.angle = Math.sin(this.sine) * 6;
         this.two.angle = Math.sin(this.sine * 2) * 8;
         this.two.scale = 1 + Math.sin(this.sine) * 0.1;
         this.two.color = FP.getColorRGB(155 + Math.sin(this.sine) * 100,155 + Math.sin(this.sine + Math.PI * 2 / 3) * 100,155 + Math.sin(this.sine + Math.PI * 4 / 3) * 100);
      }
   }
}
