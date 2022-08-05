package game.tutorial
{
   import game.Options;
   import game.Player;
   import game.engine.Assets;
   import game.engine.Level;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Text;
   import net.flashpunk.tweens.misc.Alarm;
   import net.flashpunk.utils.Input;
   import net.flashpunk.utils.Key;
   
   public class Tutorial1 extends Tutorial
   {
       
      
      private var alarm:Alarm;
      
      private var mode:uint = 0;
      
      private var skipText:Text;
      
      public function Tutorial1(player:Player)
      {
         this.alarm = new Alarm(120,this.onAlarm,Tween.PERSIST);
         super(player);
         fuzz.alpha = 1;
         fuzzAlpha = 1;
         addTween(this.alarm,true);
         this.skipText = new Text("Press Enter to Skip");
         this.skipText.scrollY = 0;
         this.skipText.scrollX = 0;
         this.skipText.size = 8;
         this.skipText.x = 160 - this.skipText.width / 2;
         this.skipText.y = 230 - this.skipText.height / 2;
         list.add(this.skipText);
      }
      
      private function onAlarm() : void
      {
         if(this.mode == 0)
         {
            gotoText = addTypo("Wake Up Rob",2);
            this.alarm.reset(40);
         }
         else if(this.mode == 1)
         {
            gotoText = "Wake Up Robot";
            this.alarm.reset(70);
         }
         else if(this.mode == 2)
         {
            addText();
            this.alarm.reset(20);
         }
         else if(this.mode == 3)
         {
            gotoText = "Dancing " + addTypo("has be");
            this.alarm.reset(60);
         }
         else if(this.mode == 4)
         {
            gotoText = "Testing has been interrupted";
            this.alarm.reset(130);
         }
         else if(this.mode == 5)
         {
            addText();
            this.alarm.reset(25);
         }
         else if(this.mode == 6)
         {
            gotoText = "...";
            this.alarm.reset(20);
         }
         else if(this.mode == 7)
         {
            addText();
            this.alarm.reset(20);
         }
         else if(this.mode == 8)
         {
            gotoText = addTypo("Running diagnostic procedures");
            this.alarm.reset(80);
         }
         else if(this.mode == 9)
         {
            gotoText = gotoText + ".";
            this.alarm.reset(30);
         }
         else if(this.mode == 10)
         {
            gotoText = gotoText + ".";
            this.alarm.reset(20);
         }
         else if(this.mode == 11)
         {
            gotoText = gotoText + ".";
            this.alarm.reset(30);
         }
         else if(this.mode == 12)
         {
            addText();
            this.alarm.reset(20);
         }
         else if(this.mode == 13)
         {
            gotoText = "...";
            this.alarm.reset(30);
         }
         else if(this.mode == 14)
         {
            addText();
            this.alarm.reset(10);
         }
         else if(this.mode == 15)
         {
            gotoText = "...";
            this.alarm.reset(40);
         }
         else if(this.mode == 16)
         {
            addText();
            this.alarm.reset(15);
         }
         else if(this.mode == 17)
         {
            gotoText = "A pow" + addTypo("er circuit is broken");
            this.alarm.reset(90);
         }
         else if(this.mode == 18)
         {
            addText();
            this.alarm.reset(20);
         }
         else if(this.mode == 19)
         {
            gotoText = addTypo("Robot, you must investigate");
            this.alarm.reset(100);
         }
         else if(this.mode == 20)
         {
            addText();
            this.alarm.reset(20);
         }
         else if(this.mode == 21)
         {
            gotoText = "...";
            this.alarm.reset(30);
         }
         else if(this.mode == 22)
         {
            addText();
            this.alarm.reset(10);
         }
         else if(this.mode == 23)
         {
            gotoText = "...";
            this.alarm.reset(25);
         }
         else if(this.mode == 24)
         {
            addText();
            this.alarm.reset(20);
            if(this.skipText)
            {
               list.remove(this.skipText);
               this.skipText = null;
            }
            (FP.world as Level).countTime = true;
         }
         else if(this.mode == 25)
         {
            gotoText = "Use the arrow keys to move";
            this.alarm.reset(60);
            (FP.world as Level).spawn();
            fuzzAlpha = 0.2;
         }
         else if(this.mode == 26)
         {
            addText();
            this.alarm.reset(30);
         }
         else if(this.mode == 27)
         {
            if(Options.upToJump)
            {
               gotoText = addTypo("And press") + " X or S or UP to jump";
               this.alarm.reset(70);
            }
            else
            {
               gotoText = addTypo("And press") + " X or S to jump";
               this.alarm.reset(60);
            }
         }
         else if(this.mode == 28)
         {
            addText();
         }
         else if(this.mode == 30)
         {
            addText();
            gotoText = "or tap for a low hop";
         }
         else if(this.mode == 32)
         {
            addText();
         }
         else if(this.mode == 34)
         {
            addText();
            gotoText = "then UP and DOWN to adjust";
            this.alarm.reset(110);
            this.alarm.start();
         }
         else if(this.mode == 35 || this.mode == 37 || this.mode == 39)
         {
            addText();
         }
         if(this.mode < 28)
         {
            this.alarm.start();
         }
         this.mode++;
      }
      
      override public function update() : void
      {
         super.update();
         if(this.mode < 24 && Input.pressed(Key.ENTER))
         {
            Assets.instance.SndMenuSelect.play();
            this.mode = 24;
            this.alarm.reset(1);
            this.alarm.start();
         }
         if(this.mode == 29 && player.x >= 240)
         {
            this.mode = 30;
            gotoText = "Hold the button to jump high";
            this.alarm.reset(60);
            this.alarm.start();
         }
         else if(this.mode == 31 && player.x >= 480 && currentText == gotoText)
         {
            this.mode = 32;
            addText();
            gotoText = "Coins add " + addTypo("to your") + " score";
            this.alarm.reset(55);
            this.alarm.start();
         }
         else if(this.mode == 33 && player.x >= 760)
         {
            this.mode = 34;
            gotoText = addTypo("Now press") + " Z or A to grapple";
            this.alarm.reset(60);
            this.alarm.start();
         }
         else if(this.mode == 36 && player.x >= 1000)
         {
            this.mode = 37;
            gotoText = addTypo("Excellent work, robot!");
            this.alarm.reset(55);
            this.alarm.start();
         }
         else if(this.mode == 38 && player.x <= 32)
         {
            this.mode = 39;
            gotoText = addTypo("...where are you going?",2);
            this.alarm.reset(70);
            this.alarm.start();
         }
      }
   }
}
