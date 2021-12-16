package game.cosmetic
{
   import flash.geom.Rectangle;
   import game.EndKey;
   import game.Grapple;
   import game.Player;
   import game.engine.Assets;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   
   public class PlayerFly extends Entity
   {
       
      
      private var playerHead:Image;
      
      private var playerWheel:Image;
      
      public var flip:Boolean;
      
      private const SCALE:int = 2;
      
      private const DISTANCE:int = 400;
      
      private var list:Graphiclist;
      
      public function PlayerFly(x:int, y:int, flip:Boolean = false)
      {
         var img:Image = null;
         super(x,y);
         this.flip = flip;
         layer = Main.DEPTH_ENVIRON;
         Assets.SndKeyFlyBy.play();
         graphic = this.list = new Graphiclist();
         img = new Image(EndKey.ImgKey,new Rectangle(0,0,12,16));
         img.x = -6;
         img.y = -3;
         img.originX = 6;
         img.originY = 3;
         img.angle = 90 + (!!flip?180:0);
         img.scale = 2 * this.SCALE;
         img.scrollX = img.scrollY = 0;
         this.list.add(img);
         img = new Image(Grapple.ImgGrapple,new Rectangle(6,0,6,6));
         img.x = -6 + (!!flip?12:0);
         img.y = -6;
         img.scale = 2 * this.SCALE;
         img.scrollX = img.scrollY = 0;
         this.list.add(img);
         img = new Image(Player.ImgWheel,new Rectangle(0,0,12,12));
         img.originX = img.originY = 6;
         img.x = -6 - (!!flip?-this.DISTANCE:this.DISTANCE);
         img.y = 20;
         img.scale = this.SCALE;
         img.color = 16711935;
         img.scrollX = img.scrollY = 0;
         this.list.add(img);
         this.playerWheel = img;
         img = new Image(Player.ImgHead,new Rectangle(12,4,12,13));
         img.originX = 6;
         img.originY = 12;
         img.x = -6 - (!!flip?-this.DISTANCE:this.DISTANCE);
         img.y = 14;
         img.angle = -90 + (!!flip?180:0);
         img.scale = this.SCALE;
         img.color = 16711935;
         img.scrollX = img.scrollY = 0;
         this.list.add(img);
         this.playerHead = img;
      }
      
      override public function update() : void
      {
         x = x + (!!this.flip?-15:15);
         y = y - 3;
         if(x >= -20 && x <= 340 + this.DISTANCE)
         {
            Main.screenShake(0);
         }
         if(this.flip && x < -480 || !this.flip && x > 800)
         {
            FP.world.remove(this);
         }
      }
   }
}
