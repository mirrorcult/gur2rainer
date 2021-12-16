package game.tutorial
{
   import game.Player;
   import net.flashpunk.Tween;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class Tutorial4 extends Tutorial
   {
       
      
      private var alarm:Alarm;
      
      private var mode:uint = 0;
      
      public function Tutorial4(player:Player)
      {
         this.alarm = new Alarm(60,this.onAlarm,Tween.PERSIST);
         super(player);
         addTween(this.alarm,true);
      }
      
      private function onAlarm() : void
      {
         if(this.mode == 0)
         {
            gotoText = addTypo("You can\'t make an omelette");
            this.alarm.reset(70);
         }
         else if(this.mode == 1)
         {
            addText();
            this.alarm.reset(20);
         }
         else if(this.mode == 2)
         {
            gotoText = addTypo("without breaking some eggs");
            this.alarm.reset(80);
         }
         else if(this.mode == 3)
         {
            addText();
            this.alarm.reset(80);
         }
         else if(this.mode == 4)
         {
            gotoText = addTypo("right?");
            this.alarm.reset(70);
         }
         else if(this.mode == 5)
         {
            addText();
            this.alarm.reset(40);
         }
         else if(this.mode == 6)
         {
            gotoText = addTypo("hahahahahahahahahaha",5);
            this.alarm.reset(70);
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
