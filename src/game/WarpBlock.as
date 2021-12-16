package game
{
   import flash.geom.Point;
   import game.engine.Assets;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   
   public class WarpBlock extends Block
   {
      
      private static const ImgWarpBlock:Class = WarpBlock_ImgWarpBlock;
      
      private static const ImgWarpTo:Class = WarpBlock_ImgWarpTo;
       
      
      private var done:Boolean = false;
      
      private var goTo:Vector.<Image>;
      
      private var timer:uint = 90;
      
      private const C_START:uint = 6520319;
      
      private var num:int = -1;
      
      private var moving:Boolean = false;
      
      private const TIME:uint = 90;
      
      private const C_DONE:uint = 10845777;
      
      private var list:Graphiclist;
      
      private var image:Image;
      
      private const SHAKE:uint = 20;
      
      private var go:Vector.<Point>;
      
      private const C_END:uint = 16740656;
      
      public function WarpBlock(player:Player, x:int, y:int, go:Vector.<Point>)
      {
         var i:int = 0;
         super(player,x,y,16,16);
         this.go = go;
         visible = true;
         active = true;
         layer = Main.DEPTH_ACTORS;
         grapplePoint = new Point(8,8);
         graphic = this.list = new Graphiclist();
         this.image = new Image(ImgWarpBlock);
         this.image.centerOrigin();
         this.image.color = this.C_START;
         this.list.add(this.image);
         this.goTo = new Vector.<Image>();
         for(i = 0; i < go.length; i++)
         {
            this.goTo[i] = new Image(ImgWarpTo);
            this.goTo[i].centerOrigin();
            this.goTo[i].color = this.C_END;
            this.goTo[i].alpha = 0.4;
            this.goTo[i].relative = false;
            this.goTo[i].x = go[i].x;
            this.goTo[i].y = go[i].y;
            this.list.add(this.goTo[i]);
         }
      }
      
      private function warp() : void
      {
         Assets.SndWarp.play();
         this.num++;
         this.moving = true;
         grapple.startWarp();
         player.startWarp();
         this.image.scale = 2;
         if(this.num < this.go.length - 1)
         {
            this.timer = this.TIME;
         }
         else
         {
            this.done = true;
         }
         shake = -1;
      }
      
      override public function update() : void
      {
         var moveX:Number = NaN;
         var moveY:Number = NaN;
         var obj:Entity = null;
         if(this.moving)
         {
            moveX = x;
            moveY = y;
            x = FP.approach(x,this.goTo[this.num].x,Math.max(3,Math.abs(this.goTo[this.num].x - x) / 8));
            y = FP.approach(y,this.goTo[this.num].y,Math.max(3,Math.abs(this.goTo[this.num].y - y) / 8));
            moveX = x - moveX;
            moveY = y - moveY;
            player.x = player.x + moveX;
            player.y = player.y + moveY;
            obj = player.collide("item",player.x,player.y);
            if(obj is Coin)
            {
               player.collectCoin(obj as Coin);
            }
            grapple.x = grapple.x + moveX;
            grapple.y = grapple.y + moveY;
            player.cameraFollow();
            if(x == this.goTo[this.num].x && y == this.goTo[this.num].y)
            {
               this.moving = false;
               shake = 0;
               grapple.endWarp();
               player.endWarp();
               this.goTo[this.num].visible = false;
            }
            return;
         }
         if(this.image.scale > 1)
         {
            this.image.scale = Math.max(1,this.image.scale - 0.02);
         }
         if(this.done)
         {
            this.image.color = this.C_DONE;
            return;
         }
         if(grapple)
         {
            this.timer--;
            if(this.timer == 0)
            {
               this.warp();
            }
            else if(this.timer <= this.SHAKE)
            {
               shake = -1;
            }
            this.image.color = FP.colorLerp(this.C_END,this.C_START,this.timer / (this.TIME - this.SHAKE));
         }
         else if(this.timer < this.TIME)
         {
            this.timer++;
            shake = 0;
            this.image.color = FP.colorLerp(this.C_END,this.C_START,this.timer / (this.TIME - this.SHAKE));
         }
         for(var i:int = 0; i < this.goTo.length; i++)
         {
            this.goTo[i].angle++;
         }
      }
      
      override public function onRelease() : void
      {
         this.image.scale = 1.2;
      }
      
      override public function onGrapple() : void
      {
         this.image.scale = 1.2;
      }
   }
}
