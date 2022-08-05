package game.particles
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   import game.Options;
   import net.flashpunk.Entity;
   import net.flashpunk.graphics.Graphiclist;
   
   public class ParticleSystem extends Entity
   {
       
      
      private var frameWidth:int;
      
      private var types:Dictionary;
      
      private var particles:Vector.<Particle>;
      
      private var frameHeight:int;
      
      private var bitmapData:BitmapData;
      
      private var list:Graphiclist;
      
      public function ParticleSystem(source:Class, frameWidth:int, frameHeight:int)
      {
         var t:ParticleType = null;
         super();
         this.types = new Dictionary();
         this.particles = new Vector.<Particle>();
         this.list = new Graphiclist();
         graphic = this.list;
         var bitmap:Bitmap = new source();
         this.bitmapData = bitmap.bitmapData;
         this.frameWidth = frameWidth;
         this.frameHeight = frameHeight;
         layer = Main.DEPTH_PARTICLES;
         t = this.addType("coin");
         t.life = 8;
         t.life_add = 6;
         t.direction_add = 360;
         t.speed = 0.5;
         t.speed_add = 0.3;
         t.color_start = 16776960;
         t.color_end = 16776960;
         t = this.addType("playerShake");
         t.frame = 1;
         t.life = 8;
         t.life_add = 6;
         t.direction_add = 360;
         t.speed = 0.5;
         t.speed_add = 0.3;
         t.color_start = 16711935;
         t.color_end = 16711935;
         t = this.addType("playerShakeInvert");
         t.frame = 1;
         t.life = 8;
         t.life_add = 6;
         t.direction_add = 360;
         t.speed = 0.5;
         t.speed_add = 0.3;
         t.color_start = 65535;
         t.color_end = 65535;
         t = this.addType("giantLeverSparks");
         t.life = 10;
         t.life_add = 6;
         t.direction_add = 40;
         t.speed = 1.8;
         t.speed_add = 0.8;
         t.color_start = 63231;
         t.color_end = 63231;
         t = this.addType("shootMissile");
         t.life = 35;
         t.life_add = 15;
         t.direction_add = 10;
         t.speed = 1.2;
         t.speed_add = 1;
         t.color_start = 16776960;
         t.color_end = 16711680;
         t = this.addType("missileTravel");
         t.life = 12;
         t.life_add = 6;
         t.direction_add = 4;
         t.speed = 0.6;
         t.speed_add = 0.6;
         t.color_start = 16776960;
         t.color_end = 16711680;
         t = this.addType("missileExplode");
         t.life = 20;
         t.life_add = 10;
         t.direction_add = 360;
         t.speed = 1;
         t.speed_add = 1;
         t.color_start = 16776960;
         t.color_end = 16711680;
         t = this.addType("crackedBlowUp");
         t.life = 10;
         t.life_add = 6;
         t.direction_add = 360;
         t.speed = 0.8;
         t.speed_add = 0.8;
         t.color_start = 12890739;
         t.color_end = 12890739;
         t = this.addType("fallingPlatOffBottom");
         t.life = 20;
         t.life_add = 6;
         t.direction = 85;
         t.direction_add = 10;
         t.speed = 0.8;
         t.speed_add = 0.4;
         t.color_start = 16757836;
         t.color_end = 16757836;
         t = this.addType("coinBlock");
         t.life = 10;
         t.life_add = 4;
         t.speed = 0.9;
         t.speed_add = 0.4;
         t.color_start = 16776960;
         t.color_end = 16776960;
         t = this.addType("laser");
         t.life = 10;
         t.life_add = 4;
         t.speed = 0.4;
         t.speed_add = 0.2;
         t.direction_add = 360;
         t.color_start = 16751615;
         t.color_end = 16751615;
         t = this.addType("electricity");
         t.life = 10;
         t.life_add = 4;
         t.speed = 0.9;
         t.speed_add = 0.4;
         t.color_start = 16776960;
         t.color_end = 16776960;
         t = this.addType("jetpackFire");
         t.frame = 1;
         t.life = 10;
         t.life_add = 3;
         t.direction = 265;
         t.direction_add = 10;
         t.speed = 1.6;
         t.speed_add = 0.8;
         t.color_start = 16776960;
         t.color_end = 16711680;
         t = this.addType("jetpackDead");
         t.frame = 1;
         t.life = 8;
         t.life_add = 6;
         t.direction_add = 360;
         t.speed = 0.2;
         t.speed_add = 0.2;
         t.color_start = 16776960;
         t.color_end = 16711680;
         t = this.addType("bossFireWeak");
         t.frame = 1;
         t.life = 10;
         t.life_add = 3;
         t.direction_add = 10;
         t.speed = 1.8;
         t.speed_add = 0.4;
         t.color_start = 16776960;
         t.color_end = 16711680;
         t = this.addType("bossFireStrong");
         t.life = 10;
         t.life_add = 3;
         t.direction = 220;
         t.direction_add = 10;
         t.speed = 2.2;
         t.speed_add = 0.8;
         t.color_start = 16776960;
         t.color_end = 16711680;
         t = this.addType("playerDeadBig");
         t.life = 30;
         t.speed = 1.5;
         t.direction_add = 0;
         t.color_start = 65280;
         t.color_end = 65280;
         t = this.addType("playerDeadSmall");
         t.frame = 1;
         t.life = 16;
         t.life_add = 6;
         t.speed = 1;
         t.speed_add = 1;
         t.color_start = 65280;
         t.color_end = 65280;
      }
      
      public function removeParticle(part:Particle) : void
      {
         this.list.remove(part);
         this.particles.push(part);
      }
      
      public function removeType(name:String) : void
      {
         if(this.types[name] == null)
         {
            throw new Error("Trying to remove particle type \"" + name + "\" which is not defined.");
         }
         this.types[name] = null;
      }
      
      public function clearParticles() : void
      {
         var p:Particle = null;
         for each(p in this.list.children)
         {
            this.particles.push(p);
         }
         this.list.removeAll();
      }
      
      override public function update() : void
      {
         var p:Particle = null;
         for each(p in this.list.children)
         {
            p.tick();
         }
      }
      
      public function addParticles(name:String, x:Number, y:Number, amount:int = 1) : void
      {
         var part:Particle = null;
         if(!Options.particles)
         {
            return;
         }
         var type:ParticleType = this.types[name];
         for(var i:int = 0; i < amount; i++)
         {
            if(this.particles.length > 0)
            {
               part = this.particles.pop();
            }
            else
            {
               part = new Particle(this.bitmapData,this.frameWidth,this.frameHeight);
            }
            part.initParticle(type,x,y);
            this.list.add(part);
         }
      }
      
      public function getType(name:String) : ParticleType
      {
         return this.types[name];
      }
      
      public function addParticlesArea(name:String, x:Number, y:Number, xAdd:Number, yAdd:Number, amount:int = 1) : void
      {
         var part:Particle = null;
         if(!Options.particles)
         {
            return;
         }
         var type:ParticleType = this.types[name];
         for(var i:int = 0; i < amount; i++)
         {
            if(this.particles.length > 0)
            {
               part = this.particles.pop();
            }
            else
            {
               part = new Particle(this.bitmapData,this.frameWidth,this.frameHeight);
            }
            part.initParticle(type,x + xAdd * Math.random(),y + yAdd * Math.random());
            this.list.add(part);
         }
      }
      
      public function addType(name:String) : ParticleType
      {
         if(this.types[name] != null)
         {
            throw new Error("Two particles of type \"" + name + "\" defined. Particle type names must be unique!");
         }
         return this.types[name] = new ParticleType(this);
      }
   }
}
