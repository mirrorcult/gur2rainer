package game.menus
{
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Text;
   import net.flashpunk.utils.Input;
   
   public class TASWatermark extends Entity
   {
      private var text:Text;
      
      public function TASWatermark()
      {
         super(0,0);
         Text.size = 8;
         graphic = this.text = new Text("> TAS <");
         this.text.x = 160 - this.text.width / 2;
         this.text.y = 235 - this.text.height / 2;
         this.text.scrollX = this.text.scrollY = 0;
         this.text.color = 16777215;
         layer = Main.DEPTH_LINK;
      }
   }
}