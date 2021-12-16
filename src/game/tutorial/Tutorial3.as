package game.tutorial
{
   import game.Player;
   import net.flashpunk.Tween;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class Tutorial3 extends Tutorial
   {
       
      
      private var alarm:Alarm;
      
      private var mode:int = -3;
      
      public function Tutorial3(player:Player)
      {
         this.alarm = new Alarm(60,this.onAlarm,Tween.PERSIST);
         super(player);
         addTween(this.alarm,true);
      }
      
      private function onAlarm() : void
      {
         if(this.mode == -3)
         {
            gotoText = "Remember: UP and DOWN to";
            this.alarm.reset(60);
         }
         else if(this.mode == -2)
         {
            addText();
            gotoText = "adjust grapple length.";
            this.alarm.reset(60);
         }
         else if(this.mode == -1)
         {
            addText();
            this.alarm.reset(80);
         }
         if(this.mode == 0)
         {
            gotoText = addTypo("Am I overbearing, robot?");
            this.alarm.reset(60);
         }
         else if(this.mode == 1)
         {
            addText();
            this.alarm.reset(40);
         }
         else if(this.mode == 2)
         {
            gotoText = addTypo("Do I come across as needy?",2);
            this.alarm.reset(100);
         }
         else if(this.mode == 3)
         {
            addText();
            this.alarm.reset(160);
         }
         else if(this.mode == 4)
         {
            gotoText = addTypo("Fine, don\'t answer");
            this.alarm.reset(80);
         }
         else if(this.mode == 5)
         {
            addText();
            this.alarm.reset(20);
         }
         else if(this.mode == 6)
         {
            gotoText = addTypo("I don\'t even care anyways",2);
            this.alarm.reset(80);
         }
         else if(this.mode == 7)
         {
            addText();
         }
         if(this.mode < 7)
         {
            this.alarm.start();
         }
         this.mode++;
      }
   }
}
