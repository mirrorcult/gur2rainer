package net.flashpunk.graphics
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import net.flashpunk.FP;
   
   public class TiledSpritemap extends Spritemap
   {
       
      
      private var _imageHeight:uint;
      
      private var _offsetY:Number = 0;
      
      private var _graphics:Graphics;
      
      private var _imageWidth:uint;
      
      private var _offsetX:Number = 0;
      
      public function TiledSpritemap(source:*, frameWidth:uint = 0, frameHeight:uint = 0, width:uint = 0, height:uint = 0, callback:Function = null)
      {
         this._graphics = FP.sprite.graphics;
         this._imageWidth = width;
         this._imageHeight = height;
         super(source,frameWidth,frameHeight,callback);
      }
      
      public function get offsetX() : Number
      {
         return this._offsetX;
      }
      
      public function get offsetY() : Number
      {
         return this._offsetY;
      }
      
      override public function updateBuffer() : void
      {
         _rect.x = _rect.width * _frame;
         _rect.y = uint(_rect.x / _width) * _rect.height;
         _rect.x = _rect.x % _width;
         if(_flipped)
         {
            _rect.x = _width - _rect.width - _rect.x;
         }
         var xx:int = int(this._offsetX) % this._imageWidth;
         var yy:int = int(this._offsetY) % this._imageHeight;
         if(xx >= 0)
         {
            xx = xx - this._imageWidth;
         }
         if(yy >= 0)
         {
            yy = yy - this._imageHeight;
         }
         FP.point.x = xx;
         FP.point.y = yy;
         while(FP.point.y < this._imageHeight)
         {
            while(FP.point.x < this._imageWidth)
            {
               _buffer.copyPixels(_source,_sourceRect,FP.point);
               FP.point.x = FP.point.x + _sourceRect.width;
            }
            FP.point.x = xx;
            FP.point.y = FP.point.y + _sourceRect.height;
         }
         if(_tint)
         {
            _buffer.colorTransform(_bufferRect,_tint);
         }
      }
      
      public function set offsetY(value:Number) : void
      {
         if(this._offsetY == value)
         {
            return;
         }
         this._offsetY = value;
         this.updateBuffer();
      }
      
      public function setOffset(x:Number, y:Number) : void
      {
         if(this._offsetX == x && this._offsetY == y)
         {
            return;
         }
         this._offsetX = x;
         this._offsetY = y;
         this.updateBuffer();
      }
      
      public function set offsetX(value:Number) : void
      {
         if(this._offsetX == value)
         {
            return;
         }
         this._offsetX = value;
         this.updateBuffer();
      }
      
      override protected function createBuffer() : void
      {
         if(!this._imageWidth)
         {
            this._imageWidth = _sourceRect.width;
         }
         if(!this._imageHeight)
         {
            this._imageHeight = _sourceRect.height;
         }
         _buffer = new BitmapData(this._imageWidth,this._imageHeight,true,0);
         _bufferRect = _buffer.rect;
      }
   }
}
