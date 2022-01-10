package game
{
   import net.flashpunk.graphics.Spritemap;
   
   public class Door extends Block
   {
      
      private static const ImgDoor:Class = Door_ImgDoor;
       
      
      private var sprite:Spritemap;
      
      public var startY:int;
      
      private const DISTANCE:Number = -48;
      
      public function Door(player:Player, x:int, y:int)
      {
         super(player,x,y,16,48);
         visible = true;
         this.startY = y;
         graphic = this.sprite = new Spritemap(ImgDoor,16,50);
         this.sprite.y = -2;
         this.sprite.add("closed",[0]);
         this.sprite.add("open",[1]);
         this.sprite.play("closed");
      }
      
      override public function update() : void
      {
         if(y > this.startY + this.DISTANCE)
         {
            moveV(-0.5);
         }
         else
         {
            active = false;
         }
      }
      
      public function open() : void
      {
         active = true;
         this.sprite.play("open");
      }
      
      public function setState(percent:Number, closing:Boolean) : void
      {
         moveV(this.startY + percent * this.DISTANCE - y);
         if(closing)
         {
            this.sprite.play("closed");
         }
         else
         {
            this.sprite.play("open");
         }
         if(percent == 0)
         {
            shake = 10;
         }
      }
   }
}
