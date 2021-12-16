package game.cosmetic
{
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Text;
   
   public class Pauser extends Entity
   {
       
      
      public function Pauser()
      {
         super();
      }
      
      override public function added() : void
      {
         FP.world.active = false;
         Main.pause = this;
      }
      
      protected function finish() : void
      {
         FP.world.active = true;
         Main.pause = null;
         active = false;
         FP.world.remove(this);
      }
      
      protected function centerTextOrigin(text:Text) : void
      {
         text.originX = text.width / 2;
         text.originY = text.height / 2;
      }
   }
}
