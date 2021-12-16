package net.flashpunk.graphics
{
   public class Anim
   {
       
      
      var _frameCount:uint;
      
      var _loop:Boolean;
      
      var _frames:Array;
      
      var _parent:Spritemap;
      
      var _name:String;
      
      var _frameRate:Number;
      
      public function Anim(name:String, frames:Array, frameRate:Number = 0, loop:Boolean = true)
      {
         super();
         this._name = name;
         this._frames = frames;
         this._frameRate = frameRate;
         this._loop = loop;
         this._frameCount = frames.length;
      }
      
      public function get frameCount() : uint
      {
         return this._frameCount;
      }
      
      public function get loop() : Boolean
      {
         return this._loop;
      }
      
      public function get frames() : Array
      {
         return this._frames;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get frameRate() : Number
      {
         return this._frameRate;
      }
      
      public function play(reset:Boolean = false) : void
      {
         this._parent.play(this._name,reset);
      }
   }
}
