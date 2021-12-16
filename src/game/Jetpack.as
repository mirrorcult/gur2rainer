package game
{
   import net.flashpunk.Entity;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   
   public class Jetpack extends Entity
   {
      
      public static const ImgBG:Class = Jetpack_ImgBG;
      
      public static const ImgJetpack:Class = Jetpack_ImgJetpack;
       
      
      private var sine:Number = 0;
      
      private var startX:int;
      
      private var startY:int;
      
      private var glow:Image;
      
      public function Jetpack(x:int, y:int)
      {
         var list:Graphiclist = null;
         super(x,y);
         this.startX = x;
         this.startY = y;
         width = 20;
         height = 20;
         originX = 10;
         originY = 10;
         type = "item";
         layer = Main.DEPTH_ITEMS;
         list = new Graphiclist();
         graphic = list;
         this.glow = new Image(ImgBG);
         this.glow.originX = this.glow.originY = 12;
         this.glow.x = this.glow.y = -12;
         this.glow.alpha = 0.5;
         this.glow.color = 16711680;
         list.add(this.glow);
         var sprite:Spritemap = new Spritemap(ImgJetpack,9,10);
         sprite.x = -4;
         sprite.y = -5;
         sprite.add("go",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17],0.2);
         sprite.play("go");
         list.add(sprite);
      }
      
      override public function update() : void
      {
         this.glow.angle = this.glow.angle - 0.5;
         this.sine = (this.sine + Math.PI / 64) % (Math.PI * 4);
         x = this.startX + Math.sin(this.sine / 2) * 4;
         y = this.startY + Math.sin(this.sine) * 4;
      }
   }
}
