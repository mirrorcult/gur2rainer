package game.engine
{
   import flash.geom.Point;
   import game.Grapple;
   import net.flashpunk.Entity;
   
   public class Grabbable extends Entity
   {
       
      
      public var grapplePoint:Point;
      
      public var force:Boolean = false;
      
      public var forceSpin:Number;
      
      public var grapple:Grapple;
      
      public function Grabbable(x:int, y:int)
      {
         super(x,y);
      }
      
      public function onGrapple() : void
      {
      }
      
      public function onRelease() : void
      {
      }
   }
}
