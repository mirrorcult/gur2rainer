package net.flashpunk
{
   import flash.geom.Point;
   
   public class Graphic
   {
       
      
      public var y:Number = 0;
      
      var _scroll:Boolean = true;
      
      public var active:Boolean = false;
      
      public var scrollX:Number = 1;
      
      public var scrollY:Number = 1;
      
      var _assign:Function;
      
      public var x:Number = 0;
      
      public var visible:Boolean = true;
      
      public var relative:Boolean = true;
      
      public function Graphic()
      {
         super();
      }
      
      public function update() : void
      {
      }
      
      protected function get assign() : Function
      {
         return this._assign;
      }
      
      public function render(point:Point, camera:Point) : void
      {
      }
      
      protected function set assign(value:Function) : void
      {
         this._assign = value;
      }
   }
}
