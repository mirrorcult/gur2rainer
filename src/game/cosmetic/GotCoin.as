package game.cosmetic
{
   import game.Coin;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Spritemap;
   
   public class GotCoin extends Entity
   {
       
      
      private var vSpeed:Number;
      
      private var timer:uint = 22;
      
      private const GRAVITY:Number = 0.1;
      
      private var hSpeed:Number;
      
      public function GotCoin(x:int, y:int)
      {
         var s:Spritemap = null;
         super(x,y);
         s = new Spritemap(Coin.ImgCoin,6,8);
         graphic = s;
         s.x = -3;
         s.y = -4;
         (graphic as Spritemap).add("spin",[0,1,2,3,4],0.2);
         (graphic as Spritemap).play("spin");
         layer = Main.DEPTH_ITEMS;
         this.hSpeed = -1 + Math.random() * 2;
         this.vSpeed = -2 - Math.random();
      }
      
      override public function update() : void
      {
         x = x + this.hSpeed;
         y = y + this.vSpeed;
         this.vSpeed = this.vSpeed + this.GRAVITY;
         this.timer--;
         if(this.timer == 0)
         {
            FP.world.remove(this);
            Main.particles.addParticlesArea("coin",x - 2,y - 2,4,4,3);
         }
      }
   }
}
