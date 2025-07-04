package
{
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import game.Options;
   import game.cosmetic.Pauser;
   import game.engine.*;
   import game.engine.Assets;
   import game.engine.EndLevel;
   import game.engine.Level;
   import game.engine.MattWorld;
   import game.engine.SaveData;
   import game.engine.StartLevel;
   import game.engine.Stats;
   import game.menus.MainMenu;
   import game.menus.WinMenu;
   import game.particles.ParticleSystem;
   import game.tutorial.Tutorial;
   import flash.text.TextField;
	import flash.text.TextFormat;
   import flash.display.StageDisplayState;
   import net.flashpunk.Engine;
   import net.flashpunk.FP;
   import net.flashpunk.utils.Input;
   import net.flashpunk.utils.Key;
   import flash.display.MovieClip;
   
   public class Main extends Engine
   {
      
      public static const DEPTH_TUTORIAL:int = -800;
      
      private static const NORMAL_ID:String = "3472";
      
      public static const DEPTH_ITEMS:int = -3;
      
      private static var shake:uint = 0;
      
      private static const HARD_ID:String = "3492";
      
      public static const DEPTH_GRAPPLE:int = -6;
      
      public static const DEPTH_PLAYER:int = 0;
      
      public static const DEPTH_LINK:int = -10000;
            
      public static var particles:ParticleSystem;
      
      public static const DEPTH_BGEFFECT:int = 100;
      
      public static const VERSION:String = "v1.02s";
      
      public static const DEPTH_ACTORS:int = -4;
      
      public static const DEPTH_HUD:int = -900;
      
      public static var saveData:SaveData;
      
      public static const DEPTH_TILES:int = -1;
      
      private static var BDScreen:BitmapData;
                  
      public static var tutorial:Tutorial;
      
      public static const DEPTH_BG:int = 1000;
      
      private static var noiseAlpha:Number = 0;
      
      public static const DEPTH_FUZZ:int = -1000;
      
      private static const ImgScreen:Class = Main_ImgScreen;
      
      public static const DEPTH_PARTICLES:int = -2;
      
      public static const DEPTH_ENVIRON:int = -5;
      
      public static var pause:Pauser;
      
      public static const DEPTH_SPEECH:int = -7;

      public static var MC_MEMORY_WATCH:MovieClip;
      
      private var focus:Boolean = true;

      public static var instance:Main;
      
      public function Main()
      {
         super(320,240,60,true);
         FP.screen.scale = 2;
         FP.screen.color = 0;
         Input.define("right",Key.RIGHT);
         Input.define("left",Key.LEFT);
         Input.define("up",Key.UP);
         Input.define("down",Key.DOWN);
         Input.define("shoot",Key.A,Key.Z);
         Input.define("return", Key.ESCAPE);
         Input.define("back", Key.BACKSPACE);
         Input.define("next", Key.TAB);
         Input.define("restart", Key.R);
         Input.define("debug", Key.Q);
   
         instance = this;
         BDScreen = new ImgScreen().bitmapData;
         new Assets();
         Assets.voice = Assets.VcPowerOn;
         Options.loadOptions();
         Stats.initStats();
         particles = new ParticleSystem(Assets_ImgParticles,6,6);
         particles.y = -3;
         particles.x = -3;

         FP.console.enable();
         FP.console.visible = false;

         // player vars
         FP.console.watch("hSpeed", "vSpeed", "momentum", "radius", "canGrapple", "timeLeft", "coinsLeft", "endY", "startY", "counter", "thrust", "health");

         MC_MEMORY_WATCH = new MovieClip();
			MC_MEMORY_WATCH.MC_LIST = new MovieClip();
			MC_MEMORY_WATCH.MC_MASK = new MovieClip();
			MC_MEMORY_WATCH.TEXT_FIELD = new TextField();
			MC_MEMORY_WATCH.TEXT_FORMAT = new TextFormat("default",12,16777215,null,null,null,null,null,"left",null,null,null,null);
			MC_MEMORY_WATCH.TEXT_FIELD.autoSize = "left";
			MC_MEMORY_WATCH.TEXT_FIELD.embedFonts = true;
			MC_MEMORY_WATCH.TEXT_FIELD.selectable = false;
			MC_MEMORY_WATCH.TEXT_FIELD.text = "Memory Watch";
			MC_MEMORY_WATCH.TEXT_FIELD.textColor = 16777215;
			MC_MEMORY_WATCH.TEXT_FIELD.setTextFormat(MC_MEMORY_WATCH.TEXT_FORMAT);
			MC_MEMORY_WATCH.visible = false;
			MC_MEMORY_WATCH.MC_LIST.mask = MC_MEMORY_WATCH.MC_MASK;
			MC_MEMORY_WATCH.MC_LIST.TEXT_FIELD = new TextField();
			MC_MEMORY_WATCH.MC_LIST.TEXT_FORMAT = new TextFormat("default",12,16777215,null,null,null,null,null,"left",null,null,null,null);
			MC_MEMORY_WATCH.MC_LIST.TEXT_FIELD.autoSize = "left";
			MC_MEMORY_WATCH.MC_LIST.TEXT_FIELD.embedFonts = true;
			MC_MEMORY_WATCH.MC_LIST.TEXT_FIELD.selectable = false;
			MC_MEMORY_WATCH.MC_LIST.TEXT_FIELD.x = 0;
			MC_MEMORY_WATCH.MC_LIST.TEXT_FIELD.y = MC_MEMORY_WATCH.TEXT_FIELD.height;
			MC_MEMORY_WATCH.graphics.beginFill(0,0.75);
			MC_MEMORY_WATCH.graphics.drawRect(0,0,480 * 0.5,640 * 0.22 * 0.75);
			MC_MEMORY_WATCH.graphics.endFill();
			MC_MEMORY_WATCH.x = 640 - MC_MEMORY_WATCH.width;
			MC_MEMORY_WATCH.y = 0;
			MC_MEMORY_WATCH.MC_MASK.graphics.beginFill(0,0);
			MC_MEMORY_WATCH.MC_MASK.graphics.drawRect(0,0,480 * 0.5,640 * 0.22 * 0.75);
			MC_MEMORY_WATCH.MC_MASK.graphics.endFill();
			MC_MEMORY_WATCH.addChild(MC_MEMORY_WATCH.MC_LIST);
			MC_MEMORY_WATCH.addChild(MC_MEMORY_WATCH.MC_MASK);
			MC_MEMORY_WATCH.addChild(MC_MEMORY_WATCH.TEXT_FIELD);
			MC_MEMORY_WATCH.MC_LIST.addChild(MC_MEMORY_WATCH.MC_LIST.TEXT_FIELD);
			stage.addChild(MC_MEMORY_WATCH);
      }
      
      public static function submitFacebook() : void
      {
      }
      
      public static function screenShake(amount:uint) : void
      {
         if(amount == 0)
         {
            shake = 6;
         }
         else if(amount == 1)
         {
            shake = 18;
         }
         else if(amount == 2)
         {
            shake = 36;
         }
      }
      
      public static function saveGame() : void
      {
         var obj:SharedObject = SharedObject.getLocal("data");
         obj.data.saveData = saveData;
      }
      
      private static function getFacebookText() : String
      {
         if(Main.saveData.mode == 0)
         {
            return "I scored " + Main.saveData.getScoreString() + " in Give Up Robot 2 on AdultSwim.com and hope this will inspire other robots to keep their chins up.";
         }
         return "I scored " + Main.saveData.getScoreString() + " in Give Up Robot 2 HARD MODE on AdultSwim.com and hope this will inspire other robots to keep their chins up.";
      }

      public static function Console(param1:String) : void
      {
         MC_MEMORY_WATCH.MC_LIST.TEXT_FIELD.text = param1;
         MC_MEMORY_WATCH.MC_LIST.TEXT_FIELD.textColor = 16777215;
         MC_MEMORY_WATCH.MC_LIST.TEXT_FIELD.setTextFormat(MC_MEMORY_WATCH.MC_LIST.TEXT_FORMAT);
      }
      
      public static function saveIsNormalMode() : Boolean
      {
         var obj:SharedObject = null;
         if(!saveExists())
         {
            return true;
         }
         obj = SharedObject.getLocal("data");
         return obj.data.saveData.mode == 0;
      }
      
      public static function getLevel(loading:Boolean = false) : MattWorld
      {
         if(Main.saveData.startLevel)
         {
            return new StartLevel(Main.saveData.level);
         }
         if(Main.saveData.keyLevel)
         {
            return new EndLevel(Main.saveData.level);
         }
         if(Main.saveData.mode == 1 && Main.saveData.level == Assets.LEVELS[1])
         {
            if(Main.saveData.deaths == 0 || loading)
            {
               return new Level(1,Assets.LEVELS[1]);
            }
            return new WinMenu();
         }
         if(Main.saveData.level > Assets.LEVELS[Main.saveData.mode])
         {
            return new WinMenu();
         }
         return new Level(Main.saveData.mode,Main.saveData.level);
      }
      
      public static function convertScoreString(score:int) : String
      {
         var str:String = null;
         if(score >= 1000000)
         {
            str = String(Math.floor(score / 1000000)) + "," + convertHundreds(Math.floor(score % 1000000 / 1000)) + "," + convertHundreds(score % 1000);
         }
         else if(score >= 1000)
         {
            str = String(Math.floor(score / 1000)) + "," + convertHundreds(score % 1000);
         }
         else
         {
            str = String(score);
         }
         return str;
      }
      
      public static function checkDomain(domain:String) : Boolean
      {
         var url:String = FP.stage.loaderInfo.url;
         var startCheck:int = url.indexOf("://") + 3;
         var domainLen:int = url.indexOf("/",startCheck) - startCheck;
         var d:String = url.substr(startCheck,domainLen);
         var splits:Array = d.split(".");
         d = splits[splits.length - 2] + "." + splits[splits.length - 1];
         if(d == domain)
         {
            return true;
         }
         return false;
      }
      
      private static function getMessageText() : String
      {
         if(Main.saveData.mode == 0)
         {
            return "I played Give Up Robot 2 and scored " + Main.saveData.getScoreString() + ". I am now soaking in a bathtub filled with accomplishment. http://j.mp/aTBixk";
         }
         return "I played Give Up Robot 2 HARD MODE and scored " + Main.saveData.getScoreString() + ". I am now soaking in a bathtub filled with accomplishment. http://j.mp/aTBixk";
      }
      
      public static function beatenNormal() : Boolean
      {
         return getBeatenObj().normal;
      }
      
      public static function saveExists() : Boolean
      {
         var obj:SharedObject = SharedObject.getLocal("data");
         return obj.data.saveData != null;
      }
      
      public static function beatNormal() : void
      {
         getBeatenObj().normal = true;
      }
      
      public static function addTypo(str:String, times:int = 1) : String
      {
         var num:int = 0;
         var char:String = null;
         for(var i:int = 0; i < times; i++)
         {
            do
            {
               num = Math.random() * str.length;
            }
            while(str.charAt(num) == " ");
            
            char = String.fromCharCode(21 + Math.random() * 104);
            str = str.substr(0,num) + char + str.substr(num + 1);
         }
         return str;
      }
      
      public static function rotateToward(currDir:Number, wantDir:Number, maxTurn:Number) : Number
      {
         if(wantDir >= currDir + 180)
         {
            currDir = currDir + 360;
         }
         else if(wantDir < currDir - 180)
         {
            wantDir = wantDir + 360;
         }
         var diff:Number = wantDir - currDir;
         if(diff < -maxTurn)
         {
            diff = -maxTurn;
         }
         if(diff > maxTurn)
         {
            diff = maxTurn;
         }
         return diff;
      }
      
      public static function getSaveCoins() : String
      {
         var obj:SharedObject = null;
         if(!saveExists())
         {
            return "";
         }
         obj = SharedObject.getLocal("data");
         if(obj.data.saveData.coins == 1)
         {
            return "1 Coin";
         }
         return obj.data.saveData.coins + " Coins";
      }
      
      public static function beatHard() : void
      {
         getBeatenObj().hard = true;
      }
      
      public static function getSaveLevel() : String
      {
         var obj:SharedObject = null;
         if(!saveExists())
         {
            return "";
         }
         obj = SharedObject.getLocal("data");
         if(obj.data.saveData.keyLevel)
         {
            return "Key Room " + Math.floor(obj.data.saveData.level / 20);
         }
         if(obj.data.saveData.startLevel)
         {
            return "Starting World " + Math.ceil(obj.data.saveData.level / 20);
         }
         if(obj.data.saveData.level == 61)
         {
            return "Final Chase";
         }
         return "Level " + obj.data.saveData.level;
      }
      
      public static function getSaveDeaths() : String
      {
         var obj:SharedObject = null;
         if(!saveExists())
         {
            return "";
         }
         obj = SharedObject.getLocal("data");
         if(obj.data.saveData.deaths == 1)
         {
            return "1 Death";
         }
         return obj.data.saveData.deaths + " Deaths";
      }
      
      public static function submitTwitter() : void
      {
         var url:URLRequest = new URLRequest("http://twitter.com/?status=" + getMessageText());
         navigateToURL(url);
      }
      
      public static function formatTime(time:int) : String
      {
         var sec:Number = time % (60 * 60);
         sec = sec / 60;
         var str:String = sec.toFixed(2);
         if(sec < 10)
         {
            str = "0" + str;
         }
         str = ":" + str;
         var blah:uint = Math.floor(time / (60 * 60));
         str = String(blah) + str;
         return str;
      }
      
      private static function convertHundreds(amount:int) : String
      {
         if(amount < 10)
         {
            return "00" + amount;
         }
         if(amount < 100)
         {
            return "0" + amount;
         }
         return String(amount);
      }
      
      public static function clearGame() : void
      {
         var obj:SharedObject = SharedObject.getLocal("data");
         obj.data.saveData = null;
      }
      
      public static function getSaveTime() : String
      {
         var obj:SharedObject = null;
         if(!saveExists())
         {
            return "";
         }
         obj = SharedObject.getLocal("data");
         return formatTime(obj.data.saveData.time);
      }
      
      public static function clearEverything() : void
      {
         var obj:SharedObject = SharedObject.getLocal("data");
         obj.data.saveData = null;
         obj.data.beaten = null;
         obj.data.options = null;
         obj.data.stats = null;
         obj.flush();
         Options.loadOptions();
         Stats.initStats();
      }
      
      private static function getBeatenObj() : Object
      {
         var obj:SharedObject = SharedObject.getLocal("data");
         if(obj.data.beaten == null)
         {
            obj.data.beaten = new Object();
            obj.data.beaten.hard = false;
            obj.data.beaten.normal = false;
         }
         return obj.data.beaten;
      }
      
      public static function beatenHard() : Boolean
      {
         return getBeatenObj().hard;
      }
      
      public static function loadGame() : void
      {
         var obj:SharedObject = SharedObject.getLocal("data");
         saveData = new SaveData(obj.data.saveData);
      }
      
      override public function init() : void
      {
         stage.addEventListener(Event.DEACTIVATE,this.loseFocus);
         stage.addEventListener(Event.ACTIVATE,this.gainFocus);
         FP.world = new MainMenu();
      }
      
      override public function update() : void
      {
         if(!this.focus)
         {
            return;
         }
         if(pause != null)
         {
            pause.update();
         }
         super.update();
      }
      
      override public function render() : void
      {
         super.render();
         FP.buffer.draw(BDScreen);
         if(shake > 0)
         {
            shake--;
            FP.buffer.scroll(-3 + Math.random() * 6,-3 + Math.random() * 6);
         }
      }
      
      private function gainFocus(e:Event) : void
      {
         this.focus = true;
      }
      
      private function loseFocus(e:Event) : void
      {
         this.focus = false;
      }
   }
}
