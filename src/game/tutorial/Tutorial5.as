package game.tutorial
{
   import game.GiantLever;
   import game.Player;
   import game.engine.StartUp;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class Tutorial5 extends Tutorial implements StartUp
   {
       
      
      private var mode:uint = 0;
      
      private var block:GiantLever;
      
      private var alarm:Alarm;
      
      private var canStart:Boolean = true;
      
      public function Tutorial5(player:Player)
      {
         this.alarm = new Alarm(60,this.onAlarm,Tween.PERSIST);
         super(player);
         addTween(this.alarm,true);
      }
      
      override public function update() : void
      {
         if(this.mode >= 5 && !player.grapple && this.canStart)
         {
            this.mode = Math.max(5,Math.floor(this.mode / 2) * 2 - 1);
            gotoText = addTypo(FP.choose("No! Get back on there!","Don\'t stop now!","Keep pulling!","Come on!","Help a brother out!","Don\'t leave me hanging!","It\'s harmless, I swear!","Pull it!!"));
            this.alarm.reset(70);
            this.alarm.start();
            this.canStart = false;
         }
         else if(this.mode == 4 && this.block.y >= 50)
         {
            this.mode = 5;
            gotoText = addTypo("Yes, like that");
            this.alarm.reset(60);
            this.alarm.start();
         }
         else if(this.mode == 6 && this.block.y >= 110)
         {
            this.mode = 7;
            gotoText = addTypo("Keep going...");
            this.alarm.reset(60);
            this.alarm.start();
         }
         else if(this.mode == 8 && this.block.y >= 160)
         {
            this.mode = 9;
            gotoText = addTypo("Just a bit more...");
            this.alarm.reset(60);
            this.alarm.start();
         }
         else if(this.mode == 10 && this.block.y >= 216)
         {
            this.mode = 11;
            gotoText = "DO " + addTypo("ITTTTTTTTTTTT!!!!!!!!!!!!!!",5);
            this.alarm.reset(70);
            this.alarm.start();
         }
      }
      
      public function startUp() : void
      {
         var arr:Array = new Array();
         FP.world.getClass(GiantLever,arr);
         this.block = arr[0];
      }
      
      private function onAlarm() : void
      {
         if(this.mode == 0)
         {
            gotoText = "You\'ve found it!";
            this.alarm.reset(45);
         }
         else if(this.mode == 1)
         {
            addText();
            gotoText = addTypo("Now just pull it back into place");
            this.alarm.reset(75);
         }
         else if(this.mode == 2)
         {
            addText();
            gotoText = addTypo("To restore the electricity");
            this.alarm.reset(70);
         }
         else if(this.mode == 3)
         {
            addText();
         }
         else if(this.mode == 5 || this.mode == 7 || this.mode == 9 || this.mode == 11)
         {
            addText();
            this.canStart = true;
         }
         if(this.mode < 3)
         {
            this.alarm.start();
         }
         this.mode++;
      }
   }
}
