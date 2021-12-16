package game.cosmetic
{
   import game.engine.Assets;
   import game.menus.MainMenu;
   import game.menus.MenuButton;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Text;
   import net.flashpunk.tweens.misc.Alarm;
   import net.flashpunk.utils.Input;
   import net.flashpunk.utils.Key;
   
   public class YouWin extends Entity
   {
       
      
      private var completeBottom:Text;
      
      private var sine:Number = 0;
      
      private var startAngle:Number;
      
      private var pressEnter:Text;
      
      private const TEXT_SCALE:int = 13;
      
      private var completeTop:Text;
      
      private var list:Graphiclist;
      
      private var menu:int = 0;
      
      private var canChange:Boolean = false;
      
      private const C_TEXT:uint = 16777215;
      
      private var canDone:Boolean = true;
      
      public function YouWin(x:int, y:int)
      {
         super(x,y);
         graphic = this.list = new Graphiclist();
         var oldSize:int = Text.size;
         Text.size = 32;
         this.startAngle = 3 + Math.random() * 10;
         this.completeTop = new Text(Main.saveData.mode == 0?"NORMAL MODE":"HARD MODE");
         this.completeTop.scrollX = this.completeTop.scrollY = 0;
         this.completeTop.originX = this.completeTop.width / 2;
         this.completeTop.originY = this.completeTop.height;
         this.completeTop.x = 160 - this.completeTop.originX;
         this.completeTop.y = 50 - this.completeTop.originY;
         this.completeTop.scale = this.TEXT_SCALE;
         this.completeTop.color = this.C_TEXT;
         this.completeTop.angle = this.startAngle;
         this.list.add(this.completeTop);
         this.completeBottom = new Text("COMPLETE!");
         this.completeBottom.scrollX = this.completeBottom.scrollY = 0;
         this.completeBottom.originX = this.completeBottom.width / 2;
         this.completeBottom.originY = 12;
         this.completeBottom.x = 160 - this.completeBottom.originX;
         this.completeBottom.y = 50 - this.completeBottom.originY;
         this.completeBottom.scale = this.TEXT_SCALE;
         this.completeBottom.color = this.C_TEXT;
         this.completeBottom.angle = this.startAngle;
         this.list.add(this.completeBottom);
         Text.size = 8;
         this.pressEnter = new Text("PRESS ENTER",160,234);
         this.pressEnter.scrollX = this.pressEnter.scrollY = 0;
         this.pressEnter.centerOO();
         this.pressEnter.color = this.C_TEXT;
         this.pressEnter.visible = false;
         this.list.add(this.pressEnter);
         Text.size = oldSize;
      }
      
      public function done(m:MenuButton = null) : void
      {
         if(this.canDone)
         {
            this.canDone = false;
            FP.world.add(new Transition(new MainMenu()));
         }
      }
      
      override public function update() : void
      {
         FP.camera.x = FP.approach(FP.camera.x,this.menu * 320,Math.max(Math.abs(x - FP.camera.x) / 4,3));
         if(this.completeTop.scale == 1)
         {
            this.sine = (this.sine + Math.PI / 128) % (Math.PI * 4);
            this.completeTop.angle = this.completeBottom.angle = this.startAngle + Math.sin(this.sine) * 6;
            this.pressEnter.angle = Math.sin(this.sine / 2) * 4;
         }
         else
         {
            this.completeTop.scale = this.completeBottom.scale = Math.max(1,this.completeTop.scale - 1);
            if(this.completeTop.scale == 1)
            {
               Main.screenShake(1);
               addTween(new Alarm(60,this.showStats,Tween.ONESHOT),true);
            }
         }
         if(this.canChange)
         {
            if(Input.pressed(Key.ENTER))
            {
               Assets.SndLevelComplete.play();
               if(this.menu == 0)
               {
                  FP.world.add(new FinalScoreTally(this,320,0));
               }
               this.canChange = false;
               this.menu++;
               this.pressEnter.visible = false;
            }
         }
      }
      
      private function showStats() : void
      {
         FP.world.add(new Graph(this,10,100));
      }
      
      public function finishStep() : void
      {
         this.canChange = true;
         this.pressEnter.visible = true;
      }
   }
}
