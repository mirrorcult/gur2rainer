package game.tutorial
{
   import game.Player;
   import net.flashpunk.Tween;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class Tutorial2 extends Tutorial
   {
       
      
      private var alarm:Alarm;
      
      private var mode:uint = 0;
      
      public function Tutorial2(player:Player)
      {
         this.alarm = new Alarm(60,this.onAlarm,Tween.PERSIST);
         super(player);
         addTween(this.alarm,true);
      }
      
      private function onAlarm() : void
      {
         if(this.mode == 0)
         {
            gotoText = addTypo("You\'ll have to cross this gap",1);
            this.alarm.reset(66);
         }
         else if(this.mode == 1)
         {
            addText();
            gotoText = "The coin block " + addTypo("would love to help");
            this.alarm.reset(80);
         }
         else if(this.mode == 2)
         {
            addText();
            this.alarm.reset(4);
         }
         else if(this.mode == 3)
         {
            gotoText = "Remember UP and DOWN while";
            this.alarm.reset(60);
         }
         else if(this.mode == 4)
         {
            addText();
            gotoText = "grappled to adjust length!";
            this.alarm.reset(60);
         }
         else if(this.mode == 5 || this.mode == 7)
         {
            addText();
         }
         if(this.mode < 5)
         {
            this.alarm.start();
         }
         this.mode++;
      }
      
      override public function update() : void
      {
         super.update();
         if(this.mode >= 3 && this.mode < 7 && player.x >= 248)
         {
            this.mode = 7;
            gotoText = addTypo("Fantastic!!",2);
            this.alarm.reset(120);
            this.alarm.start();
         }
      }
   }
}
