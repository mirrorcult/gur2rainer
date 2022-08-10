package game.cosmetic
{
   import game.engine.Level;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class Win extends Entity
   {
       
      
      private var timer:Alarm;
      
      public function Win()
      {
         Main.GameState = Main.STATE_LEVEL_TRANSITION;
         this.timer = new Alarm(20,this.done,Tween.ONESHOT);
         super();
         addTween(this.timer,true);
      }
      
      private function done() : void
      {
         if((FP.world as Level).practice)
         {
            FP.world.add(new LevelComplete());
         }
         else
         {
            FP.world.add(new Transition(Main.getLevel()));
         }
      }
   }
}
