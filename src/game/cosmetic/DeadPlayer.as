package game.cosmetic
{
   import flash.display.BitmapData;
   import game.Jetpack;
   import game.Player;
   import net.flashpunk.Entity;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Text;
   
   public class DeadPlayer extends Entity
   {
       
      
      private const C_BG:uint = 4.27819008E9;
      
      private var bg:Image;
      
      private var text:Text;
      
      private const C_STAR:uint = 16777215;
      
      private var rotSpeed:Number;
      
      private var star:Image;
      
      private var list:Graphiclist;
      
      public function DeadPlayer(player:Player)
      {
         var oldSize:int = 0;
         super();
         layer = Main.DEPTH_BGEFFECT;
         graphic = this.list = new Graphiclist();
         var bd:BitmapData = new BitmapData(320,240,true,this.C_BG);
         this.bg = new Image(bd);
         this.bg.scrollX = this.bg.scrollY = 0;
         this.bg.alpha = 0.5;
         this.list.add(this.bg);
         this.star = new Image(Jetpack.ImgBG);
         this.star.originX = this.star.originY = 12;
         this.star.scale = 5;
         this.star.color = this.C_STAR;
         this.star.x = player.x - 12;
         this.star.y = player.y - 12;
         this.star.alpha = 1;
         this.list.add(this.star);
         oldSize = Text.size;
         Text.size = 48;
         this.text = new Text("YOU DIED.");
         this.text.scrollX = this.text.scrollY = 0;
         this.text.x = 160 - this.text.width / 2;
         this.text.y = 80 - this.text.height / 2;
         this.text.originX = this.text.width / 2;
         this.text.originY = this.text.height / 2;
         this.text.angle = 10 + Math.random() * 25;
         this.text.color = 0;
         this.text.alpha = 0.5;
         this.list.add(this.text);
         Text.size = oldSize;
         this.rotSpeed = 4;
      }
      
      override public function update() : void
      {
         this.bg.alpha = this.bg.alpha + 0.005;
         this.star.angle = this.star.angle - this.rotSpeed;
         this.text.angle = this.text.angle - 0.1;
         this.text.y = this.text.y + 0.2;
         this.text.x = this.text.x + 0.1;
         this.star.scale = Math.max(this.star.scale - 0.25,2);
         this.rotSpeed = Math.max(1,this.rotSpeed - (this.rotSpeed - 1) / 32);
      }
   }
}
