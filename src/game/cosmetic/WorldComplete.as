package game.cosmetic
{
   import flash.display.BitmapData;
   import game.engine.Assets;
   import game.engine.Level;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Text;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class WorldComplete extends Entity
   {
       
      
      private const C_BG:uint = 4.27819008E9;
      
      private var text1:Text;
      
      private var bg:Image;
      
      private const C_TEXT:uint = 16776960;
      
      private var text2:Text;
      
      private var textBack:Boolean = false;
      
      private const TEXT_SCALE:int = 13;
      
      private var list:Graphiclist;
      
      public function WorldComplete()
      {
         var oldSize:int = 0;
         super();
         layer = Main.DEPTH_ENVIRON;
         graphic = this.list = new Graphiclist();
         Assets.SndWorldComplete.play();
         var bd:BitmapData = new BitmapData(320,240,true,this.C_BG);
         this.bg = new Image(bd);
         this.bg.scrollX = this.bg.scrollY = 0;
         this.bg.alpha = 0;
         this.list.add(this.bg);
         var world:uint = Math.floor(Main.saveData.level / 20);
         oldSize = Text.size;
         Text.size = 48;
         this.text1 = new Text("WORLD " + world);
         this.text1.scrollX = this.text1.scrollY = 0;
         this.text1.originX = this.text1.width / 2;
         this.text1.originY = this.text1.height + 2;
         this.text1.x = 160 - this.text1.originX;
         this.text1.y = 120 - this.text1.originY;
         this.text1.scale = this.TEXT_SCALE;
         this.text1.color = this.C_TEXT;
         this.text1.angle = 5 + Math.random() * 10;
         this.list.add(this.text1);
         this.text2 = new Text("COMPLETE");
         this.text2.scrollX = this.text2.scrollY = 0;
         this.text2.originX = this.text2.width / 2;
         this.text2.originY = -2;
         this.text2.x = 160 - this.text2.originX;
         this.text2.y = 120 - this.text2.originY;
         this.text2.scale = this.TEXT_SCALE;
         this.text2.color = this.C_TEXT;
         this.text2.angle = this.text1.angle;
         this.list.add(this.text2);
         Text.size = oldSize;
      }
      
      override public function update() : void
      {
         this.bg.alpha = Math.min(0.5,this.bg.alpha + 0.1);
         if(this.textBack)
         {
            this.text1.scale = this.text2.scale = Math.min(this.TEXT_SCALE,this.text1.scale + 1);
         }
         else if(this.text1.scale == 1)
         {
            this.text1.angle = this.text1.angle - 0.07;
            this.text2.angle = this.text2.angle - 0.07;
         }
         else
         {
            this.text1.scale = this.text2.scale = Math.max(1,this.text1.scale - 1);
            if(this.text1.scale == 1)
            {
               addTween(new Alarm(120,function():void
               {
                  textBack = true;
                  Assets.SndTextFly.play();
               },Tween.ONESHOT),true);
               addTween(new Alarm(150,this.done,Tween.ONESHOT),true);
               Main.screenShake(1);
            }
         }
      }
      
      private function done() : void
      {
         (FP.world as Level).player.win();
      }
   }
}
