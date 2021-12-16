package game.cosmetic
{
   import flash.display.BitmapData;
   import game.EndKey;
   import game.engine.Level;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Text;
   
   public class GetKey extends Pauser
   {
       
      
      private const C_BG:uint = 7060735;
      
      private var text1:Text;
      
      private var bg:Image;
      
      private const C_TEXT:uint = 16776960;
      
      private var text2:Text;
      
      private var timer:uint = 120;
      
      private var list:Graphiclist;
      
      private var key:EndKey;
      
      public function GetKey(key:EndKey)
      {
         var bd:BitmapData = null;
         super();
         this.key = key;
         layer = Main.DEPTH_BGEFFECT;
         Main.screenShake(2);
         graphic = this.list = new Graphiclist();
         bd = new BitmapData(320,240,true,4294967295);
         this.bg = new Image(bd);
         this.bg.color = this.C_BG;
         this.bg.scrollX = this.bg.scrollY = 0;
         this.bg.alpha = 0;
         this.list.add(this.bg);
         var oldSize:int = Text.size;
         Text.size = 48;
         this.text1 = new Text(Main.saveData.level == Level.WORLD2?"AWESOME":"ANOTHER");
         this.text1.scrollX = this.text1.scrollY = 0;
         this.text1.originX = this.text1.width / 2;
         this.text1.originY = this.text1.height;
         this.text1.x = 160 - this.text1.originX;
         this.text1.y = 80 - this.text1.originY;
         this.text1.scale = 3;
         this.text1.color = this.C_TEXT;
         this.text1.angle = 5 + Math.random() * 10;
         this.list.add(this.text1);
         this.text2 = new Text(Main.saveData.level == Level.WORLD2?"GIANT KEY!!":"GIANT KEY!?");
         this.text2.scrollX = this.text2.scrollY = 0;
         this.text2.originX = this.text2.width / 2;
         this.text2.originY = -40;
         this.text2.x = 160 - this.text2.originX;
         this.text2.y = 80 - this.text2.originY;
         this.text2.scale = 3;
         this.text2.color = this.C_TEXT;
         this.text2.angle = this.text1.angle;
         this.list.add(this.text2);
      }
      
      override public function update() : void
      {
         this.bg.alpha = Math.min(this.bg.alpha + 0.1,0.8);
         this.text1.scale = Math.max(1,this.text1.scale - 0.25);
         this.text2.scale = this.text1.scale;
         this.text1.angle = this.text1.angle - 0.08;
         this.text2.angle = this.text2.angle - 0.08;
         this.timer--;
         if(this.timer == 0)
         {
            this.finish();
         }
      }
      
      override protected function finish() : void
      {
         super.finish();
         this.key.fly();
      }
   }
}
