package net.flashpunk.tweens.motion
{
   import net.flashpunk.Tween;
   
   public class Motion extends Tween
   {
       
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public function Motion(duration:Number, complete:Function = null, type:uint = 0, ease:Function = null)
      {
         super(duration,type,complete,ease);
      }
   }
}
