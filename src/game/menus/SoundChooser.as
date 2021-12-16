package game.menus
{
   import game.engine.Assets;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Text;
   import net.flashpunk.utils.Input;
   
   public class SoundChooser extends Entity
   {
       
      
      private var left:Text;
      
      private const ARROW_BIG:Number = 1.4;
      
      private const TEXT_BIG:Number = 1.2;
      
      private const MID_WIDTH:int = 100;
      
      private var nameArray:Array;
      
      private const SIDE_HEIGHT:int = 10;
      
      private var loop:Boolean;
      
      private const MID_HEIGHT:int = 10;
      
      private var right:Text;
      
      private var mouse:int = -1;
      
      private const SIDE_X:int = 40;
      
      private var text:Text;
      
      private var list:Graphiclist;
      
      private var current:int = 0;
      
      private var fileArray:Array;
      
      private const SIDE_WIDTH:int = 20;
      
      public function SoundChooser(y:int, fileArray:Array, nameArray:Array, loop:Boolean = false)
      {
         super(160,y);
         this.fileArray = fileArray;
         this.nameArray = nameArray;
         this.loop = loop;
         graphic = this.list = new Graphiclist();
         Text.size = 16;
         this.left = new Text("<<",this.SIDE_X,y);
         this.left.relative = false;
         this.left.color = 16777215;
         this.left.centerOO();
         this.list.add(this.left);
         this.right = new Text(">>",320 - this.SIDE_X,y);
         this.right.relative = false;
         this.right.color = 16777215;
         this.right.centerOO();
         this.list.add(this.right);
         this.text = new Text("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",160,y);
         this.text.relative = false;
         this.text.color = 16777215;
         this.text.centerOO();
         this.list.add(this.text);
         this.getCurrent();
      }
      
      private function gotoNext() : void
      {
         if(this.loop)
         {
            Assets.setMusic();
         }
         this.current++;
         if(this.current >= this.fileArray.length)
         {
            this.current = 0;
         }
         this.getCurrent();
      }
      
      override public function update() : void
      {
         if(this.mouse == 0)
         {
            if(!this.mouseLeft())
            {
               this.left.scale = 1;
               this.mouse = -1;
            }
            else if(Input.mousePressed)
            {
               this.gotoPrev();
            }
         }
         else if(this.mouseLeft())
         {
            this.mouse = 0;
            this.left.scale = this.ARROW_BIG;
            this.right.scale = 1;
            this.text.scale = 1;
         }
         if(this.mouse == 2)
         {
            if(!this.mouseRight())
            {
               this.right.scale = 1;
               this.mouse = -1;
            }
            else if(Input.mousePressed)
            {
               this.gotoNext();
            }
         }
         else if(this.mouseRight())
         {
            this.mouse = 2;
            this.right.scale = this.ARROW_BIG;
            this.left.scale = 1;
            this.text.scale = 1;
         }
         if(this.mouse == 1)
         {
            if(!this.mouseMid())
            {
               this.text.scale = 1;
               this.mouse = -1;
            }
            else if(Input.mousePressed)
            {
               this.play();
            }
         }
         else if(this.mouseMid())
         {
            this.mouse = 1;
            this.text.scale = this.TEXT_BIG;
            this.right.scale = 1;
            this.left.scale = 1;
         }
      }
      
      private function mouseLeft() : Boolean
      {
         return FP.world.mouseX > this.SIDE_X - this.SIDE_WIDTH && FP.world.mouseX < this.SIDE_X + this.SIDE_WIDTH && FP.world.mouseY > y - this.SIDE_HEIGHT && FP.world.mouseY < y + this.SIDE_HEIGHT;
      }
      
      private function getCurrent() : void
      {
         this.text.text = this.nameArray[this.current];
         this.text.centerOO();
      }
      
      private function gotoPrev() : void
      {
         if(this.loop)
         {
            Assets.setMusic();
         }
         this.current--;
         if(this.current < 0)
         {
            this.current = this.fileArray.length - 1;
         }
         this.getCurrent();
      }
      
      private function mouseMid() : Boolean
      {
         return FP.world.mouseX > 160 - this.MID_WIDTH && FP.world.mouseX < 160 + this.MID_WIDTH && FP.world.mouseY > y - this.MID_HEIGHT && FP.world.mouseY < y + this.MID_HEIGHT;
      }
      
      private function mouseRight() : Boolean
      {
         return FP.world.mouseX > 320 - this.SIDE_X - this.SIDE_WIDTH && FP.world.mouseX < 320 - this.SIDE_X + this.SIDE_WIDTH && FP.world.mouseY > y - this.SIDE_HEIGHT && FP.world.mouseY < y + this.SIDE_HEIGHT;
      }
      
      private function play() : void
      {
         if(this.loop)
         {
            Assets.setMusic(this.fileArray[this.current]);
         }
         else
         {
            this.fileArray[this.current].play();
         }
      }
   }
}
