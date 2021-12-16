package game
{
   import game.engine.Grabbable;
   
   public class Block extends Grabbable
   {
       
      
      protected var player:Player;
      
      private var hCounter:Number = 0;
      
      private var vCounter:Number = 0;
      
      public var shake:int = 0;
      
      public function Block(player:Player, x:int, y:int, width:int, height:int)
      {
         super(x,y);
         this.player = player;
         this.width = width;
         this.height = height;
         type = "solid";
         active = false;
         visible = false;
      }
      
      public function moveV(num:Number) : void
      {
         var go:int = 0;
         var move:int = 0;
         this.vCounter = this.vCounter + num;
         go = Math.round(this.vCounter);
         this.vCounter = this.vCounter - go;
         if(go == 0)
         {
            return;
         }
         if(this.player && this.player.active)
         {
            if(go > 0)
            {
               if(collideWith(this.player,x,y - 1))
               {
                  y = y - 100000;
                  this.player.moveV(go);
                  y = y + 100000;
               }
               else if(collideWith(this.player,x,y + go))
               {
                  move = go - (this.player.y - this.player.originY - (y + height));
                  this.player.moveV(move,this.player.die);
               }
            }
            else if(collideWith(this.player,x,y + go))
            {
               move = go + (y - (this.player.y - this.player.originY + this.player.height));
               this.player.moveV(move,this.player.die);
            }
            if(this.player.grapple && this.player.grapple.latched == this)
            {
               this.player.grapple.move(0,go);
            }
         }
         y = y + go;
      }
      
      public function moveH(num:Number) : void
      {
         var sign:int = 0;
         var move:int = 0;
         this.hCounter = this.hCounter + num;
         var go:int = Math.round(this.hCounter);
         this.hCounter = this.hCounter - go;
         if(go == 0)
         {
            return;
         }
         if(this.player && this.player.active)
         {
            if(collideWith(this.player,x,y - 1))
            {
               this.player.moveH(go);
            }
            else if(collideWith(this.player,x + go,y))
            {
               sign = go > 0?1:-1;
               if(sign == 1)
               {
                  move = go - (this.player.x - this.player.originX - (x + width));
               }
               else
               {
                  move = go - (x - (this.player.x - this.player.originX + this.player.width));
               }
               this.player.moveH(move,this.player.die);
            }
            if(this.player.grapple && this.player.grapple.latched == this)
            {
               this.player.grapple.move(go,0);
            }
         }
         x = x + go;
      }
      
      override public function render() : void
      {
         var mX:int = 0;
         var mY:int = 0;
         if(this.shake != 0)
         {
            mX = -3 + Math.random() * 6;
            mY = -3 + Math.random() * 6;
            graphic.x = graphic.x + mX;
            graphic.y = graphic.y + mY;
            super.render();
            graphic.x = graphic.x - mX;
            graphic.y = graphic.y - mY;
            if(this.shake > 0)
            {
               this.shake--;
            }
         }
         else
         {
            super.render();
         }
      }
   }
}
