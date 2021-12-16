package game.tutorial
{
   import game.Player;
   import game.engine.Level;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class TutorialHard extends Tutorial
   {
       
      
      private var alarm:Alarm;
      
      private var mode:uint = 0;
      
      public function TutorialHard(player:Player)
      {
         this.alarm = new Alarm(120,this.onAlarm,Tween.PERSIST);
         super(player);
         fuzz.alpha = 1;
         fuzzAlpha = 1;
         list.remove(shadow);
         addTween(this.alarm,true);
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
            gotoText = "You\'re in space for some reason";
            this.alarm.reset(130);
         }
         else if(this.mode == 4)
         {
            addText();
            this.alarm.reset(25);
         }
         else if(this.mode == 5)
         {
            gotoText = "...";
            this.alarm.reset(20);
         }
         else if(this.mode == 6)
         {
            addText();
            this.alarm.reset(20);
            (FP.world as Level).spawn();
            fuzzAlpha = 0;
         }
         if(this.mode < 6)
         {
            this.alarm.start();
         }
         this.mode++;
      }
   }
}
