package game.menus
{
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Text;
   import net.flashpunk.utils.Input;
   
   public class ASLink extends Entity
   {
       
      
      private const WIDTH:int = 90;
      
      private const LEFT:int = 115.0;
      
      private const BOTTOM:int = 239.0;
      
      private var text:Text;
      
      private var mouseIn:Boolean = false;
      
      private const TOP:int = 231.0;
      
      private const RIGHT:int = 205.0;
      
      private const HEIGHT:int = 8;
      
      public function ASLink()
      {
         super(0,0);
         Text.size = 8;
         graphic = this.text = new Text("[AdultSwim.com]");
         this.text.x = 160 - this.text.width / 2;
         this.text.y = 235 - this.text.height / 2;
         this.text.scrollX = this.text.scrollY = 0;
         this.text.color = 16777215;
         layer = Main.DEPTH_LINK;
      }
      
      private function mouseInside() : Boolean
      {
         return FP.screen.mouseX >= this.LEFT && FP.screen.mouseX <= this.RIGHT && FP.screen.mouseY >= this.TOP && FP.screen.mouseY <= this.BOTTOM;
      }
      
      override public function update() : void
      {
         if(this.mouseIn)
         {
            if(!this.mouseInside())
            {
               this.mouseIn = false;
               this.text.scale = 1;
               this.text.x = 160 - this.text.width / 2;
               this.text.y = 235 - this.text.height / 2;
            }
            else if(Input.mousePressed)
            {
               Main.link("gameplay");
            }
         }
         else if(this.mouseInside())
         {
            this.mouseIn = true;
            this.text.scale = 1.3;
            this.text.x = 160 - this.text.width / 2 * this.text.scale;
            this.text.y = 235 - this.text.height / 2 * this.text.scale;
         }
      }
   }
}
