package game
{
   import flash.geom.Point;
   import game.engine.Assets;
   import game.engine.Grabbable;
   import game.engine.StartUp;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   
   public class Mine extends Grabbable implements StartUp
   {
      
      private static const ImgArrow:Class = Mine_ImgArrow;
      
      private static const ImgMine:Class = Mine_ImgMine;
       
      
      private const ADD:Number = 0.04908738521234052;
      
      private var sprite:Spritemap;
      
      private const ACCEL:Number = 0.1;
      
      private var sine:Number = 0;
      
      private const FLASH_ROT:Number = -6;
      
      private var arrow:Image;
      
      private var list:Graphiclist;
      
      private var player:Player;
      
      private var boss:Boss;
      
      private var rotSpeed:Number = 0;
      
      private const SIT_ROT:Number = 0.5;
      
      private const DIVIDE:Number = 6.283185307179586;
      
      public function Mine(player:Player, x:int, y:int)
      {
         super(x,y);
         this.player = player;
         this.boss = this.boss;
         type = "mine";
         width = height = 12;
         originX = originY = 6;
         grapplePoint = new Point();
         graphic = this.list = new Graphiclist();
         this.sprite = new Spritemap(ImgMine,24,24);
         this.sprite.originX = this.sprite.originY = 12;
         this.sprite.x = -12;
         this.sprite.y = -12;
         this.sprite.add("sit",[0]);
         this.sprite.add("flash",[0,1],0.1);
         this.sprite.play("sit");
         this.list.add(this.sprite);
         this.arrow = new Image(ImgArrow);
         this.arrow.originY = 8;
         this.arrow.originX = 40;
         this.arrow.x = -40;
         this.arrow.y = -8;
         this.arrow.color = 16776960;
         this.arrow.alpha = 0;
         this.list.add(this.arrow);
      }
      
      public function startUp() : void
      {
         var arr:Array = new Array();
         FP.world.getClass(Boss,arr);
         this.boss = arr[0];
      }
      
      public function explode() : void
      {
         Assets.SndMissileExplode.play();
         Main.screenShake(1);
         Main.particles.addParticlesArea("missileExplode",x - 6,y - 6,12,12,12);
         FP.world.remove(this);
      }
      
      override public function update() : void
      {
         if(this.player && this.player.grapple && this.player.grapple.latched is Boss)
         {
            this.arrow.alpha = Math.min(this.arrow.alpha + 0.02,0.5);
            this.rotSpeed = Math.max(this.FLASH_ROT,this.rotSpeed - this.ACCEL);
            this.sprite.play("flash");
         }
         else
         {
            this.arrow.alpha = Math.max(this.arrow.alpha - 0.02,0);
            this.rotSpeed = Math.min(this.SIT_ROT,this.rotSpeed + this.ACCEL);
            this.sprite.play("sit");
         }
         if(this.arrow.alpha > 0)
         {
            this.sine = (this.sine + this.ADD) % this.DIVIDE;
            this.arrow.scaleX = 1 + Math.sin(this.sine * 2) * 0.2;
            this.arrow.originX = 40 + Math.sin(this.sine) * 3;
            this.arrow.x = -this.arrow.originX;
            this.arrow.angle = FP.angle(this.boss.x,this.boss.y,x,y);
         }
         this.sprite.angle = this.sprite.angle + this.rotSpeed;
      }
   }
}
