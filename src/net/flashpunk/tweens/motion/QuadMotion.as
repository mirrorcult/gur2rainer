package net.flashpunk.tweens.motion
{
   import flash.geom.Point;
   import net.flashpunk.FP;
   
   public class QuadMotion extends Motion
   {
       
      
      private var _controlY:Number = 0;
      
      private var _fromX:Number = 0;
      
      private var _fromY:Number = 0;
      
      private var _distance:Number = -1;
      
      private var _controlX:Number = 0;
      
      private var _toX:Number = 0;
      
      private var _toY:Number = 0;
      
      public function QuadMotion(complete:Function = null, type:uint = 0)
      {
         super(0,complete,type,null);
      }
      
      override public function update() : void
      {
         super.update();
         x = this._fromX * (1 - _t) * (1 - _t) + this._controlX * 2 * (1 - _t) * _t + this._toX * _t * _t;
         y = this._fromY * (1 - _t) * (1 - _t) + this._controlY * 2 * (1 - _t) * _t + this._toY * _t * _t;
      }
      
      public function get distance() : Number
      {
         if(this._distance >= 0)
         {
            return this._distance;
         }
         var a:Point = FP.point;
         var b:Point = FP.point2;
         a.x = x - 2 * this._controlX + this._toX;
         a.y = y - 2 * this._controlY + this._toY;
         b.x = 2 * this._controlX - 2 * x;
         b.y = 2 * this._controlY - 2 * y;
         var A:Number = 4 * (a.x * a.x + a.y * a.y);
         var B:Number = 4 * (a.x * b.x + a.y * b.y);
         var C:Number = b.x * b.x + b.y * b.y;
         var ABC:Number = 2 * Math.sqrt(A + B + C);
         var A2:Number = Math.sqrt(A);
         var A32:Number = 2 * A * A2;
         var C2:Number = 2 * Math.sqrt(C);
         var BA:Number = B / A2;
         return (A32 * ABC + A2 * B * (ABC - C2) + (4 * C * A - B * B) * Math.log((2 * A2 + BA + ABC) / (BA + C2))) / (4 * A32);
      }
      
      public function setMotionSpeed(fromX:Number, fromY:Number, controlX:Number, controlY:Number, toX:Number, toY:Number, speed:Number, ease:Function = null) : void
      {
         this._distance = -1;
         x = this._fromX = fromX;
         y = this._fromY = fromY;
         this._controlX = controlX;
         this._controlY = controlY;
         this._toX = toX;
         this._toY = toY;
         _target = this.distance / speed;
         _ease = ease;
         start();
      }
      
      public function setMotion(fromX:Number, fromY:Number, controlX:Number, controlY:Number, toX:Number, toY:Number, duration:Number, ease:Function = null) : void
      {
         this._distance = -1;
         x = this._fromX = fromX;
         y = this._fromY = fromY;
         this._controlX = controlX;
         this._controlY = controlY;
         this._toX = toX;
         this._toY = toY;
         _target = duration;
         _ease = ease;
         start();
      }
   }
}
