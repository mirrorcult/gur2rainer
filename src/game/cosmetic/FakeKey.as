package game.cosmetic
{
   import game.EndKey;
   import game.Jetpack;
   import game.Player;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   
   public class FakeKey extends Entity
   {
       
      
      private var player:Player;
      
      private var sprite:Spritemap;
      
      private var go:Boolean = false;
      
      private var sine:Number = 0;
      
      private var glow:Image;
      
      private var list:Graphiclist;
      
      private var hSpeed:Number = 0;
      
      public function FakeKey(player:Player, x:int, y:int)
      {
         super(x,y);
         this.player = player;
         layer = Main.DEPTH_ACTORS;
         graphic = this.list = new Graphiclist();
         this.glow = new Image(Jetpack.ImgBG);
         this.glow.centerOO();
         this.glow.scale = 3;
         this.glow.color = 16776960;
         this.glow.alpha = 0.5;
         this.list.add(this.glow);
         this.sprite = new Spritemap(EndKey.ImgKey,12,16);
         this.sprite.add("go",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],0.15);
         this.sprite.add("fly",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],0.6);
         this.sprite.play("go");
         this.sprite.centerOO();
         this.sprite.scale = 2;
         this.list.add(this.sprite);
      }
      
      override public function update() : void
      {
         if(this.go)
         {
            this.hSpeed = this.hSpeed + 0.1;
         }
         else if(this.player.x >= x - 160)
         {
            this.go = true;
         }
         x = x + this.hSpeed;
         if(x > FP.camera.x + 360)
         {
            FP.world.remove(this);
         }
         this.sine = (this.sine + Math.PI / 32) % (Math.PI * 4);
         FP.point.x = Math.sin(this.sine / 2) * 6;
         FP.point.y = Math.sin(this.sine) * 6;
         this.sprite.x = FP.point.x - this.sprite.originX;
         this.sprite.y = FP.point.y - this.sprite.originY;
         this.glow.x = FP.point.x - this.glow.originX;
         this.glow.y = FP.point.y - this.glow.originY;
      }
   }
}
