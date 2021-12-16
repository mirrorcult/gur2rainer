package net.flashpunk
{
   import flash.display.MovieClip;
   import flash.display.StageAlign;
   import flash.display.StageDisplayState;
   import flash.display.StageQuality;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import net.flashpunk.utils.Draw;
   import net.flashpunk.utils.Input;
   
   public class Engine extends MovieClip
   {
       
      
      private var _gameTime:uint;
      
      private var _timer:Timer;
      
      private var _frameListSum:uint = 0;
      
      private var _prev:Number;
      
      private var _updateTime:uint;
      
      private const TICK_RATE:uint = 4;
      
      private var _skip:Number;
      
      private const MAX_FRAMESKIP:Number = 5;
      
      private const MAX_ELAPSED:Number = 0.0333;
      
      private var _renderTime:uint;
      
      private var _flashTime:uint;
      
      private var _frameLast:uint = 0;
      
      private var _time:Number;
      
      public var paused:Boolean = false;
      
      private var _last:Number;
      
      private var _delta:Number = 0;
      
      private var _frameList:Vector.<uint>;
      
      private var _rate:Number;
      
      public function Engine(width:uint, height:uint, frameRate:Number = 60, fixed:Boolean = false)
      {
         this._frameList = new Vector.<uint>();
         super();
         FP.width = width;
         FP.height = height;
         FP.assignedFrameRate = frameRate;
         FP.fixed = fixed;
         FP.engine = this;
         FP.screen = new Screen();
         FP.bounds = new Rectangle(0,0,width,height);
         FP._world = new World();
         if(FP.randomSeed == 0)
         {
            FP.randomizeSeed();
         }
         FP.entity = new Entity();
         FP._time = getTimer();
         addEventListener(Event.ADDED_TO_STAGE,this.onStage);
      }
      
      public function update() : void
      {
         var t:Number = getTimer();
         if(!this._frameLast)
         {
            this._frameLast = t;
         }
         if(FP._world.active)
         {
            if(FP._world._tween)
            {
               FP._world.updateTweens();
            }
            FP._world.update();
         }
         FP._world.updateLists();
         if(FP._goto)
         {
            this.checkWorld();
         }
         t = getTimer();
         this._frameListSum = this._frameListSum + (this._frameList[this._frameList.length] = t - this._frameLast);
         if(this._frameList.length > 10)
         {
            this._frameListSum = this._frameListSum - this._frameList.shift();
         }
         FP.frameRate = 1000 / (this._frameListSum / this._frameList.length);
         this._frameLast = t;
      }
      
      public function setStageProperties() : void
      {
         stage.frameRate = FP.assignedFrameRate;
         stage.align = StageAlign.TOP_LEFT;
         stage.quality = StageQuality.HIGH;
         stage.scaleMode = StageScaleMode.SHOW_ALL;
         stage.displayState = StageDisplayState.NORMAL;
      }
      
      public function init() : void
      {
      }
      
      public function render() : void
      {
         FP.screen.swap();
         Draw.resetTarget();
         FP.screen.refresh();
         if(FP._world.visible)
         {
            FP._world.render();
         }
         FP.screen.redraw();
      }
      
      private function onStage(e:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onStage);
         FP.stage = stage;
         this.setStageProperties();
         Input.enable();
         if(FP._goto)
         {
            this.checkWorld();
         }
         this.init();
         this._rate = 1000 / FP.assignedFrameRate;
         if(FP.fixed)
         {
            this._skip = this._rate * this.MAX_FRAMESKIP;
            this._last = this._prev = getTimer();
            this._timer = new Timer(this.TICK_RATE);
            this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
            this._timer.start();
         }
         else
         {
            this._last = getTimer();
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onTimer(e:TimerEvent) : void
      {
         this._time = getTimer();
         this._delta = this._delta + (this._time - this._last);
         this._last = this._time;
         if(this._delta < this._rate)
         {
            return;
         }
         this._gameTime = this._time;
         FP._flashTime = this._time - this._flashTime;
         if(FP._console)
         {
            FP._console.update();
         }
         if(this._delta > this._skip)
         {
            this._delta = this._skip;
         }
         while(this._delta > this._rate)
         {
            this._updateTime = this._time;
            this._delta = this._delta - this._rate;
            FP.elapsed = (this._time - this._prev) / 1000;
            if(FP.elapsed > this.MAX_ELAPSED)
            {
               FP.elapsed = this.MAX_ELAPSED;
            }
            FP.elapsed = FP.elapsed * FP.rate;
            this._prev = this._time;
            if(!this.paused)
            {
               this.update();
            }
            Input.update();
            this._time = getTimer();
            FP._updateTime = this._time - this._updateTime;
         }
         this._renderTime = this._time;
         if(!this.paused)
         {
            this.render();
         }
         this._time = this._flashTime = getTimer();
         FP._renderTime = this._time - this._renderTime;
         FP._gameTime = this._time - this._gameTime;
      }
      
      private function checkWorld() : void
      {
         if(!FP._goto)
         {
            return;
         }
         FP._world.end();
         if(FP._world && FP._world.autoClear && FP._world._tween)
         {
            FP._world.clearTweens();
         }
         FP._world = FP._goto;
         FP._goto = null;
         FP._world.updateLists();
         FP._world.begin();
         FP._world.updateLists();
      }
      
      private function onEnterFrame(e:Event) : void
      {
         this._time = this._gameTime = getTimer();
         FP._flashTime = this._time - this._flashTime;
         this._updateTime = this._time;
         FP.elapsed = (this._time - this._last) / 1000;
         if(FP.elapsed > this.MAX_ELAPSED)
         {
            FP.elapsed = this.MAX_ELAPSED;
         }
         FP.elapsed = FP.elapsed * FP.rate;
         this._last = this._time;
         if(FP._console)
         {
            FP._console.update();
         }
         if(!this.paused)
         {
            this.update();
         }
         Input.update();
         this._time = this._renderTime = getTimer();
         FP._updateTime = this._time - this._updateTime;
         if(!this.paused)
         {
            this.render();
         }
         this._time = this._flashTime = getTimer();
         FP._renderTime = this._time - this._renderTime;
         FP._gameTime = this._time - this._gameTime;
      }
   }
}
