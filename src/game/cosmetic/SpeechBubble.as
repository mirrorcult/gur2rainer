package game.cosmetic
{
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Text;
   
   public class SpeechBubble extends Entity
   {
      
      private static const ImgBubble:Class = SpeechBubble_ImgBubble;
       
      
      private var time:Number = 2;
      
      private var speed:Number;
      
      private var image:Image;
      
      private var text:Text;
      
      public function SpeechBubble(x:int, y:int, string:String, speed:Number = -0.2)
      {
         var list:Graphiclist = null;
         super(x,y);
         this.speed = speed;
         layer = Main.DEPTH_SPEECH;
         list = new Graphiclist();
         graphic = list;
         this.image = new Image(ImgBubble);
         this.image.x = -32;
         this.image.y = -13;
         list.add(this.image);
         this.text = new Text(string);
         this.text.size = 8;
         this.text.smooth = false;
         this.text.color = 0;
         this.text.x = -this.text.width / 2 + 1;
         this.text.y = -this.text.height / 2;
         list.add(this.text);
      }
      
      override public function update() : void
      {
         y = y + this.speed;
         this.time = this.time - 0.02;
         this.image.alpha = this.time;
         this.text.alpha = this.time;
         if(this.time <= 0)
         {
            FP.world.remove(this);
         }
      }
   }
}
