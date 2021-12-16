package net.flashpunk.utils
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   
   public class Draw
   {
      
      private static var _rect:Rectangle = FP.rect;
      
      private static var _graphics:Graphics = FP.sprite.graphics;
      
      private static var _camera:Point;
      
      private static var _matrix:Matrix = new Matrix();
      
      public static var blend:String;
      
      private static var _target:BitmapData;
       
      
      public function Draw()
      {
         super();
      }
      
      public static function resetTarget() : void
      {
         _target = FP.buffer;
         _camera = FP.camera;
         Draw.blend = null;
      }
      
      public static function rect(x:int, y:int, width:uint, height:uint, color:uint = 16777215, alpha:Number = 1) : void
      {
         if(alpha >= 1 && !blend)
         {
            if(color < 4278190080)
            {
               color = color + 4278190080;
            }
            _rect.x = x - _camera.x;
            _rect.y = y - _camera.y;
            _rect.width = width;
            _rect.height = height;
            _target.fillRect(_rect,color);
         }
         _graphics.clear();
         _graphics.beginFill(color,alpha);
         _graphics.drawRect(x - _camera.x,y - _camera.y,width,height);
         _target.draw(FP.sprite,null,null,blend);
      }
      
      public static function linePlus(x1:int, y1:int, x2:int, y2:int, color:uint = 4.27819008E9, alpha:Number = 1, thick:Number = 1) : void
      {
         _graphics.clear();
         _graphics.lineStyle(thick,color,alpha,false,LineScaleMode.NONE);
         _graphics.moveTo(x1 - _camera.x,y1 - _camera.y);
         _graphics.lineTo(x2 - _camera.x,y2 - _camera.y);
         _target.draw(FP.sprite,null,null,blend);
      }
      
      public static function curve(x1:int, y1:int, x2:int, y2:int, x3:int, y3:int) : void
      {
         _graphics.clear();
         _graphics.lineStyle(1,16711680);
         _graphics.moveTo(x1,y1);
         _graphics.curveTo(x2,y2,x3,y3);
         _target.draw(FP.sprite,null,null,blend);
      }
      
      public static function circle(x:int, y:int, radius:Number, color:uint = 0, alpha:Number = 1) : void
      {
         _graphics.clear();
         _graphics.beginFill(color & 16777215,alpha);
         _graphics.drawCircle(x - _camera.x,y - _camera.y,radius);
         _graphics.endFill();
         _target.draw(FP.sprite,null,null,blend);
      }
      
      public static function setTarget(target:BitmapData, camera:Point = null, blend:String = null) : void
      {
         _target = target;
         _camera = !!camera?camera:FP.zero;
         Draw.blend = blend;
      }
      
      public static function line(x1:int, y1:int, x2:int, y2:int, color:uint = 16777215) : void
      {
         var xx:int = 0;
         var yy:int = 0;
         var slope:Number = NaN;
         if(color < 4278190080)
         {
            color = 4278190080 | color;
         }
         x1 = x1 - _camera.x;
         y1 = y1 - _camera.y;
         x2 = x2 - _camera.x;
         y2 = y2 - _camera.y;
         var screen:BitmapData = _target;
         var X:Number = Math.abs(x2 - x1);
         var Y:Number = Math.abs(y2 - y1);
         if(X == 0)
         {
            if(Y == 0)
            {
               screen.setPixel32(x1,y1,color);
               return;
            }
            yy = y2 > y1?1:-1;
            while(y1 != y2)
            {
               screen.setPixel32(x1,y1,color);
               y1 = y1 + yy;
            }
            screen.setPixel32(x2,y2,color);
            return;
         }
         if(Y == 0)
         {
            xx = x2 > x1?1:-1;
            while(x1 != x2)
            {
               screen.setPixel32(x1,y1,color);
               x1 = x1 + xx;
            }
            screen.setPixel32(x2,y2,color);
            return;
         }
         xx = x2 > x1?1:-1;
         yy = y2 > y1?1:-1;
         var c:Number = 0;
         if(X > Y)
         {
            slope = Y / X;
            c = 0.5;
            while(x1 != x2)
            {
               screen.setPixel32(x1,y1,color);
               x1 = x1 + xx;
               c = c + slope;
               if(c >= 1)
               {
                  y1 = y1 + yy;
                  c--;
               }
            }
            screen.setPixel32(x2,y2,color);
            return;
         }
         slope = X / Y;
         c = 0.5;
         while(y1 != y2)
         {
            screen.setPixel32(x1,y1,color);
            y1 = y1 + yy;
            c = c + slope;
            if(c >= 1)
            {
               x1 = x1 + xx;
               c--;
            }
         }
         screen.setPixel32(x2,y2,color);
      }
      
      public static function hitbox(e:Entity, outline:Boolean = true, color:uint = 16777215, alpha:Number = 1) : void
      {
         var x:int = 0;
         var y:int = 0;
         if(outline)
         {
            if(color < 4278190080)
            {
               color = color + 4278190080;
            }
            x = e.x - e.originX - _camera.x;
            y = e.y - e.originY - _camera.y;
            _rect.x = x;
            _rect.y = y;
            _rect.width = e.width;
            _rect.height = 1;
            _target.fillRect(_rect,color);
            _rect.y = _rect.y + (e.height - 1);
            _target.fillRect(_rect,color);
            _rect.y = y;
            _rect.width = 1;
            _rect.height = e.height;
            _target.fillRect(_rect,color);
            _rect.x = _rect.x + (e.width - 1);
            _target.fillRect(_rect,color);
            return;
         }
         if(alpha >= 1)
         {
            if(color < 4278190080)
            {
               color = color + 4278190080;
            }
            _rect.x = e.x - e.originX - _camera.x;
            _rect.y = e.y - e.originY - _camera.y;
            _rect.width = e.width;
            _rect.height = e.height;
            _target.fillRect(_rect,color);
            return;
         }
         _graphics.clear();
         _graphics.beginFill(color,alpha);
         _graphics.drawRect(e.x - e.originX - _camera.x,e.y - e.originY - _camera.y,e.width,e.height);
         _target.draw(FP.sprite,null,null,blend);
      }
   }
}
