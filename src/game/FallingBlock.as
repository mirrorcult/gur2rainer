package game
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import game.cosmetic.Face;
   import game.engine.Assets;
   import game.engine.Level;
   import game.engine.StartUp;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   
   public class FallingBlock extends Block implements StartUp
   {
       
      
      private var waiting:Boolean = true;
      
      private const DROP_TIMER:uint = 50;
      
      private const MAX_FALL:Number = 4.0;
      
      public var stopY:int = 0;
      
      private var image:Image;
      
      private var face:Face;
      
      private const C_NORMAL:uint = 16737860;
      
      private const C_LAND:uint = 9850946;
      
      private const C_SHAKE:uint = 16711680;
      
      public var vSpeed:Number = 0;
      
      private const C_FALL:uint = 16757836;
      
      public var counter:uint = 0;
      
      private const GRAVITY:Number = 0.2;
      
      public function FallingBlock(player:Player, x:int, y:int, width:int, height:int)
      {
         super(player,x,y,width,height);
         active = true;
         visible = true;
         layer = Main.DEPTH_ACTORS;
         var list:Graphiclist = new Graphiclist();
         graphic = list;
         var bd:BitmapData = new BitmapData(width,height,true,4278190080);
         bd.fillRect(new Rectangle(1,1,bd.width - 2,bd.height - 2),4294967295);
         var q:int = Math.floor(bd.height / 4);
         bd.fillRect(new Rectangle(1,bd.height - 1 - q,bd.width - 2,q),4292730333);
         list.add(this.image = new Image(bd));
         this.image.color = this.C_NORMAL;
         list.add(this.face = new Face(width / 2,Math.max(6,height / 4)));
      }
      
      override public function update() : void
      {
         var i:int = 0;
         if(this.waiting)
         {
            if(player && player.grapple && player.grapple.latched == this || collideWith(player,x,y - 1))
            {
               Assets.SndFallingStart.play();
               this.face.play("surprised");
               this.image.color = this.C_SHAKE;
               this.waiting = false;
               shake = -1;
               this.counter = this.DROP_TIMER;
            }
         }
         else if(this.counter > 0)
         {
            this.counter--;
            if(this.counter == 0 || !(player && player.grapple && player.grapple.latched == this || collideWith(player,x,y - 1)))
            {
               Assets.SndFallingFall.play();
               this.face.play("horrified");
               this.image.color = this.C_FALL;
               this.counter = 0;
               shake = 0;
            }
         }
         else
         {
            this.vSpeed = Math.min(this.vSpeed + this.GRAVITY,this.MAX_FALL);
            moveV(this.vSpeed);
            if(y >= this.stopY)
            {
               Assets.SndFallingLand.play();
               Main.screenShake(1);
               if(y >= (FP.world as Level).height)
               {
                  for(i = 0; i < width; i = i + 8)
                  {
                     Main.particles.addParticlesArea("fallingPlatOffBottom",x + i,y - 6,8,0,2);
                  }
                  FP.world.remove(this);
               }
               else
               {
                  this.image.color = this.C_LAND;
                  this.face.play("pain");
                  active = false;
               }
            }
         }
      }
      
      public function startUp() : void
      {
         var obj:Entity = null;
         this.stopY = y;
         do
         {
            this.stopY = this.stopY + 8;
            obj = collide("solid",x,this.stopY + 1);
         }
         while(this.stopY <= (FP.world as Level).height + 8 && (obj == null || obj is FallingBlock));
         
      }
   }
}
