package net.flashpunk.graphics
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.flashpunk.FP;
   import net.flashpunk.Graphic;
   
   public class Canvas extends Graphic
   {
       
      
      protected var _width:uint;
      
      private var _rect:Rectangle;
      
      public var blend:String;
      
      private var _refWidth:uint;
      
      private var _ref:BitmapData;
      
      protected var _height:uint;
      
      private var _tint:ColorTransform;
      
      private var _refHeight:uint;
      
      private var _matrix:Matrix;
      
      protected var _maxWidth:uint = 4000;
      
      private var _color:uint = 16777215;
      
      private var _alpha:Number = 1;
      
      private var _point:Point;
      
      private var _graphics:Graphics;
      
      protected var _maxHeight:uint = 4000;
      
      private var _colorTransform:ColorTransform;
      
      private var _buffers:Vector.<BitmapData>;
      
      public function Canvas(width:uint, height:uint)
      {
         var x:uint = 0;
         var y:uint = 0;
         var w:uint = 0;
         var h:uint = 0;
         var i:uint = 0;
         this._buffers = new Vector.<BitmapData>();
         this._colorTransform = new ColorTransform();
         this._matrix = new Matrix();
         this._point = FP.point;
         this._rect = new Rectangle();
         this._graphics = FP.sprite.graphics;
         super();
         this._width = width;
         this._height = height;
         this._refWidth = Math.ceil(width / this._maxWidth);
         this._refHeight = Math.ceil(height / this._maxHeight);
         this._ref = new BitmapData(this._refWidth,this._refHeight,false,0);
         var ww:uint = this._width % this._maxWidth;
         var hh:uint = this._height % this._maxHeight;
         if(!ww)
         {
            ww = this._maxWidth;
         }
         if(!hh)
         {
            hh = this._maxHeight;
         }
         while(y < this._refHeight)
         {
            h = y < this._refHeight - 1?uint(this._maxHeight):uint(hh);
            while(x < this._refWidth)
            {
               w = x < this._refWidth - 1?uint(this._maxWidth):uint(ww);
               this._ref.setPixel(x,y,i);
               this._buffers[i] = new BitmapData(w,h,true,0);
               i++;
               x++;
            }
            x = 0;
            y++;
         }
      }
      
      public function fill(rect:Rectangle, color:uint = 0, alpha:Number = 1) : void
      {
         var xx:int = 0;
         var yy:int = 0;
         var buffer:BitmapData = null;
         if(alpha >= 1)
         {
            this._rect.width = rect.width;
            this._rect.height = rect.height;
            for each(buffer in this._buffers)
            {
               this._rect.x = rect.x - xx;
               this._rect.y = rect.y - yy;
               buffer.fillRect(this._rect,4278190080 | color);
               xx = xx + this._maxWidth;
               if(xx >= this._width)
               {
                  xx = 0;
                  yy = yy + this._maxHeight;
               }
            }
            return;
         }
         for each(buffer in this._buffers)
         {
            this._graphics.clear();
            this._graphics.beginFill(color,alpha);
            this._graphics.drawRect(rect.x - xx,rect.y - yy,rect.width,rect.height);
            buffer.draw(FP.sprite);
            xx = xx + this._maxWidth;
            if(xx >= this._width)
            {
               xx = 0;
               yy = yy + this._maxHeight;
            }
         }
         this._graphics.endFill();
      }
      
      public function draw(x:int, y:int, source:BitmapData, rect:Rectangle = null) : void
      {
         var xx:int = 0;
         var yy:int = 0;
         var buffer:BitmapData = null;
         for each(buffer in this._buffers)
         {
            this._point.x = x - xx;
            this._point.y = y - yy;
            buffer.copyPixels(source,!!rect?rect:source.rect,this._point,null,null,true);
            xx = xx + this._maxWidth;
            if(xx >= this._width)
            {
               xx = 0;
               yy = yy + this._maxHeight;
            }
         }
      }
      
      public function set color(value:uint) : void
      {
         value = value % 16777215;
         if(this._color == value)
         {
            return;
         }
         this._color = value;
         if(this._alpha == 1 && this._color == 16777215)
         {
            this._tint = null;
            return;
         }
         this._tint = this._colorTransform;
         this._tint.redMultiplier = (this._color >> 16 & 255) / 255;
         this._tint.greenMultiplier = (this._color >> 8 & 255) / 255;
         this._tint.blueMultiplier = (this._color & 255) / 255;
         this._tint.alphaMultiplier = this._alpha;
      }
      
      public function drawGraphic(x:int, y:int, source:Graphic) : void
      {
         var xx:int = 0;
         var yy:int = 0;
         var buffer:BitmapData = null;
         var temp:BitmapData = FP.buffer;
         for each(buffer in this._buffers)
         {
            FP.buffer = buffer;
            this._point.x = x - xx;
            this._point.y = y - yy;
            source.render(this._point,FP.zero);
            xx = xx + this._maxWidth;
            if(xx >= this._width)
            {
               xx = 0;
               yy = yy + this._maxHeight;
            }
         }
         FP.buffer = temp;
      }
      
      public function get width() : uint
      {
         return this._width;
      }
      
      override public function render(point:Point, camera:Point) : void
      {
         var xx:int = 0;
         var yy:int = 0;
         var buffer:BitmapData = null;
         point.x = point.x + (x - camera.x * scrollX);
         point.y = point.y + (y - camera.y * scrollY);
         var px:Number = point.x;
         while(yy < this._refHeight)
         {
            while(xx < this._refWidth)
            {
               buffer = this._buffers[this._ref.getPixel(xx,yy)];
               if(this._tint || this.blend)
               {
                  this._matrix.tx = point.x;
                  this._matrix.ty = point.y;
                  FP.buffer.draw(buffer,this._matrix,this._tint,this.blend);
               }
               else
               {
                  FP.buffer.copyPixels(buffer,buffer.rect,point,null,null,true);
               }
               point.x = point.x + this._maxWidth;
               xx++;
            }
            point.x = px;
            point.y = point.y + this._maxHeight;
            xx = 0;
            yy++;
         }
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function fillTexture(rect:Rectangle, texture:BitmapData) : void
      {
         var xx:int = 0;
         var yy:int = 0;
         var buffer:BitmapData = null;
         for each(buffer in this._buffers)
         {
            this._graphics.clear();
            this._graphics.beginBitmapFill(texture);
            this._graphics.drawRect(rect.x - xx,rect.y - yy,rect.width,rect.height);
            buffer.draw(FP.sprite);
            xx = xx + this._maxWidth;
            if(xx >= this._width)
            {
               xx = 0;
               yy = yy + this._maxHeight;
            }
         }
         this._graphics.endFill();
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function get height() : uint
      {
         return this._height;
      }
      
      public function set alpha(value:Number) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         if(value > 1)
         {
            value = 1;
         }
         if(this._alpha == value)
         {
            return;
         }
         this._alpha = value;
         if(this._alpha == 1 && this._color == 16777215)
         {
            this._tint = null;
            return;
         }
         this._tint = this._colorTransform;
         this._tint.redMultiplier = (this._color >> 16 & 255) / 255;
         this._tint.greenMultiplier = (this._color >> 8 & 255) / 255;
         this._tint.blueMultiplier = (this._color & 255) / 255;
         this._tint.alphaMultiplier = this._alpha;
      }
   }
}
