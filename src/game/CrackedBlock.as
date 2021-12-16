package game
{
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Image;
   
   public class CrackedBlock extends Block
   {
      
      private static const ImgCracked:Class = CrackedBlock_ImgCracked;
       
      
      public function CrackedBlock(player:Player, x:int, y:int)
      {
         super(player,x,y,32,32);
         visible = true;
         layer = Main.DEPTH_ACTORS;
         graphic = new Image(ImgCracked);
      }
      
      public function blowUp() : void
      {
         FP.world.remove(this);
         Main.particles.addParticlesArea("crackedBlowUp",x + 4,y + 4,24,24,10);
         Main.screenShake(1);
      }
   }
}
