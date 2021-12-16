package game
{
   import flash.geom.Point;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   
   public class FlipBlock extends Block
   {
      
      private static const ImgFlip:Class = FlipBlock_ImgFlip;
      
      private static const ImgSpiral:Class = FlipBlock_ImgSpiral;
       
      
      private var spiral:Image;
      
      private var sprite:Spritemap;
      
      public function FlipBlock(player:Player, x:int, y:int)
      {
         var list:Graphiclist = null;
         super(player,x,y,16,16);
         active = true;
         visible = true;
         grapplePoint = new Point(8,8);
         graphic = list = new Graphiclist();
         this.spiral = new Image(ImgSpiral);
         this.spiral.centerOrigin();
         this.spiral.x = -4;
         this.spiral.y = -4;
         this.spiral.alpha = 0;
         this.spiral.color = 65535;
         this.spiral.scale = 1.5;
         list.add(this.spiral);
         this.sprite = new Spritemap(ImgFlip,16,16);
         this.sprite.centerOrigin();
         this.sprite.add("normal",[0]);
         this.sprite.add("flip",[1]);
         this.sprite.play("normal");
         list.add(this.sprite);
      }
      
      override public function onGrapple() : void
      {
         this.sprite.play("flip");
         this.sprite.scale = 1.4;
         shake = 10;
         player.flip = true;
      }
      
      override public function onRelease() : void
      {
         this.sprite.play("normal");
         this.sprite.scale = 1.4;
         shake = 10;
         player.flip = false;
      }
      
      override public function update() : void
      {
         if(this.sprite.scale > 1)
         {
            this.sprite.scale = Math.max(1,this.sprite.scale - 0.02);
         }
         if(grapple)
         {
            this.spiral.alpha = Math.min(this.spiral.alpha + 0.02,0.25);
         }
         else
         {
            this.spiral.alpha = Math.max(this.spiral.alpha - 0.02,0);
         }
         if(this.spiral.alpha > 0)
         {
            this.spiral.angle = this.spiral.angle + 6;
         }
      }
   }
}
