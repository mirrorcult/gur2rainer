package game
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   
   public class Conveyor extends Block
   {
      
      private static const ImgConveyor:Class = Conveyor_ImgConveyor;
       
      
      private var sprite:Spritemap;
      
      private var list:Graphiclist;
      
      public var vSpeed:Number = 0;
      
      private var image:Image;
      
      public var hSpeed:Number = 0;
      
      public function Conveyor(player:Player, x:int, y:int, width:int, height:int, direction:int, speed:Number)
      {
         super(player,x,y,width,height);
         active = true;
         visible = true;
         FP.angleXY(FP.point,direction,speed);
         this.hSpeed = FP.point.x;
         this.vSpeed = FP.point.y;
         this.sprite = new Spritemap(ImgConveyor,8,8);
         this.sprite.add("go",[0,1,2,3,4,5,6,7],speed / 2);
         this.sprite.play("go");
         this.sprite.originY = 4;
         this.sprite.originX = 4;
         this.sprite.angle = direction;
         var bd:BitmapData = new BitmapData(width,height,true,4278190080);
         bd.fillRect(new Rectangle(1,1,width - 2,height - 2),0);
         bd.fillRect(new Rectangle(1,height * 3 / 4,width - 2,height / 4 - 1),855638016);
         this.image = new Image(bd);
      }
      
      override public function update() : void
      {
         if(grapple)
         {
            if(this.vSpeed >= 0 || grapple.collideTypes(Grapple.GRAB,Math.round(grapple.x),Math.round(grapple.y + this.vSpeed)) != null)
            {
               grapple.move(this.hSpeed,this.vSpeed);
            }
         }
         else if(this.hSpeed != 0 && collideWith(player,x,y - 1))
         {
            player.moveH(this.hSpeed);
         }
         this.sprite.update();
      }
      
      override public function render() : void
      {
         var j:int = 0;
         for(var i:int = x; i < x + width; i = i + 8)
         {
            for(j = y; j < y + height; j = j + 8)
            {
               FP.point.x = i;
               FP.point.y = j;
               this.sprite.render(FP.point,FP.camera);
            }
         }
         FP.point.x = x;
         FP.point.y = y;
         this.image.render(FP.point,FP.camera);
      }
   }
}
