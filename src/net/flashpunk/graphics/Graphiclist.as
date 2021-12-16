package net.flashpunk.graphics
{
   import flash.geom.Point;
   import net.flashpunk.*;
   
   public class Graphiclist extends Graphic
   {
       
      
      private var _graphics:Vector.<Graphic>;
      
      private var _camera:Point;
      
      private var _count:uint;
      
      private var _point:Point;
      
      private var _temp:Vector.<Graphic>;
      
      public function Graphiclist(... graphic)
      {
         var g:Graphic = null;
         this._graphics = new Vector.<Graphic>();
         this._temp = new Vector.<Graphic>();
         this._point = new Point();
         this._camera = new Point();
         super();
         for each(g in graphic)
         {
            this.add(g);
         }
      }
      
      public function add(graphic:Graphic) : Graphic
      {
         var _loc2_:* = this._count++;
         this._graphics[_loc2_] = graphic;
         if(!active)
         {
            active = graphic.active;
         }
         return graphic;
      }
      
      public function remove(graphic:Graphic) : Graphic
      {
         var g:Graphic = null;
         var temp:Vector.<Graphic> = null;
         if(this._graphics.indexOf(graphic) < 0)
         {
            return graphic;
         }
         this._temp.length = 0;
         for each(g in this._graphics)
         {
            if(g == graphic)
            {
               this._count--;
            }
            else
            {
               this._temp[this._temp.length] = g;
            }
         }
         temp = this._graphics;
         this._graphics = this._temp;
         this._temp = temp;
         this.updateCheck();
         return graphic;
      }
      
      public function get children() : Vector.<Graphic>
      {
         return this._graphics;
      }
      
      override public function update() : void
      {
         var g:Graphic = null;
         for each(g in this._graphics)
         {
            if(g.active)
            {
               g.update();
            }
         }
      }
      
      public function get count() : uint
      {
         return this._count;
      }
      
      override public function render(point:Point, camera:Point) : void
      {
         var g:Graphic = null;
         point.x = point.x + x;
         point.y = point.y + y;
         camera.x = camera.x * scrollX;
         camera.y = camera.y * scrollY;
         for each(g in this._graphics)
         {
            if(g.visible)
            {
               if(g.relative)
               {
                  this._point.x = point.x;
                  this._point.y = point.y;
               }
               else
               {
                  this._point.y = 0;
                  this._point.x = 0;
               }
               this._camera.x = camera.x;
               this._camera.y = camera.y;
               g.render(this._point,this._camera);
            }
         }
      }
      
      public function removeAt(index:uint = 0) : void
      {
         if(!this._graphics.length)
         {
            return;
         }
         index = index % this._graphics.length;
         this.remove(this._graphics[index % this._graphics.length]);
         this.updateCheck();
      }
      
      public function removeAll() : void
      {
         this._graphics.length = this._temp.length = this._count = 0;
         active = false;
      }
      
      private function updateCheck() : void
      {
         var g:Graphic = null;
         active = false;
         for each(g in this._graphics)
         {
            if(g.active)
            {
               active = true;
               return;
            }
         }
      }
   }
}
