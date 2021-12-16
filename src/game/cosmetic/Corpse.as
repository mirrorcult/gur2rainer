package game.cosmetic
{
   import game.engine.Level;
   import game.particles.ParticleType;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class Corpse extends Entity
   {
       
      
      private var timer:Alarm;
      
      public function Corpse(x:int, y:int, color:uint)
      {
         var partType:ParticleType = null;
         this.timer = new Alarm(30,this.done,Tween.ONESHOT);
         super(x,y);
         addTween(this.timer,true);
         partType = Main.particles.getType("playerDeadBig");
         partType.color_start = color;
         partType.color_end = color;
         for(var i:int = 0; i < 360; i = i + 45)
         {
            partType.direction = i;
            Main.particles.addParticles("playerDeadBig",x,y);
         }
         partType = Main.particles.getType("playerDeadSmall");
         partType.color_start = color;
         partType.color_end = color;
         Main.particles.addParticlesArea("playerDeadSmall",x - 4,y - 4,8,8,12);
      }
      
      private function done() : void
      {
         FP.world.add(new Transition((FP.world as Level).restart));
      }
   }
}
