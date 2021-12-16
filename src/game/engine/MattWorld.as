package game.engine
{
   import game.cosmetic.Transition;
   import net.flashpunk.FP;
   import net.flashpunk.World;
   
   public class MattWorld extends World
   {
       
      
      public var transition:Transition = null;
      
      public var changing:Boolean = false;
      
      public function MattWorld()
      {
         super();
      }
      
      override public function begin() : void
      {
         if(this.transition)
         {
            add(this.transition);
         }
         FP.camera.y = 0;
         FP.camera.x = 0;
      }
   }
}
