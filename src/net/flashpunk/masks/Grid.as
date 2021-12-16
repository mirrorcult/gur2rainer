package net.flashpunk.masks
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.flashpunk.FP;
   import net.flashpunk.Mask;
   
   public class Grid extends Hitbox
   {
       
      
      private var _cell:Rectangle;
      
      private var _rect:Rectangle;
      
      private var _point2:Point;
      
      private var _data:BitmapData;
      
      private var _point:Point;
      
      private var _columns:uint;
      
      public var usePositions:Boolean;
      
      private var _rows:uint;
      
      public function Grid(width:uint, height:uint, cellWidth:uint, cellHeight:uint, x:int = 0, y:int = 0)
      {
         this._rect = FP.rect;
         this._point = FP.point;
         this._point2 = FP.point2;
         super();
         if(!width || !height || !cellWidth || !cellHeight)
         {
            throw new Error("Illegal Grid, sizes cannot be 0.");
         }
         this._columns = width / cellWidth;
         this._rows = height / cellHeight;
         this._data = new BitmapData(this._columns,this._rows,true,0);
         this._cell = new Rectangle(0,0,cellWidth,cellHeight);
         _x = x;
         _y = y;
         _width = width;
         _height = height;
         _check[Mask] = this.collideMask;
         _check[Hitbox] = this.collideHitbox;
         _check[Pixelmask] = this.collidePixelmask;
      }
      
      private function collideMask(other:Mask) : Boolean
      {
         this._rect.x = other.parent.x - other.parent.originX - parent.x + parent.originX;
         this._rect.y = other.parent.y - other.parent.originY - parent.y + parent.originY;
         this._point.x = int((this._rect.x + other.parent.width - 1) / this._cell.width) + 1;
         this._point.y = int((this._rect.y + other.parent.height - 1) / this._cell.height) + 1;
         this._rect.x = int(this._rect.x / this._cell.width);
         this._rect.y = int(this._rect.y / this._cell.height);
         this._rect.width = this._point.x - this._rect.x;
         this._rect.height = this._point.y - this._rect.y;
         return this._data.hitTest(FP.zero,1,this._rect);
      }
      
      private function collidePixelmask(other:Pixelmask) : Boolean
      {
         var x1:int = other.parent.x + other._x - parent.x - _x;
         var y1:int = other.parent.y + other._y - parent.y - _y;
         var x2:int = (x1 + other._width - 1) / this._cell.width;
         var y2:int = (y1 + other._height - 1) / this._cell.height;
         this._point.x = x1;
         this._point.y = y1;
         x1 = x1 / this._cell.width;
         y1 = y1 / this._cell.height;
         this._cell.x = x1 * this._cell.width;
         this._cell.y = y1 * this._cell.height;
         var xx:int = x1;
         while(y1 <= y2)
         {
            while(x1 <= x2)
            {
               if(this._data.getPixel32(x1,y1))
               {
                  if(other._data.hitTest(this._point,1,this._cell))
                  {
                     return true;
                  }
               }
               x1++;
               this._cell.x = this._cell.x + this._cell.width;
            }
            x1 = xx;
            y1++;
            this._cell.x = x1 * this._cell.width;
            this._cell.y = this._cell.y + this._cell.height;
         }
         return false;
      }
      
      public function getCell(x:uint = 0, y:uint = 0) : Boolean
      {
         if(this.usePositions)
         {
            x = x / this._cell.width;
            y = y / this._cell.height;
         }
         return this._data.getPixel32(x,y) > 0;
      }
      
      public function get rows() : uint
      {
         return this._rows;
      }
      
      public function get columns() : uint
      {
         return this._columns;
      }
      
      public function setCell(x:uint = 0, y:uint = 0, solid:Boolean = true) : void
      {
         if(this.usePositions)
         {
            x = x / this._cell.width;
            y = y / this._cell.height;
         }
         this._data.setPixel32(x,y,!!solid?uint(4294967295):uint(0));
      }
      
      public function setRect(x:uint = 0, y:uint = 0, width:int = 1, height:int = 1, solid:Boolean = true) : void
      {
         if(this.usePositions)
         {
            x = x / this._cell.width;
            y = y / this._cell.height;
            width = width / this._cell.width;
            height = height / this._cell.height;
         }
         this._rect.x = x;
         this._rect.y = y;
         this._rect.width = width;
         this._rect.height = height;
         this._data.fillRect(this._rect,!!solid?uint(4294967295):uint(0));
      }
      
      public function get data() : BitmapData
      {
         return this._data;
      }
      
      private function collideHitbox(other:Hitbox) : Boolean
      {
         this._rect.x = other.parent.x + other._x - parent.x - _x;
         this._rect.y = other.parent.y + other._y - parent.y - _y;
         this._point.x = int((this._rect.x + other._width - 1) / this._cell.width) + 1;
         this._point.y = int((this._rect.y + other._height - 1) / this._cell.height) + 1;
         this._rect.x = int(this._rect.x / this._cell.width);
         this._rect.y = int(this._rect.y / this._cell.height);
         this._rect.width = this._point.x - this._rect.x;
         this._rect.height = this._point.y - this._rect.y;
         return this._data.hitTest(FP.zero,1,this._rect);
      }
   }
}
