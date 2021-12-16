package game.cosmetic
{
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   
   public class MenuBG extends Entity
   {
      
      public static const ImgBG:Class = MenuBG_ImgBG;
       
      
      private var blen:Number = 0;
      
      private var img:Image;
      
      private var list:Graphiclist;
      
      public function MenuBG()
      {
         super();
         layer = Main.DEPTH_BG;
         graphic = this.list = new Graphiclist();
         this.img = new Image(ImgBG);
         this.img.scrollX = this.img.scrollY = 0;
         this.img.alpha = 0.5;
         this.list.add(this.img);
      }
      
      override public function update() : void
      {
         this.blen = (this.blen + Math.PI / 32) % (Math.PI * 4);
         var sine:Number = Math.sin(this.blen);
         var sine2:Number = Math.sin(this.blen + Math.PI * 2 / 3);
         var sine3:Number = Math.sin(this.blen + Math.PI * 4 / 3);
         this.img.color = FP.getColorRGB(155 + sine * 100,155 + sine2 * 100,155 + sine3 * 100);
      }
   }
}
