package game.menus
{
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.graphics.Text;
   import net.flashpunk.utils.Input;
   
   public class ImageButton extends Entity
   {
       
      
      private var func:Function;
      
      private var sprite:Spritemap;
      
      private var text:Text;
      
      private var mouseOver:Boolean = false;
      
      private var list:Graphiclist;
      
      public function ImageButton(x:int, y:int, spr:Class, str:String, func:Function)
      {
         var oldSize:int = 0;
         super(x,y);
         this.func = func;
         graphic = this.list = new Graphiclist();
         this.sprite = new Spritemap(spr,16,16);
         this.sprite.add("normal",[0]);
         this.sprite.add("over",[1]);
         this.sprite.add("done",[2]);
         this.sprite.play("normal");
         this.sprite.centerOO();
         this.sprite.scale = 2;
         this.list.add(this.sprite);
         oldSize = Text.size;
         Text.size = 8;
         this.text = new Text(str,480,y + 32);
         this.text.relative = false;
         this.text.color = 16777215;
         this.text.visible = false;
         this.text.centerOO();
         this.list.add(this.text);
         Text.size = oldSize;
      }
      
      override public function update() : void
      {
         if(this.mouseOver)
         {
            if(!this.checkMouse())
            {
               this.mouseOver = false;
               this.sprite.play("normal");
               this.sprite.scale = 2;
               this.text.visible = false;
            }
            else if(Input.mousePressed)
            {
               this.click();
            }
         }
         else if(this.checkMouse())
         {
            this.mouseOver = true;
            this.sprite.play("over");
            this.sprite.scale = 2.5;
            this.text.visible = true;
         }
      }
      
      private function click() : void
      {
         this.func();
         this.sprite.scale = 1.5;
         this.sprite.play("done");
         this.sprite.alpha = 0.6;
         active = false;
         this.text.visible = false;
      }
      
      private function checkMouse() : Boolean
      {
         return FP.world.mouseX > x - 16 && FP.world.mouseY > y - 16 && FP.world.mouseX < x + 16 && FP.world.mouseY < y + 16;
      }
   }
}
