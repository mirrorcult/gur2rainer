package game.cosmetic
{
   import flash.geom.Rectangle;
   import game.EndKey;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Image;
   
   public class BGKey extends Entity
   {
       
      
      private var img:Image;
      
      private const SPEED:Number = 2.8;
      
      private var sine:Number = 0;
      
      public function BGKey(x:int, y:int)
      {
         super(x,y);
         layer = Main.DEPTH_BG - 1;
         this.img = new Image(EndKey.ImgKey,new Rectangle(0,0,12,16));
         this.img.originX = 6;
         this.img.originY = 3;
         this.img.x = -6;
         this.img.y = -3;
         this.img.angle = 90;
         this.img.scale = 0.8;
         graphic = this.img;
      }
      
      override public function update() : void
      {
         this.sine = (this.sine + Math.PI / 32) % (Math.PI * 2);
         this.img.angle = 90 + Math.sin(this.sine) * 25;
         FP.angleXY(FP.point,this.img.angle - 90,this.SPEED);
         x = x + FP.point.x;
         y = y + FP.point.y;
         if(x > 330)
         {
            FP.world.remove(this);
         }
      }
   }
}
