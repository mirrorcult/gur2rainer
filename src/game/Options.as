package game
{
   import flash.net.SharedObject;
   import net.flashpunk.FP;
   import net.flashpunk.utils.Input;
   import net.flashpunk.utils.Key;

   public class Options
   {
      // tas recording state enum
      public static const tasRecordingStateNone:int    = 0;
      public static const tasRecordingStateManual:int  = 1;
      public static const tasRecordingStateAll:int      = 2;
      public static const tasRecordingStateFastest:int = 3;
      // end enum

      public static var voices:Boolean;
      
      private static var _upToJump:Boolean;
      
      public static var showCoins:Boolean;
      
      public static var showTime:Boolean;
      
      public static var particles:Boolean;

      public static var fullscreen:Boolean;

      public static var tasRecordingState:int;

      public static var tasAutomaticPlayback:Boolean;
      
      public function Options()
      {
         super();
      }
      
      public static function get upToJump() : Boolean
      {
         return _upToJump;
      }
      
      public static function set upToJump(to:Boolean) : void
      {
         _upToJump = to;
         if(to)
         {
            Input.define("jump",Key.S,Key.X,Key.UP);
         }
         else
         {
            Input.define("jump",Key.S,Key.X);
         }
      }
      
      public static function saveOptions() : void
      {
         var obj:SharedObject = SharedObject.getLocal("data");
         obj.data.options = new Object();
         obj.data.options.showCoins = showCoins;
         obj.data.options.showTime = showTime;
         obj.data.options.upToJump = upToJump;
         obj.data.options.volume = FP.volume;
         obj.data.options.voices = voices;
         obj.data.options.particles = particles;
         obj.data.options.fullscreen = fullscreen;
         obj.data.options.tasRecordingState = tasRecordingState;
         obj.data.options.tasAutomaticPlayback = tasAutomaticPlayback;
      }
      
      public static function loadOptions() : void
      {
         var obj:SharedObject = SharedObject.getLocal("data");
         if(obj.data.options == null)
         {
            showCoins = true;
            showTime = false;
            upToJump = true;
            FP.volume = 1;
            voices = true;
            particles = true;
            fullscreen = false;
            tasRecordingState = tasRecordingStateFastest;
            tasAutomaticPlayback = false;
         }
         else
         {
            showCoins = obj.data.options.showCoins;
            showTime = obj.data.options.showTime;
            upToJump = obj.data.options.upToJump;
            FP.volume = obj.data.options.volume;
            voices = obj.data.options.voices;
            particles = obj.data.options.particles;
            fullscreen = obj.data.options.fullscreen;
            tasRecordingState = obj.data.options.tasRecordingState;
            tasAutomaticPlayback = obj.data.options.tasAutomaticPlayback;
         }
      }
   }
}
