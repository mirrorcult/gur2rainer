package net.flashpunk.masks
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.flashpunk.FP;
   import net.flashpunk.Mask;
   
   public class Pixelmask extends Hitbox
   {
       
      
      private var _point2:Point;
      
      private var _rect:Rectangle;
      
      var _data:BitmapData;
      
      public var threshold:uint = 1;
      
      private var _point:Point;
      
      public function Pixelmask(source:*, x:int = 0, y:int = 0)
      {
         this._rect = FP.rect;
         this._point = FP.point;
         this._point2 = FP.point2;
         super();
         if(source is BitmapData)
         {
            this._data = source;
         }
         if(source is Class)
         {
            this._data = FP.getBitmap(source);
         }
         if(!this._data)
         {
            throw new Error("Invalid Pixelmask source image.");
         }
         _width = this.data.width;
         _height = this.data.height;
         _x = x;
         _y = y;
         _check[Mask] = this.collideMask;
         _check[Pixelmask] = this.collidePixelmask;
         _check[Hitbox] = this.collideHitbox;
      }
      
      public function get data() : BitmapData
      {
         return this._data;
      }
      
      private function collideMask(other:Mask) : Boolean
      {
         this._point.x = parent.x + _x;
         this._point.y = parent.y + _y;
         this._rect.x = other.parent.x - other.parent.originX;
         this._rect.y = other.parent.y - other.parent.originY;
         this._rect.width = other.parent.width;
         this._rect.height = other.parent.height;
         return this._data.hitTest(this._point,this.threshold,this._rect);
      }
      
      private function collidePixelmask(other:Pixelmask) : Boolean
      {
         this._point.x = parent.x + _x;
         this._point.y = parent.y + _y;
         this._point2.x = other.parent.x + other._x;
         this._point2.y = other.parent.y + other._y;
         return this._data.hitTest(this._point,this.threshold,other._data,this._point2,other.threshold);
      }
      
      private function collideHitbox(other:Hitbox) : Boolean
      {
         this._point.x = parent.x + _x;
         this._point.y = parent.y + _y;
         this._rect.x = other.parent.x + other._x;
         this._rect.y = other.parent.y + other._y;
         this._rect.width = other._width;
         this._rect.height = other._height;
         return this._data.hitTest(this._point,this.threshold,this._rect);
      }
      
      public function set data(value:BitmapData) : void
      {
         this._data = value;
         _width = value.width;
         _height = value.height;
         update();
      }
   }
}
