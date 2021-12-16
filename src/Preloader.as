package
{
   import com.adultswim.Preroll.GlobalVarContainer;
   import com.adultswim.Preroll.Preroller;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.utils.getDefinitionByName;
   import prerollAssets._mcPlay;
   
   public class Preloader extends MovieClip
   {
      
      private static const ImgMMG:Class = Preloader_ImgMMG;
      
      public static var preloader:Preloader;
      
      private static const ImgBG:Class = Preloader_ImgBG;
      
      private static const ImgLoader:Class = Preloader_ImgLoader;
      
      private static const ImgScreen:Class = Preloader_ImgScreen;
       
      
      private var done:Boolean = false;
      
      private var pplay:_mcPlay;
      
      private var Preroller:Preroller;
      
      private var oStage:Object;
      
      private var oRoot:Object;
      
      private var re:RegExp;
      
      private var bar:Sprite;
      
      private var gameName:String = "giveuprobot2";
      
      public function Preloader()
      {
         this.pplay = new _mcPlay();
         this.re = /http://i.cdn.turner.com/adultswim/games2/tools/swf/preroll-asg-syndicated(-\w+)?-(\d+)x(\d+).flv/i;
         super();
         preloader = this;
         switch(stage)
         {
            case null:
               this.oStage = GlobalVarContainer.vars.stage;
               trace("@@@@stage is null. Now set to object: ",this.oStage);
               break;
            default:
               this.oStage = stage;
               GlobalVarContainer.vars.stage = this.oStage;
               trace("@@@@stage is available!");
         }
         switch(root)
         {
            case null:
               this.oRoot = GlobalVarContainer.vars.root;
               trace("####root is null. Now set to object: ",this.oRoot);
               break;
            default:
               this.oRoot = root;
               GlobalVarContainer.vars.root = this.oRoot;
               trace("####root is available!");
         }
         if(this.oStage)
         {
            this.init();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.init);
         }
         addEventListener(Event.ENTER_FRAME,this.checkFrame);
         loaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progress);
         var b:Bitmap = new ImgBG();
         b.scaleX = b.scaleY = 2;
         addChild(b);
         b = new ImgLoader();
         b.x = (640 - b.bitmapData.width) / 2;
         b.y = 60;
         addChild(b);
         b = new ImgMMG();
         b.x = (640 - b.bitmapData.width) / 2;
         b.y = 420;
         addChild(b);
         this.bar = new Sprite();
         addChild(this.bar);
         this.bar.graphics.beginFill(0);
         this.bar.graphics.drawRect(78,258,484,24);
         this.bar.graphics.endFill();
         b = new ImgScreen();
         b.scaleX = b.scaleY = 2;
         addChild(b);
      }
      
      private function checkFrame(e:Event) : void
      {
         if(currentFrame == totalFrames)
         {
            removeEventListener(Event.ENTER_FRAME,this.checkFrame);
            this.startup();
         }
      }
      
      public function startup() : void
      {
         if(!this.done)
         {
            this.done = true;
            return;
         }
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         stop();
         loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progress);
         var mainClass:Class = getDefinitionByName("Main") as Class;
         addChild(new mainClass() as DisplayObject);
      }
      
      private function init(e:Event = null) : void
      {
         trace("INIT0");
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         GlobalVarContainer.vars.gameName = this.gameName;
         GlobalVarContainer.vars.flvPath = "http://i.cdn.turner.com/adultswim/games2/tools/swf/preroll-asg-syndicated-noplay-728x500.flv";
         GlobalVarContainer.vars.flvWidth = parseInt(GlobalVarContainer.vars.flvPath.replace(this.re,"$2"));
         GlobalVarContainer.vars.flvHeight = parseInt(GlobalVarContainer.vars.flvPath.replace(this.re,"$3"));
         trace(GlobalVarContainer.vars.flvPath.replace(this.re,"$0"),GlobalVarContainer.vars.flvPath.replace(this.re,"$1"),GlobalVarContainer.vars.flvPath.replace(this.re,"$2"),GlobalVarContainer.vars.flvPath.replace(this.re,"$3"));
         GlobalVarContainer.vars.stageWidth = this.oStage.stageWidth;
         GlobalVarContainer.vars.stageHeight = this.oStage.stageHeight;
         GlobalVarContainer.vars.mcPlay = this.pplay;
         this.Preroller = new Preroller();
      }
      
      private function progress(e:ProgressEvent) : void
      {
         this.bar.graphics.clear();
         this.bar.graphics.beginFill(0);
         this.bar.graphics.drawRect(78,258,484,24);
         this.bar.graphics.endFill();
         this.bar.graphics.beginFill(16757849);
         this.bar.graphics.drawRect(80,260,e.bytesLoaded / e.bytesTotal * 480,20);
         this.bar.graphics.endFill();
      }
   }
}
