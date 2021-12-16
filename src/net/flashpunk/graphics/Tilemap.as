package net.flashpunk.graphics
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.flashpunk.FP;
   
   public class Tilemap extends Canvas
   {
       
      
      private var _rect:Rectangle;
      
      private var _rows:uint;
      
      private var _point:Point;
      
      private var _tile:Rectangle;
      
      private var _setRows:uint;
      
      private var _map:BitmapData;
      
      private var _columns:uint;
      
      public var usePositions:Boolean;
      
      private var _set:BitmapData;
      
      private var _setCount:uint;
      
      private var _setColumns:uint;
      
      public function Tilemap(tileset:*, width:uint, height:uint, tileWidth:uint, tileHeight:uint)
      {
         this._point = FP.point;
         this._rect = FP.rect;
         _width = width - width % tileWidth;
         _height = height - height % tileHeight;
         this._columns = _width / tileWidth;
         this._rows = _height / tileHeight;
         this._map = new BitmapData(this._columns,this._rows,false,0);
         this._tile = new Rectangle(0,0,tileWidth,tileHeight);
         _maxWidth = _maxWidth - _maxWidth % tileWidth;
         _maxHeight = _maxHeight - _maxHeight % tileHeight;
         super(_width,_height);
         if(tileset is Class)
         {
            this._set = FP.getBitmap(tileset);
         }
         else if(tileset is BitmapData)
         {
            this._set = tileset;
         }
         if(!this._set)
         {
            throw new Error("Invalid tileset graphic provided.");
         }
         this._setColumns = uint(this._set.width / tileWidth);
         this._setRows = uint(this._set.height / tileHeight);
         this._setCount = this._setColumns * this._setRows;
      }
      
      public function saveToString(columnSep:String = ",", rowSep:String = "\n") : String
      {
         var x:int = 0;
         var y:int = 0;
         var s:String = "";
         for(y = 0; y < this._rows; y++)
         {
            for(x = 0; x < this._columns; x++)
            {
               s = s + this.getTile(x,y);
               if(x != this._columns - 1)
               {
                  s = s + columnSep;
               }
            }
            if(y != this._rows - 1)
            {
               s = s + rowSep;
            }
         }
         return s;
      }
      
      public function clearTile(column:uint, row:uint) : void
      {
         if(this.usePositions)
         {
            column = column / this._tile.width;
            row = row / this._tile.height;
         }
         column = column % this._columns;
         row = row % this._rows;
         this._tile.x = column * this._tile.width;
         this._tile.y = row * this._tile.height;
         fill(this._tile,0);
      }
      
      public function clearRegion(column:uint, row:uint, width:uint = 1, height:uint = 1) : void
      {
         if(this.usePositions)
         {
            column = column / this._tile.width;
            row = row / this._tile.height;
            width = width / this._tile.width;
            height = height / this._tile.height;
         }
         column = column % this._columns;
         row = row % this._rows;
         var c:uint = column;
         var r:uint = column + width;
         var b:uint = row + height;
         var u:Boolean = this.usePositions;
         this.usePositions = false;
         while(row < b)
         {
            while(column < r)
            {
               this.clearTile(column,row);
               column++;
            }
            column = c;
            row++;
         }
         this.usePositions = u;
      }
      
      public function getTile(column:uint, row:uint) : uint
      {
         if(this.usePositions)
         {
            column = column / this._tile.width;
            row = row / this._tile.height;
         }
         return this._map.getPixel(column % this._columns,row % this._rows);
      }
      
      public function loadFromString(str:String, columnSep:String = ",", rowSep:String = "\n") : void
      {
         var col:Array = null;
         var cols:int = 0;
         var x:int = 0;
         var y:int = 0;
         var row:Array = str.split(rowSep);
         var rows:int = row.length;
         for(y = 0; y < rows; y++)
         {
            if(row[y] != "")
            {
               col = row[y].split(columnSep);
               cols = col.length;
               for(x = 0; x < cols; x++)
               {
                  if(col[x] != "")
                  {
                     this.setTile(x,y,uint(col[x]));
                  }
               }
            }
         }
      }
      
      public function getIndex(tilesColumn:uint, tilesRow:uint) : uint
      {
         return tilesRow % this._setRows * this._setColumns + tilesColumn % this._setColumns;
      }
      
      public function setTile(column:uint, row:uint, index:uint = 0) : void
      {
         if(this.usePositions)
         {
            column = column / this._tile.width;
            row = row / this._tile.height;
         }
         index = index % this._setCount;
         column = column % this._columns;
         row = row % this._rows;
         this._tile.x = index % this._setColumns * this._tile.width;
         this._tile.y = uint(index / this._setColumns) * this._tile.height;
         this._map.setPixel(column,row,index);
         draw(column * this._tile.width,row * this._tile.height,this._set,this._tile);
      }
      
      public function get tileHeight() : uint
      {
         return this._tile.height;
      }
      
      public function setRegion(column:uint, row:uint, width:uint = 1, height:uint = 1, index:uint = 0) : void
      {
         if(this.usePositions)
         {
            column = column / this._tile.width;
            row = row / this._tile.height;
            width = width / this._tile.width;
            height = height / this._tile.height;
         }
         column = column % this._columns;
         row = row % this._rows;
         var c:uint = column;
         var r:uint = column + width;
         var b:uint = row + height;
         var u:Boolean = this.usePositions;
         this.usePositions = false;
         while(row < b)
         {
            while(column < r)
            {
               this.setTile(column,row,index);
               column++;
            }
            column = c;
            row++;
         }
         this.usePositions = u;
      }
      
      public function get tileWidth() : uint
      {
         return this._tile.width;
      }
   }
}
