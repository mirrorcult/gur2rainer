package game
{
   import flash.display.BitmapData;
   import game.cosmetic.Flash;
   import game.cosmetic.ScoreTally;
   import game.engine.Assets;
   import game.engine.StartLevel;
   import game.engine.StartUp;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   
   public class Lever extends Block implements StartUp
   {
      
      private static const ImgLever:Class = Lever_ImgLever;
       
      
      private const C_SIT:uint = 16711680;
      
      private var sprite:Spritemap;
      
      private const ACCEL:Number = 0.01;
      
      private const MAX_DOWN:Number = 0.6;
      
      private var doors:Array;
      
      private var image:Image;
      
      private var endY:int;
      
      private const C_SURPRISE:uint = 16776960;
      
      private var controlDoors:Boolean;
      
      private var stayDown:Boolean;
      
      private var vSpeed:Number = 0;
      
      private var distance:int;
      
      private var startY:int;
      
      private const C_SAD:uint = 255;
      
      private const C_HOLD:uint = 16776960;
      
      private const MAX_UP:Number = -1.0;
      
      private const C_DONE:uint = 65280;
      
      public function Lever(player:Player, x:int, y:int, distance:int = 32, stayDown:Boolean = true, controlDoors:Boolean = true)
      {
         var list:Graphiclist = null;
         super(player,x,y,16,16);
         this.distance = distance;
         this.stayDown = stayDown;
         this.controlDoors = controlDoors;
         this.startY = y;
         this.endY = y + distance;
         layer = Main.DEPTH_ACTORS;
         visible = true;
         active = true;
         list = new Graphiclist();
         graphic = list;
         var bd:BitmapData = new BitmapData(4,distance + 12,true,4294967295);
         this.image = new Image(bd);
         this.image.relative = false;
         this.image.x = x + 6;
         this.image.y = y + 2;
         this.image.color = this.C_SIT;
         this.image.alpha = 0.4;
         list.add(this.image);
         this.sprite = new Spritemap(ImgLever,16,16,this.animationEnd);
         this.sprite.add("smile",[0]);
         this.sprite.add("talk",[0,1],0.2);
         this.sprite.add("surprise",[2],0.05);
         this.sprite.add("laugh",[3,4],0.1);
         this.sprite.add("sad",[5]);
         this.sprite.add("dead",[6]);
         this.sprite.play("smile");
         list.add(this.sprite);
      }
      
      private function animationEnd() : void
      {
         if(this.sprite.currentAnim == "surprise")
         {
            this.sprite.play("laugh");
            this.image.color = this.C_HOLD;
         }
      }
      
      override public function update() : void
      {
         var percent:Number = NaN;
         var i:int = 0;
         if(grapple)
         {
            if(player.onGround)
            {
               this.vSpeed = 0;
            }
            else
            {
               this.vSpeed = Math.min(this.vSpeed + this.ACCEL,this.MAX_DOWN,this.endY - y);
            }
         }
         else
         {
            this.vSpeed = Math.max(this.vSpeed - this.ACCEL,this.MAX_UP,this.startY - y);
         }
         moveV(this.vSpeed);
         if(this.vSpeed != 0 && this.controlDoors)
         {
            percent = (y - this.startY) / Number(this.distance);
            for(i = 0; i < this.doors.length; i++)
            {
               this.doors[i].setState(percent,this.vSpeed < 0);
            }
         }
         if(this.vSpeed > 0 && y >= this.endY)
         {
            shake = 10;
            y = this.endY;
            this.vSpeed = 0;
            if(this.stayDown)
            {
               this.sprite.play("dead");
               this.image.color = this.C_DONE;
               active = false;
               if(FP.world is StartLevel)
               {
                  this.doTally();
               }
               else
               {
                  Assets.SndLeverBottom.play();
               }
            }
            else
            {
               Assets.SndLeverBottom.play();
            }
         }
         else if(this.vSpeed < 0 && y <= this.startY)
         {
            Assets.SndLeverTop.play();
            shake = 10;
            y = this.startY;
            this.vSpeed = 0;
         }
      }
      
      public function startUp() : void
      {
         if(!this.controlDoors)
         {
            return;
         }
         this.doors = new Array();
         FP.world.getClass(Door,this.doors);
      }
      
      private function doTally() : void
      {
         if(grapple)
         {
            grapple.destroy(false);
         }
         Main.screenShake(1);
         FP.world.remove(this);
         FP.world.add(new Flash());
         FP.world.add(new ScoreTally());
         this.doors = new Array();
         FP.world.getClass(Door,this.doors);
         for(var i:int = 0; i < this.doors.length; i++)
         {
            this.doors[i].open();
         }
         FP.world.add(new SubmitLever(player,248,64,SubmitLever.MODE_ADULTSWIM));
         FP.world.add(new SubmitLever(player,40,64,SubmitLever.MODE_TWITTER));
         FP.world.add(new SubmitLever(player,72,64,SubmitLever.MODE_FACEBOOK));
         Assets.SndShowScore.play();
         if(Main.saveData.level >= 41)
         {
            Assets.setMusic(Assets.MusWorld3);
         }
         else
         {
            Assets.setMusic(Assets.MusWorld2);
         }
      }
      
      override public function onRelease() : void
      {
         if(active)
         {
            this.sprite.play("sad");
            this.image.color = this.C_SAD;
         }
      }
      
      override public function onGrapple() : void
      {
         if(active)
         {
            shake = 10;
            this.sprite.play("surprise");
            this.image.color = this.C_SURPRISE;
         }
      }
   }
}
