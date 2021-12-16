package game.tutorial
{
   import flash.display.BitmapData;
   import game.Player;
   import game.cosmetic.Fuzz;
   import game.cosmetic.IntroShadow;
   import game.engine.Assets;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Text;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class Tutorial extends Entity
   {
       
      
      private const TEXT_X:int = 15;
      
      private const TEXT_Y:int = 62;
      
      protected var currentText:String = "";
      
      protected var fuzz:Fuzz;
      
      private var endChar:String = "_";
      
      protected var fuzzAlpha:Number;
      
      private const VOLUME:Number = 0.3;
      
      private const TEXT_WIDTH:int = 305;
      
      protected var list:Graphiclist;
      
      protected var player:Player;
      
      private const PROMPT:String = ">";
      
      private var texts:Vector.<Text>;
      
      protected var shadow:IntroShadow;
      
      private var data:BitmapData;
      
      private const TEXT_SEP:int = 17;
      
      protected var gotoText:String = "";
      
      private const TEXT_MAX:int = 5;
      
      private var updateTextAlarm:Alarm;
      
      private var endCharAlarm:Alarm;
      
      public function Tutorial(player:Player)
      {
         this.updateTextAlarm = new Alarm(2,this.onUpdateTextAlarm,Tween.LOOPING);
         this.endCharAlarm = new Alarm(40,this.onEndCharAlarm,Tween.LOOPING);
         super();
         this.player = player;
         Main.tutorial = this;
         layer = Main.DEPTH_TUTORIAL;
         graphic = this.list = new Graphiclist();
         this.fuzz = new Fuzz();
         this.fuzz.alpha = 0.2;
         this.fuzzAlpha = 0.2;
         this.list.add(this.fuzz);
         this.list.add(this.shadow = new IntroShadow(player));
         this.texts = new Vector.<Text>(this.TEXT_MAX);
         this.addText(false);
         addTween(this.updateTextAlarm,true);
         addTween(this.endCharAlarm,true);
      }
      
      private function updateBottomText() : void
      {
         this.texts[0].text = this.PROMPT + this.currentText + this.endChar;
      }
      
      protected function addTypo(str:String, times:int = 1) : String
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
      
      override public function update() : void
      {
         this.fuzz.alpha = FP.approach(this.fuzz.alpha,this.fuzzAlpha,0.01);
      }
      
      private function onUpdateTextAlarm() : void
      {
         if(this.currentText == this.gotoText)
         {
            return;
         }
         for(var i:int = 0; i < this.currentText.length; i++)
         {
            if(this.currentText.charAt(i) != this.gotoText.charAt(i))
            {
               this.currentText = this.currentText.substr(0,this.currentText.length - 1);
               this.updateBottomText();
               Assets.SndTutorialDelete.play(this.VOLUME);
               return;
            }
         }
         Assets.SndTutorialTalk.play(this.VOLUME);
         this.currentText = this.currentText + this.gotoText.charAt(this.currentText.length);
         this.updateBottomText();
      }
      
      protected function addText(playSound:Boolean = true) : void
      {
         if(this.texts[0])
         {
            this.texts[0].text = this.currentText;
         }
         if(this.texts[this.TEXT_MAX - 1] != null)
         {
            this.list.remove(this.texts[this.TEXT_MAX - 1]);
         }
         for(var i:int = this.TEXT_MAX - 1; i > 0; i--)
         {
            if(this.texts[i - 1] != null)
            {
               this.texts[i] = this.texts[i - 1];
               this.texts[i].y = this.texts[i].y - this.TEXT_SEP;
            }
         }
         this.texts[0] = new Text(this.PROMPT,this.TEXT_X,this.TEXT_Y,this.TEXT_WIDTH,24);
         this.texts[0].size = 16;
         this.texts[0].scrollY = 0;
         this.texts[0].scrollX = 0;
         this.list.add(this.texts[0]);
         this.currentText = "";
         this.gotoText = "";
         if(playSound)
         {
            Assets.SndTutorialEnter.play(this.VOLUME);
         }
      }
      
      private function onEndCharAlarm() : void
      {
         if(this.endChar == "")
         {
            this.endChar = "_";
         }
         else
         {
            this.endChar = "";
         }
         this.updateBottomText();
      }
   }
}
