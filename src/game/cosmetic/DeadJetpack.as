package game.cosmetic
{
   import game.Jetpack;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Spritemap;
   
   public class DeadJetpack extends Entity
   {
       
      
      private var vSpeed:Number = 0;
      
      private var sprite:Spritemap;
      
      private const MAX_FALL:Number = 4;
      
      private const GRAVITY:Number = 0.12;
      
      private var hSpeed:Number = 0;
      
      public function DeadJetpack(x:int, y:int, flip:Boolean)
      {
         super(x,y);
         layer = Main.DEPTH_ENVIRON;
         this.hSpeed = -0.6 - Math.random();
         this.vSpeed = -3 - Math.random();
         this.sprite = new Spritemap(Jetpack.ImgJetpack,9,10);
         this.sprite.originX = 4;
         this.sprite.originY = 5;
         this.sprite.add("left",[7]);
         this.sprite.add("right",[11]);
         if(flip)
         {
            this.hSpeed = this.hSpeed * -1;
            this.sprite.play("left");
         }
         else
         {
            this.sprite.play("right");
         }
         graphic = this.sprite;
      }
      
      override public function update() : void
      {
         Main.particles.addParticlesArea("jetpackDead",x,y + 1,8,8);
         this.sprite.angle = this.sprite.angle + 1;
         this.vSpeed = Math.min(this.vSpeed + this.GRAVITY,this.MAX_FALL);
         x = x + this.hSpeed;
         y = y + this.vSpeed;
         if(y > FP.camera.y + 250)
         {
            FP.world.remove(this);
         }
      }
   }
}
