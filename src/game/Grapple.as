package game
{
   import flash.geom.Point;
   import game.engine.Assets;
   import game.engine.Grabbable;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.utils.Draw;
   
   public class Grapple extends Entity
   {
      
      public static const GRAB:Array = ["solid","danger","cloud","boss","mine","key","missile"];
      
      public static const ImgGrapple:Class = Grapple_ImgGrapple;
       
      
      private const MAX_LENGTH:int = 112;
      
      private const STOP_LENGTH:int = 16;
      
      private var sprite:Spritemap;
      
      private var speed:Point;
      
      private const MIN_LENGTH:int = 4;
      
      private var player:Player;
      
      public var latched:Grabbable;
      
      private const SPEED:Number = 7;
      
      private var add:int = 0;
      
      private const DRAW_OFFSET:int = -4;
      
      private var goBack:Boolean = false;
      
      public function Grapple(player:Player, x:int, y:int, dir:int)
      {
         this.speed = new Point();
         super(x,y);
         this.player = player;
         width = 6;
         height = 6;
         originX = 3;
         originY = 3;
         layer = Main.DEPTH_GRAPPLE;
         graphic = this.sprite = new Spritemap(ImgGrapple,6,6);
         this.sprite.originX = 3;
         this.sprite.originY = 3;
         this.sprite.x = -3;
         this.sprite.y = -3;
         this.sprite.scale = 2;
         this.sprite.add("open",[0]);
         this.sprite.add("latched",[1]);
         this.sprite.add("flip",[2]);
         this.sprite.play("open");
         FP.angleXY(this.speed,dir,this.SPEED);
      }
      
      private function grab(obj:Grabbable, playSound:Boolean = true) : void
      {
         if(obj is Rebound)
         {
            if(x - this.speed.x < obj.x && this.speed.x > 0)
            {
               this.add = this.add + 24;
               this.speed.x = this.speed.x * -1;
            }
            else if(x - this.speed.x > obj.x + obj.width && this.speed.x < 0)
            {
               this.add = this.add + 24;
               this.speed.x = this.speed.x * -1;
            }
            else if(y - this.speed.x < obj.y && this.speed.y > 0)
            {
               this.add = this.add + 24;
               this.speed.y = this.speed.y * -1;
            }
            else if(y - this.speed.y > obj.y + obj.height && this.speed.y < 0)
            {
               this.add = this.add + 24;
               this.speed.y = this.speed.y * -1;
            }
            (obj as Rebound).hit();
            Assets.SndRebound.play();
            return;
         }
         if(obj is NoGrapple && !(obj as NoGrapple).canGrapple)
         {
            Assets.SndNoGrapple.play();
            (obj as NoGrapple).hit();
            this.destroy();
            return;
         }
         if(obj is FlipBlock)
         {
            Assets.SndInvert.play();
         }
         else if(playSound)
         {
            Assets.SndLatch.play();
         }
         if(this.latched != null)
         {
            this.latched.onRelease();
            this.latched.grapple = null;
         }
         x = Math.round(x);
         y = Math.round(y);
         this.player.latch(FP.distance(x,y,this.player.x,this.player.y) < this.STOP_LENGTH);
         this.latched = obj;
         if(obj.grapplePoint)
         {
            x = obj.x + obj.grapplePoint.x;
            y = obj.y + obj.grapplePoint.y;
         }
         obj.grapple = this;
         obj.onGrapple();
         if(this.player.flip)
         {
            this.sprite.play("flip");
         }
         else
         {
            this.sprite.play("latched");
         }
      }
      
      public function looseMove(h:Number, v:Number, pull:Boolean = false) : void
      {
         var e:Entity = null;
         var m:Number = NaN;
         x = x + h;
         y = y + v;
         this.player.radius = FP.distance(x,y,this.player.x,this.player.y);
         if(pull && this.player.radius > this.MAX_LENGTH)
         {
            this.player.moveH(h);
            this.player.moveV(v);
            this.player.radius = FP.distance(x,y,this.player.x,this.player.y);
         }
         if(this.latched is Conveyor && !collideWith(this.latched,Math.round(x),Math.round(y)))
         {
            if((e = collideTypes(GRAB,Math.round(x),Math.round(y))) != null && e is Grabbable)
            {
               m = this.player.momentum;
               this.grab(e as Grabbable,false);
               this.player.momentum = m;
            }
            else
            {
               this.destroy();
            }
         }
      }
      
      override public function update() : void
      {
         var e:Entity = null;
         this.sprite.angle = FP.angle(this.player.x,this.player.y + this.DRAW_OFFSET,x,y);
         if(!this.latched)
         {
            x = x + this.speed.x;
            y = y + this.speed.y;
            if((e = collideTypes(GRAB,Math.round(x),Math.round(y))) != null && e is Grabbable && FP.distance(x,y,this.player.x,this.player.y + this.DRAW_OFFSET) >= this.MIN_LENGTH)
            {
               this.grab(e as Grabbable);
               return;
            }
            if((e = collide("item",x,y)) != null)
            {
               if(e is Jetpack)
               {
                  this.player.collectJetpack(e as Jetpack);
               }
               else if(e is Coin)
               {
                  this.player.collectCoin(e as Coin);
               }
            }
            if(this.goBack)
            {
               FP.angleXY(this.speed,FP.angle(x,y,this.player.x,this.player.y + this.DRAW_OFFSET),this.SPEED);
               if(collideWith(this.player,x,y))
               {
                  this.destroy();
               }
            }
            else if(FP.distance(x,y,this.player.x,this.player.y + this.DRAW_OFFSET) >= this.MAX_LENGTH + this.add)
            {
               this.goBack = true;
            }
         }
      }
      
      public function endWarp() : void
      {
         active = true;
         this.sprite.alpha = 1;
      }
      
      override public function render() : void
      {
         var color:uint = 0;
         if(this.latched)
         {
            if(this.player.flip)
            {
               color = 65535;
            }
            else
            {
               color = 16711935;
            }
         }
         else
         {
            color = 16776960;
         }
         var distance:Number = FP.distance(x,y,this.player.x,this.player.y + this.DRAW_OFFSET);
         var point:Point = new Point();
         FP.angleXY(point,this.sprite.angle,distance / 3);
         Draw.rect(x - point.x - 1,y - point.y - 1,2,2,color);
         FP.angleXY(point,this.sprite.angle,distance / 2);
         Draw.rect(x - point.x - 1,y - point.y - 1,2,2,color);
         FP.angleXY(point,this.sprite.angle,distance * 2 / 3);
         Draw.rect(x - point.x - 1,y - point.y - 1,2,2,color);
         super.render();
      }
      
      public function move(h:Number, v:Number) : void
      {
         var e:Entity = null;
         var m:Number = NaN;
         x = x + h;
         y = y + v;
         this.player.moveH(h);
         this.player.moveV(v);
         this.player.radius = FP.distance(x,y,this.player.x,this.player.y);
         if(this.latched is Conveyor && !collideWith(this.latched,Math.round(x),Math.round(y)))
         {
            if((e = collideTypes(GRAB,Math.round(x),Math.round(y))) != null && e is Grabbable)
            {
               m = this.player.momentum;
               this.grab(e as Grabbable,false);
               this.player.momentum = m;
            }
            else
            {
               this.destroy();
            }
         }
      }
      
      public function startWarp() : void
      {
         active = false;
         this.sprite.alpha = 0.4;
      }
      
      public function destroy(playSound:Boolean = true) : void
      {
         if(this.latched)
         {
            if(playSound)
            {
               Assets.SndUnlatch.play(0.6);
            }
            this.player.release();
            this.latched.grapple = null;
            this.latched.onRelease();
         }
         FP.world.remove(this);
         this.player.grapple = null;
         active = false;
         visible = false;
      }
   }
}
