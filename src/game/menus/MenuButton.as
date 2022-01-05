package game.menus
{
   import flash.display.BitmapData;
   import game.engine.Assets;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.Sfx;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Text;
   import net.flashpunk.utils.Input;
   
   public class MenuButton extends Entity
   {
       
      
      private var HIT_WIDTH:uint = 80;
      
      private var bg:Image;
      
      private var onClick:Function;
      
      private var text:Text;
      
      private var sound:Sfx;
      
      private var sine:Number;
      
      private var HIT_HEIGHT:uint = 9;
      
      private var mouseOver:Boolean = false;
      
      private var list:Graphiclist;
      
      public function MenuButton(x:int, y:int, str:String, onClick:Function, sound:Sfx = null, largeBg:Boolean=true, size:uint=16, hitWidth:uint=80, hitHeight:uint=9)
      {
         super(x,y);
         this.onClick = onClick;
         this.sound = sound;
         graphic = this.list = new Graphiclist();
         if (largeBg) 
         {
            var bd:BitmapData = new BitmapData(320,20,true,4294967295);
            this.bg = new Image(bd);
            this.bg.alpha = 0.4;
            this.bg.color = 16711680;
            this.bg.visible = false;
            this.bg.relative = false;
            this.bg.scrollX = this.bg.scrollY = 0;
            this.bg.y = y - 10;
            this.list.add(this.bg);
         }
         else
         {
            var bd:BitmapData = new BitmapData(size * 2,size * 2,true,4294967295);
            this.bg = new Image(bd);
            this.bg.x = x - size;
            this.bg.y = y - size;
            this.bg.alpha = 0.4;
            this.bg.color = 16711680;
            this.bg.visible = false;
            this.bg.relative = false;
            this.list.add(this.bg);
         }
         this.HIT_WIDTH = hitWidth;
         this.HIT_HEIGHT = hitHeight;

         Text.size = size;
         this.text = new Text("99999999999999999999999999999");
         this.text.text = str;
         this.text.color = 16777215;
         this.text.x = -this.text.width / 2;
         this.text.y = -this.text.height / 2;
         this.text.centerOrigin();
         this.list.add(this.text);
         this.sine = Math.random() * Math.PI * 2;
      }
      
      public function setText(to:String) : void
      {
         this.text.text = to;
         this.text.x = -this.text.width / 2;
         this.text.centerOrigin();
      }

      public function getText() : String
      {
         return this.text.text;
      }
      
      private function mouseIn() : Boolean
      {
         return FP.world.mouseX > x - this.HIT_WIDTH && FP.world.mouseX < x + this.HIT_WIDTH && FP.world.mouseY > y - this.HIT_HEIGHT && FP.world.mouseY < y + this.HIT_HEIGHT;
      }
      
      override public function update() : void
      {
         this.sine = (this.sine + Math.PI / 64) % (Math.PI * 2);
         if(this.mouseOver)
         {
            this.text.angle = Math.sin(this.sine) * 8;
            if(!this.mouseIn())
            {
               this.mouseOver = false;
               this.text.scale = 1;
               this.bg.visible = false;
            }
         }
         else
         {
            this.text.angle = Math.sin(this.sine) * 4;
            if(this.mouseIn())
            {
               Assets.instance.SndMenuMouse.play(0.3);
               this.mouseOver = true;
               this.text.scale = 1.25;
               this.bg.visible = true;
            }
         }
         if(this.mouseOver && Input.mousePressed)
         {
            this.onClick(this);
            if(this.sound)
            {
               this.sound.play();
            }
         }
      }
      
      public function deactivate() : void
      {
         active = false;
         this.text.alpha = 0.3;
      }
   }
}
