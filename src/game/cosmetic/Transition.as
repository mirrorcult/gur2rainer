package game.cosmetic
{
   import game.engine.MattWorld;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   
   public class Transition extends Entity
   {
       
      
      private var up:Boolean = true;
      
      private var goto1;
      
      private var wait:Boolean;
      
      private var image:Fuzz;
      
      public function Transition(goto1:*, wait:Boolean = false)
      {
         super();
         this.goto1 = goto1;
         this.wait = wait;
         graphic = this.image = new Fuzz();
         this.image.alpha = 0;
         layer = Main.DEPTH_FUZZ;
         if((FP.world as MattWorld).changing)
         {
            active = false;
            FP.world.remove(this);
         }
         else
         {
            (FP.world as MattWorld).changing = true;
         }
      }
      
      override public function render() : void
      {
         if(this.up)
         {
            this.image.alpha = this.image.alpha + 0.1;
            if(this.image.alpha >= 1 && !this.wait)
            {
               this.up = false;
               if(this.goto1 is MattWorld)
               {
                  this.goto1.transition = this;
                  FP.world.removeAll();
                  FP.world = this.goto1;
               }
               else if(this.goto1 is Function)
               {
                  this.goto1(this);
               }
            }
         }
         else
         {
            this.image.alpha = this.image.alpha - 0.05;
            if(this.image.alpha <= 0)
            {
               FP.world.remove(this);
            }
         }
         super.render();
      }
      
      public function allow() : void
      {
         this.wait = false;
      }
   }
}
