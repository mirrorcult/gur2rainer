package game
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   
   public class Rebound extends Block
   {
      
      private static const ImgRebound:Class = Rebound_ImgRebound;
       
      
      private const C_NORMAL:uint = 10066329;
      
      private var block:Image;
      
      private const C_SYMBOL:uint = 4473924;
      
      private var symbol:Image;
      
      private var list:Graphiclist;
      
      public function Rebound(player:Player, x:int, y:int, width:int, height:int)
      {
         super(player,x,y,width,height);
         visible = true;
         active = true;
         layer = Main.DEPTH_ACTORS;
         graphic = this.list = new Graphiclist();
         var bd:BitmapData = new BitmapData(width,height,true,4278190080);
         bd.fillRect(new Rectangle(1,1,bd.width - 2,bd.height - 2),4294967295);
         var q:int = Math.floor(bd.height / 4);
         bd.fillRect(new Rectangle(1,bd.height - 1 - q,bd.width - 2,q),4292730333);
         this.list.add(this.block = new Image(bd));
         this.block.originX = this.block.width / 2;
         this.block.originY = this.block.height / 2;
         this.block.color = this.C_NORMAL;
         this.symbol = new Image(ImgRebound);
         this.symbol.x = width / 2 - 3;
         this.symbol.y = height / 2 - 6;
         this.symbol.originX = 3;
         this.symbol.originY = 4;
         this.list.add(this.symbol);
         this.symbol.color = this.C_SYMBOL;
      }
      
      public function hit() : void
      {
         this.symbol.scale = 1.2;
         this.block.scale = 1.2;
      }
      
      override public function update() : void
      {
         if(this.block.scale > 1)
         {
            this.block.scale = this.symbol.scale = Math.max(1,this.block.scale - 0.02);
         }
      }
   }
}
