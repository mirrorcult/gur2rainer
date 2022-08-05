package game.particles
{
   public class ParticleType
   {
       
      
      public var direction_add:Number;
      
      public var color_start:uint;
      
      public var speed:Number;
      
      public var speed_add:Number;
      
      public var system:ParticleSystem;
      
      public var frame:uint;
      
      public var color_end:uint;
      
      public var life:uint;
      
      public var life_add:uint;
      
      public var direction:Number;
      
      public function ParticleType(system:ParticleSystem)
      {
         super();
         this.system = system;
         this.life = 5;
         this.life_add = 5;
         this.speed = 0;
         this.speed_add = 0;
         this.direction = 0;
         this.direction_add = 360;
         this.color_start = 16711680;
         this.color_end = 16711680;
         this.frame = 0;
      }
   }
}
