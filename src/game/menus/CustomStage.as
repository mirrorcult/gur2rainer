package game.menus
{
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import game.engine.Assets;
   import net.flashpunk.FP;
   import net.flashpunk.utils.Key;
   
   public class CustomStage extends Sprite
   {
      
      public static var customStage:CustomStage;
       
      
      private var pasteTo:TextField;
      
      private var menu:MainMenu;
      
      public function CustomStage(menu:MainMenu)
      {
         super();
         this.menu = menu;
         if(customStage != null)
         {
            if(FP.stage.contains(customStage))
            {
               FP.stage.removeChild(customStage);
            }
         }
         customStage = this;
         var t:TextField = new TextField();
         t.x = 20;
         t.y = 20;
         t.width = 600;
         t.height = 20;
         t.opaqueBackground = true;
         t.backgroundColor = 0;
         t.textColor = 16777215;
         t.selectable = false;
         t.text = "Paste your custom level data below then press ENTER, or press ESC to cancel!";
         addChild(t);
         this.pasteTo = new TextField();
         this.pasteTo.x = 20;
         this.pasteTo.y = 60;
         this.pasteTo.width = 600;
         this.pasteTo.height = 400;
         this.pasteTo.opaqueBackground = true;
         this.pasteTo.backgroundColor = 0;
         this.pasteTo.textColor = 16777215;
         this.pasteTo.selectable = true;
         this.pasteTo.text = "";
         this.pasteTo.type = TextFieldType.INPUT;
         this.pasteTo.multiline = true;
         addChild(this.pasteTo);
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      private function init(e:Event) : void
      {
         FP.stage.focus = this.pasteTo;
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         addEventListener(Event.REMOVED_FROM_STAGE,this.destroy);
         addEventListener(KeyboardEvent.KEY_DOWN,this.keyDown);
      }
      
      private function keyDown(e:KeyboardEvent) : void
      {
         if(e.keyCode == Key.ESCAPE)
         {
            FP.stage.removeChild(this);
            this.menu.cancelCustomLevel();
            FP.stage.focus = FP.stage.getChildAt(0) as InteractiveObject;
         }
         else if(e.keyCode == Key.ENTER)
         {
            Assets.SndNewNormalGame.play();
            FP.stage.removeChild(this);
            this.menu.loadCustomLevel(this.pasteTo.text);
            FP.stage.focus = FP.stage.getChildAt(0) as InteractiveObject;
         }
      }
      
      private function destroy(e:Event) : void
      {
         if(customStage == this)
         {
            customStage = null;
         }
         removeEventListener(Event.REMOVED_FROM_STAGE,this.destroy);
         removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDown);
      }
   }
}
