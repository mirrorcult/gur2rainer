package game
{
   import net.flashpunk.Entity;
   import net.flashpunk.graphics.Spritemap;
   
   public class Coin extends Entity
   {
      
      public static const ImgCoin:Class = Coin_ImgCoin;
       
      
      private const ADD:Number = 0.19634954084936207;
      
      private var startX:Number;
      
      private var startY:Number;
      
      private const DIVIDE:Number = 12.566370614359172;
      
      private var sine:Number = 0;
      
      public function Coin(x:int, y:int)
      {
         super(x,y);
         this.startX = x;
         this.startY = y;
         width = 20;
         height = 20;
         originX = 10;
         originY = 10;
         type = "item";
         layer = Main.DEPTH_ITEMS;
         graphic = new Spritemap(ImgCoin,6,8);
         (graphic as Spritemap).add("spin",[0,1,2,3,4],0.2);
         (graphic as Spritemap).play("spin");
         graphic.x = -3;
         graphic.y = -4;
      }
      
      override public function update() : void
      {
         this.sine = (this.sine + this.ADD) % this.DIVIDE;
         x = this.startX + Math.sin(this.sine / 2) * 2;
         y = this.startY + Math.sin(this.sine) * 2;
      }
   }
}
