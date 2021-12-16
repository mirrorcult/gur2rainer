package game
{
   import net.flashpunk.Entity;
   import net.flashpunk.graphics.Spritemap;
   
   public class FireBall extends Entity
   {
      
      private static const ImgFireball:Class = FireBall_ImgFireball;
       
      
      private var sprite:Spritemap;
      
      public function FireBall(x:int, y:int)
      {
         super(x,y);
         type = "fire";
         width = 14;
         height = 14;
         originX = 7;
         originY = 7;
         layer = Main.DEPTH_ACTORS;
         graphic = this.sprite = new Spritemap(ImgFireball,16,16);
         this.sprite.x = -8;
         this.sprite.y = -8;
         this.sprite.originX = 8;
         this.sprite.originY = 8;
         this.sprite.add("fire",[0,1,2,3,4,5],0.2);
         this.sprite.play("fire");
      }
      
      override public function update() : void
      {
         this.sprite.angle = this.sprite.angle + 4;
      }
   }
}
