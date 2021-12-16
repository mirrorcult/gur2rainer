package net.flashpunk.graphics
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import net.flashpunk.FP;
   
   public class Backdrop extends Canvas
   {
       
      
      private var _textWidth:uint;
      
      private var _texture:BitmapData;
      
      private var _repeatX:Boolean;
      
      private var _y:Number;
      
      private var _textHeight:uint;
      
      private var _x:Number;
      
      private var _repeatY:Boolean;
      
      public function Backdrop(texture:*, repeatX:Boolean = true, repeatY:Boolean = true)
      {
         if(texture is Class)
         {
            this._texture = FP.getBitmap(texture);
         }
         else if(texture is BitmapData)
         {
            this._texture = texture;
         }
         if(!this._texture)
         {
            this._texture = new BitmapData(FP.width,FP.height,true,0);
         }
         this._repeatX = repeatX;
         this._repeatY = repeatY;
         this._textWidth = this._texture.width;
         this._textHeight = this._texture.height;
         super(FP.width * uint(repeatX) + this._textWidth,FP.height * uint(repeatY) + this._textHeight);
         FP.rect.y = 0;
         FP.rect.x = 0;
         FP.rect.width = _width;
         FP.rect.height = _height;
         fillTexture(FP.rect,this._texture);
      }
      
      override public function render(point:Point, camera:Point) : void
      {
         point.x = point.x + (x - camera.x * scrollX);
         point.y = point.y + (y - camera.y * scrollY);
         if(this._repeatX)
         {
            point.x = point.x % this._textWidth;
            if(point.x > 0)
            {
               point.x = point.x - this._textWidth;
            }
         }
         if(this._repeatY)
         {
            point.y = point.y % this._textHeight;
            if(point.y > 0)
            {
               point.y = point.y - this._textHeight;
            }
         }
         this._x = x;
         this._y = y;
         camera.x = camera.y = x = y = 0;
         super.render(point,camera);
         x = this._x;
         y = this._y;
      }
   }
}
