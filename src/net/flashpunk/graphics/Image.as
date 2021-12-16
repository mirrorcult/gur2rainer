package net.flashpunk.graphics
{
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.flashpunk.FP;
   import net.flashpunk.Graphic;
   
   public class Image extends Graphic
   {
      
      private static var _flips:Object = {};
       
      
      public var smooth:Boolean;
      
      protected var _source:BitmapData;
      
      protected var _flipped:Boolean;
      
      public var scale:Number = 1;
      
      private var _flip:BitmapData;
      
      public var scaleX:Number = 1;
      
      public var scaleY:Number = 1;
      
      public var blend:String;
      
      public var angle:Number = 0;
      
      protected var _sourceRect:Rectangle;
      
      protected var _tint:ColorTransform;
      
      protected var _buffer:BitmapData;
      
      private var _matrix:Matrix;
      
      private var _color:uint = 16777215;
      
      private var _alpha:Number = 1;
      
      private var _colorTransform:ColorTransform;
      
      public var originX:int;
      
      public var originY:int;
      
      private var _class:String;
      
      protected var _bufferRect:Rectangle;
      
      public function Image(source:* = null, clipRect:Rectangle = null)
      {
         this._colorTransform = new ColorTransform();
         this._matrix = FP.matrix;
         super();
         if(source is Class)
         {
            this._source = FP.getBitmap(source);
            this._class = String(source);
         }
         else if(source is BitmapData)
         {
            this._source = source;
         }
         if(!this._source)
         {
            throw new Error("Invalid source image.");
         }
         this._sourceRect = this._source.rect;
         if(clipRect)
         {
            if(!clipRect.width)
            {
               clipRect.width = this._sourceRect.width;
            }
            if(!clipRect.height)
            {
               clipRect.height = this._sourceRect.height;
            }
            this._sourceRect = clipRect;
         }
         this.createBuffer();
         this.updateBuffer();
      }
      
      public static function createRect(width:uint, height:uint, color:uint = 16777215) : Image
      {
         var source:BitmapData = new BitmapData(width,height,true,4278190080 | color);
         return new Image(source);
      }
      
      public function get flipped() : Boolean
      {
         return this._flipped;
      }
      
      public function set flipped(value:Boolean) : void
      {
         if(this._flipped == value || !this._class)
         {
            return;
         }
         this._flipped = value;
         var temp:BitmapData = this._source;
         if(!value || this._flip)
         {
            this._source = this._flip;
            this._flip = temp;
            return this.updateBuffer();
         }
         if(_flips[this._class])
         {
            this._source = _flips[this._class];
            this._flip = temp;
            return this.updateBuffer();
         }
         this._source = _flips[this._class] = new BitmapData(this._source.width,this._source.height,true,0);
         this._flip = temp;
         FP.matrix.identity();
         FP.matrix.a = -1;
         FP.matrix.tx = this._source.width;
         this._source.draw(temp,FP.matrix);
         this.updateBuffer();
      }
      
      override public function render(point:Point, camera:Point) : void
      {
         if(!this._buffer)
         {
            return;
         }
         point.x = point.x + (x - camera.x * scrollX);
         point.y = point.y + (y - camera.y * scrollY);
         if(this.angle == 0 && this.scaleX * this.scale == 1 && this.scaleY * this.scale == 1 && !this.blend)
         {
            FP.buffer.copyPixels(this._buffer,this._bufferRect,point,null,null,true);
            return;
         }
         this._matrix.c = 0;
         this._matrix.b = 0;
         this._matrix.a = this.scaleX * this.scale;
         this._matrix.d = this.scaleY * this.scale;
         this._matrix.tx = -this.originX * this._matrix.a;
         this._matrix.ty = -this.originY * this._matrix.d;
         if(this.angle != 0)
         {
            this._matrix.rotate(this.angle * FP.RAD);
         }
         this._matrix.tx = this._matrix.tx + (this.originX + point.x);
         this._matrix.ty = this._matrix.ty + (this.originY + point.y);
         FP.buffer.draw(this._buffer,this._matrix,null,this.blend,null,this.smooth);
      }
      
      protected function get source() : BitmapData
      {
         return this._source;
      }
      
      public function get height() : uint
      {
         return this._bufferRect.height;
      }
      
      public function set alpha(value:Number) : void
      {
         value = value < 0?Number(0):value > 1?Number(1):Number(value);
         if(this._alpha == value)
         {
            return;
         }
         this._alpha = value;
         if(this._alpha == 1 && this._color == 16777215)
         {
            this._tint = null;
            return this.updateBuffer();
         }
         this._tint = this._colorTransform;
         this._tint.redMultiplier = (this._color >> 16 & 255) / 255;
         this._tint.greenMultiplier = (this._color >> 8 & 255) / 255;
         this._tint.blueMultiplier = (this._color & 255) / 255;
         this._tint.alphaMultiplier = this._alpha;
         this.updateBuffer();
      }
      
      public function set color(value:uint) : void
      {
         value = value & 16777215;
         if(this._color == value)
         {
            return;
         }
         this._color = value;
         if(this._alpha == 1 && this._color == 16777215)
         {
            this._tint = null;
            return this.updateBuffer();
         }
         this._tint = this._colorTransform;
         this._tint.redMultiplier = (this._color >> 16 & 255) / 255;
         this._tint.greenMultiplier = (this._color >> 8 & 255) / 255;
         this._tint.blueMultiplier = (this._color & 255) / 255;
         this._tint.alphaMultiplier = this._alpha;
         this.updateBuffer();
      }
      
      public function clear() : void
      {
         this._buffer.fillRect(this._bufferRect,0);
      }
      
      public function get clipRect() : Rectangle
      {
         return this._sourceRect;
      }
      
      public function get width() : uint
      {
         return this._bufferRect.width;
      }
      
      public function centerOrigin() : void
      {
         this.originX = this._bufferRect.width / 2;
         this.originY = this._bufferRect.height / 2;
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      protected function createBuffer() : void
      {
         this._buffer = new BitmapData(this._sourceRect.width,this._sourceRect.height,true,0);
         this._bufferRect = this._buffer.rect;
      }
      
      public function updateBuffer() : void
      {
         if(!this._source)
         {
            return;
         }
         this._buffer.copyPixels(this._source,this._sourceRect,FP.zero);
         if(this._tint)
         {
            this._buffer.colorTransform(this._bufferRect,this._tint);
         }
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function centerOO() : void
      {
         x = x + this.originX;
         y = y + this.originY;
         this.centerOrigin();
         x = x - this.originX;
         y = y - this.originY;
      }
   }
}
