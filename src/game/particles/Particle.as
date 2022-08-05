package game.particles
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Spritemap;
   
   public class Particle extends Spritemap
   {
       
      
      private var speed:Point;
      
      private var type:ParticleType;
      
      private var life:uint;
      
      private var startLife:uint;
      
      public function Particle(source:BitmapData, frameWidth:int, frameHeight:int)
      {
         super(source,frameWidth,frameHeight);
         originX = frameWidth / 2;
         originY = frameHeight / 2;
      }
      
      public function initParticle(type:ParticleType, x:Number, y:Number) : void
      {
         this.type = type;
         this.x = x;
         this.y = y;
         this.startLife = this.life = type.life + Math.round(type.life_add * Math.random());
         this.speed = FP.angleXY(new Point(),type.direction + type.direction_add * Math.random(),type.speed + type.speed_add * Math.random());
         alpha = 1;
         color = type.color_start;
         frame = type.frame;
      }
      
      public function tick() : void
      {
         this.life--;
         if(this.life <= 0)
         {
            this.type.system.removeParticle(this);
            return;
         }
         alpha = this.life / (this.startLife / 2);
         color = FP.colorLerp(this.type.color_end,this.type.color_start,this.life / this.startLife);
         x = x + this.speed.x;
         y = y + this.speed.y;
      }
   }
}
