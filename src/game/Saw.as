package game
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import game.engine.Grabbable;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class Saw extends Grabbable
   {
      
      private static const ImgSaw:Class = Saw_ImgSaw;
       
      
      private var goOut:Boolean;
      
      private var stopAtEnd:Boolean;
      
      private var move:Boolean;
      
      private var stopped:Boolean = false;
      
      private var gotoX:int;
      
      private var gotoY:int;
      
      private var vSpeed:Number;
      
      private var motion:Boolean = false;
      
      private var startY:int;
      
      private var startX:int;
      
      private var hSpeed:Number;
      
      public function Saw(x:int, y:int, dir:int)
      {
         var s:Spritemap = null;
         super(x,y);
         width = 16;
         height = 16;
         originX = 8;
         originY = 8;
         type = "danger";
         layer = Main.DEPTH_ACTORS;
         force = true;
         forceSpin = 4 * dir;
         grapplePoint = new Point();
         active = false;
         s = new Spritemap(ImgSaw,18,18);
         s.flipped = dir == 1;
         s.add("spin",[0,1,2,3],0.4);
         s.play("spin");
         s.x = -9;
         s.y = -9;
         graphic = s;
      }
      
      override public function update() : void
      {
         if(this.move && !this.stopped)
         {
            if(this.goOut)
            {
               x = FP.approach(x,this.gotoX,this.hSpeed);
               y = FP.approach(y,this.gotoY,this.vSpeed);
               if(grapple)
               {
                  grapple.move(x - grapple.x,y - grapple.y);
               }
               if(x == this.gotoX && y == this.gotoY)
               {
                  if(this.stopAtEnd)
                  {
                     this.stopped = true;
                  }
                  this.goOut = false;
               }
            }
            else
            {
               x = FP.approach(x,this.startX,this.hSpeed);
               y = FP.approach(y,this.startY,this.vSpeed);
               if(grapple)
               {
                  grapple.move(x - grapple.x,y - grapple.y);
               }
               if(x == this.startX && y == this.startY)
               {
                  this.goOut = true;
               }
            }
         }
      }
      
      private function startMove() : void
      {
         if(grapple && !this.move)
         {
            this.move = true;
         }
      }
      
      override public function onGrapple() : void
      {
         if(this.motion && !this.move)
         {
            addTween(new Alarm(30,this.startMove,Tween.ONESHOT),true);
         }
      }
      
      public function setMotion(gotoX:int, gotoY:int, speed:Number, dontMove:Boolean, stopAtEnd:Boolean) : void
      {
         var bd:BitmapData = null;
         var image:Image = null;
         this.motion = true;
         this.startX = x;
         this.startY = y;
         this.gotoX = gotoX;
         this.gotoY = gotoY;
         FP.angleXY(FP.point,FP.angle(x,y,gotoX,gotoY),speed);
         this.hSpeed = Math.abs(FP.point.x);
         this.vSpeed = Math.abs(FP.point.y);
         this.goOut = true;
         active = true;
         this.move = !dontMove;
         this.stopAtEnd = stopAtEnd;
         var list:Graphiclist = new Graphiclist();
         if(gotoX != x)
         {
            bd = new BitmapData(gotoX - x + 4,4,true,4294967295);
         }
         else
         {
            bd = new BitmapData(4,gotoY - y + 4,true,4294967295);
         }
         image = new Image(bd);
         image.relative = false;
         image.x = x - 2;
         image.y = y - 2;
         image.alpha = 0.3;
         list.add(image);
         list.add(graphic);
         graphic = list;
      }
   }
}
