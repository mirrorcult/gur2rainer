package game
{
   import game.engine.Assets;
   import game.engine.Level;
   import game.particles.ParticleType;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Spritemap;
   
   public class Launcher extends Entity
   {
      
      private static const ImgLauncher:Class = Launcher_ImgLauncher;
       
      
      private var player:Player;
      
      private var sprite:Spritemap;
      
      private var timer:uint;
      
      private var shoot:Boolean = true;
      
      public function Launcher(player:Player, x:int, y:int, direction:int)
      {
         super(x,y);
         this.player = player;
         graphic = this.sprite = new Spritemap(ImgLauncher,32,32);
         this.sprite.x = -16;
         this.sprite.y = -16;
         this.sprite.originX = 16;
         this.sprite.originY = 16;
         this.sprite.angle = direction;
         layer = Main.DEPTH_ENVIRON;
         this.startTimer();
      }
      
      public function startTimer() : void
      {
         this.timer = 40;
      }
      
      override public function update() : void
      {
         if(this.sprite.scale > 1)
         {
            this.sprite.scale = Math.max(1,this.sprite.scale - 0.05);
         }
         if(!this.shoot)
         {
            return;
         }
         if(this.timer > 0)
         {
            this.timer--;
            if(this.timer == 0)
            {
               this.startLaunch();
            }
         }
      }
      
      public function deactivate() : void
      {
         this.shoot = false;
      }
      
      private function startLaunch() : void
      {
         if(x < FP.camera.x - 16 || y < FP.camera.y - 16 || x >= FP.camera.x + 336 || y >= FP.camera.y + 256)
         {
            this.timer = 40;
            return;
         }
         FP.angleXY(FP.point,this.sprite.angle,24);
         if(FP.world.collidePoint("solid",x + FP.point.x,y + FP.point.y))
         {
            this.timer = 40;
            return;
         }
         Assets.SndMissileShoot.play();
         this.sprite.scale = 1.5;
         Main.screenShake(0);
         (FP.world as Level).add(new Missile(this.player,this,x,y,this.sprite.angle));
         var type:ParticleType = Main.particles.getType("shootMissile");
         type.direction = this.sprite.angle - 5;
         Main.particles.addParticlesArea("shootMissile",x - 10,y - 10,20,20,14);
      }
   }
}
