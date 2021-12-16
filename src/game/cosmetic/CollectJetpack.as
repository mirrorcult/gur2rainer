package game.cosmetic
{
   import flash.display.BitmapData;
   import game.Jetpack;
   import game.Player;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Text;
   import net.flashpunk.utils.Input;
   
   public class CollectJetpack extends Pauser
   {
       
      
      private const C_BG:uint = 16711680;
      
      private const SMALL_ADD_X:int = -15;
      
      private const SMALL_ADD_Y:int = 22;
      
      private var bg:Image;
      
      private var stripe1:Image;
      
      private var stripe2:Image;
      
      private var bigText:Text;
      
      private var smallText:Text;
      
      private var goOut:Boolean = false;
      
      private var timer:uint = 40;
      
      private var list:Graphiclist;
      
      private const STRIPE1_ADD_X:int = 0;
      
      private const STRIPE1_ADD_Y:int = -40;
      
      private const STRIPE2_ADD_Y:int = 50;
      
      private const STRIPE2_ADD_X:int = 0;
      
      private var player:Player;
      
      private const C_TEXT:uint = 16776960;
      
      private var behindPlayer:Image;
      
      public function CollectJetpack(player:Player)
      {
         var bd:BitmapData = null;
         super();
         layer = Main.DEPTH_BGEFFECT;
         this.player = player;
         Main.screenShake(2);
         graphic = this.list = new Graphiclist();
         bd = new BitmapData(320,240,true,4294967295);
         this.bg = new Image(bd);
         this.bg.color = this.C_BG;
         this.bg.scrollX = this.bg.scrollY = 0;
         this.bg.alpha = 0;
         this.list.add(this.bg);
         var oldSize:int = Text.size;
         Text.size = 48;
         this.bigText = new Text(Math.random() <= 0.1?"JETPACK!!1!":"JETPACK!!!!");
         centerTextOrigin(this.bigText);
         this.bigText.scrollX = this.bigText.scrollY = 0;
         this.bigText.color = this.C_TEXT;
         this.bigText.x = -160 - this.bigText.originX;
         this.bigText.y = 60 - this.bigText.originY;
         this.bigText.angle = 10 + Math.random() * 25;
         this.list.add(this.bigText);
         Text.size = 16;
         this.smallText = new Text(FP.choose("awwww sh*&","totally sweet","F%$# yeah!","wooooooooo",":D :D :D","OMG YES"));
         centerTextOrigin(this.smallText);
         this.smallText.scrollX = this.smallText.scrollY = 0;
         this.smallText.color = this.C_TEXT;
         this.smallText.x = -160;
         this.list.add(this.smallText);
         Text.size = oldSize;
         bd = new BitmapData(384,20,true,4294967295);
         this.stripe1 = new Image(bd);
         this.stripe1.color = this.C_TEXT;
         this.stripe1.originX = 192;
         this.stripe1.originY = 10;
         this.stripe1.scrollX = this.stripe1.scrollY = 0;
         this.stripe1.x = -320;
         this.list.add(this.stripe1);
         this.stripe2 = new Image(bd);
         this.stripe2.color = this.C_TEXT;
         this.stripe2.originX = 192;
         this.stripe2.originY = 10;
         this.stripe2.scrollX = this.stripe2.scrollY = 0;
         this.stripe2.x = -320;
         this.list.add(this.stripe2);
         this.behindPlayer = new Image(Jetpack.ImgBG);
         this.behindPlayer.originX = this.behindPlayer.originY = 12;
         this.behindPlayer.x = player.x - 12;
         this.behindPlayer.y = player.y - 12;
         this.behindPlayer.scale = 2;
         this.behindPlayer.color = this.C_TEXT;
         this.behindPlayer.alpha = 0;
         this.list.add(this.behindPlayer);
      }
      
      override public function update() : void
      {
         if(this.goOut)
         {
            this.bg.alpha = this.bg.alpha - 0.1;
            this.bigText.x = this.bigText.x - Math.max((160 - this.bigText.x) / 5,6);
            if(this.bg.alpha <= 0)
            {
               if(Input.check("jump") && !this.player.onGround)
               {
                  this.player.jetpackJump();
               }
               finish();
            }
         }
         else
         {
            this.bg.alpha = Math.min(this.bg.alpha + 0.1,0.8);
            if(this.bigText.x < 160 - this.bigText.width / 2)
            {
               this.bigText.x = Math.min(this.bigText.x + Math.max((160 - this.bigText.x) / 5,6),160 - this.bigText.width / 2);
            }
            else
            {
               this.bigText.x = this.bigText.x + 0.1;
               this.bigText.y = this.bigText.y + 0.2;
               this.bigText.angle = this.bigText.angle - 0.1;
            }
            this.timer--;
            if(this.timer == 0)
            {
               this.goOut = true;
            }
         }
         FP.angleXY(FP.point,FP.angle(0,0,this.SMALL_ADD_X,this.SMALL_ADD_Y) + this.bigText.angle,FP.distance(0,0,this.SMALL_ADD_X,this.SMALL_ADD_Y));
         this.smallText.x = this.bigText.x + FP.point.x - this.smallText.originX + this.bigText.originX;
         this.smallText.y = this.bigText.y + FP.point.y - this.smallText.originY + this.bigText.originY;
         this.smallText.angle = this.bigText.angle;
         FP.angleXY(FP.point,FP.angle(0,0,this.STRIPE1_ADD_X,this.STRIPE1_ADD_Y) + this.bigText.angle,FP.distance(0,0,this.STRIPE1_ADD_X,this.STRIPE1_ADD_Y));
         this.stripe1.x = this.bigText.x + FP.point.x - this.stripe1.originX + this.bigText.originX;
         this.stripe1.y = this.bigText.y + FP.point.y - this.stripe1.originY + this.bigText.originY;
         this.stripe1.angle = this.bigText.angle;
         FP.angleXY(FP.point,FP.angle(0,0,this.STRIPE2_ADD_X,this.STRIPE2_ADD_Y) + this.bigText.angle,FP.distance(0,0,this.STRIPE2_ADD_X,this.STRIPE2_ADD_Y));
         this.stripe2.x = this.bigText.x + FP.point.x - this.stripe2.originX + this.bigText.originX;
         this.stripe2.y = this.bigText.y + FP.point.y - this.stripe2.originY + this.bigText.originY;
         this.stripe2.angle = this.bigText.angle;
         this.behindPlayer.alpha = this.bg.alpha;
         this.behindPlayer.angle = this.behindPlayer.angle - 2;
      }
   }
}
