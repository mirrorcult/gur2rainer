package game
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.cosmetic.Face;
   import game.engine.Assets;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   
   public class MovingPlat extends Block
   {
       
      
      private const SHAKE_TIME:uint = 20;
      
      private var started:Boolean;
      
      private const C_MOVE:uint = 9886463;
      
      private var stopped:Boolean = false;
      
      private var gotoX:int;
      
      private var gotoY:int;
      
      private var image:Image;
      
      private var face:Face;
      
      private var list:Graphiclist;
      
      private const C_DEAD:uint = 10845777;
      
      private var endX:int;
      
      private var endY:int;
      
      private var stopAtEnd:Boolean;
      
      private const C_WAIT:uint = 12058485;
      
      private var wait:uint = 0;
      
      private var startX:int;
      
      private var startY:int;
      
      private var vSpeed:Number;
      
      private var hSpeed:Number;
      
      public function MovingPlat(player:Player, x:int, y:int, width:int, height:int, gotoX:int, gotoY:int, speed:Number, dontStart:Boolean, stopAtEnd:Boolean)
      {
         super(player,x,y,width,height);
         active = true;
         visible = true;
         layer = Main.DEPTH_ENVIRON;
         this.startX = x;
         this.startY = y;
         this.endX = gotoX;
         this.endY = gotoY;
         this.gotoX = this.endX;
         this.gotoY = this.endY;
         this.started = !dontStart;
         this.stopAtEnd = stopAtEnd;
         var p:Point = FP.angleXY(new Point(),FP.angle(x,y,gotoX,gotoY),speed);
         this.hSpeed = Math.abs(p.x);
         this.vSpeed = Math.abs(p.y);
         graphic = this.list = new Graphiclist();
         var bd:BitmapData = new BitmapData(width,height,true,4278190080);
         bd.fillRect(new Rectangle(1,1,bd.width - 2,bd.height - 2),4294967295);
         var q:int = Math.floor(bd.height / 4);
         bd.fillRect(new Rectangle(1,bd.height - 1 - q,bd.width - 2,q),4292730333);
         this.list.add(this.image = new Image(bd));
         this.image.color = !!dontStart?uint(this.C_WAIT):uint(this.C_MOVE);
         this.list.add(this.face = new Face(width / 2,Math.max(6,height / 4)));
         this.face.play("happy");
      }
      
      override public function update() : void
      {
         if(this.stopped)
         {
            return;
         }
         if(this.started)
         {
            if(this.hSpeed != 0)
            {
               moveH(FP.approach(x,this.gotoX,this.hSpeed) - x);
            }
            if(this.vSpeed != 0)
            {
               moveV(FP.approach(y,this.gotoY,this.vSpeed) - y);
            }
            if(x == this.gotoX && y == this.gotoY)
            {
               if(this.stopAtEnd)
               {
                  shake = 10;
                  this.stopped = true;
                  this.image.color = this.C_DEAD;
                  this.face.play("pain");
                  Assets.SndMovingEnd.play();
                  return;
               }
               if(this.gotoX == this.endX && this.gotoY == this.endY)
               {
                  this.gotoX = this.startX;
                  this.gotoY = this.startY;
               }
               else
               {
                  this.gotoX = this.endX;
                  this.gotoY = this.endY;
               }
            }
         }
         else if(this.wait > 0)
         {
            this.wait--;
            if(this.wait == 0)
            {
               if(grapple)
               {
                  this.face.play("laughing");
               }
               else
               {
                  this.face.play("happy");
               }
               this.image.color = this.C_MOVE;
               shake = 0;
               this.started = true;
            }
         }
         else if(player && player.grapple && player.grapple.latched == this || collideWith(player,x,y - 1))
         {
            shake = -1;
            this.wait = this.SHAKE_TIME;
            this.face.play("surprised");
            Assets.SndMovingStart.play();
         }
      }
      
      override public function onRelease() : void
      {
         if(this.face.currentAnim == "laughing")
         {
            this.face.play("happy");
         }
      }
      
      override public function onGrapple() : void
      {
         if(this.face.currentAnim == "happy" && this.started)
         {
            this.face.play("laughing");
         }
      }
   }
}
