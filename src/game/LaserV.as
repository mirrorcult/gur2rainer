package game
{
   import flash.geom.Point;
   import game.engine.Assets;
   import game.engine.Level;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class LaserV extends Entity
   {
      
      private static const ImgLaserV:Class = LaserV_ImgLaserV;
       
      
      private var sprite:Spritemap;
      
      private var tempPoint:Point;
      
      private var list:Graphiclist;

      public var startTime:Number;

      private var _alarm:Alarm;

      public function get timeLeft():Number
      {
         return _alarm.remaining;
      }
      
      public function LaserV(x:int, y:int, height:int, onOff:Boolean, startOff:Boolean)
      {
         var img:Image = null;
         super(x,y);
         type = "fire";
         this.height = height;
         width = 6;
         originX = -5;
         graphic = this.list = new Graphiclist();
         this.sprite = new Spritemap(ImgLaserV,16,16);
         this.sprite.add("go",[0,1,2,3,4,5,6,7],1.4);
         this.sprite.play("go");
         this.list.add(this.sprite);
         if(y != 0)
         {
            img = new Image(LaserH.ImgLaserPort);
            img.angle = 270;
            img.x = 16;
            this.list.add(img);
         }
         if(y + height != (FP.world as Level).height)
         {
            img = new Image(LaserH.ImgLaserPort);
            img.flipped = true;
            img.angle = 270;
            img.y = height - 4;
            img.x = 16;
            this.list.add(img);
         }
         if(onOff)
         {
            _alarm = new Alarm(80, this.onAlarm, Tween.LOOPING);
            addTween(_alarm,true);
         }
         if(startOff)
         {
            this.sprite.visible = false;
            collidable = false;
         }
         this.tempPoint = new Point();
      }
      
      public function deactivate() : void
      {
         if(this.sprite.visible)
         {
            this.sprite.visible = !this.sprite.visible;
            collidable = !collidable;
            Main.particles.addParticlesArea("laser",x + 2,y + 4,12,height - 4,Math.floor(height / 6));
         }
         active = false;
      }
      
      override public function render() : void
      {
         var i:int = 0;
         if(this.sprite.visible)
         {
            for(i = y + 16; i < y + height; i = i + 16)
            {
               this.tempPoint.x = x;
               this.tempPoint.y = i;
               this.sprite.render(this.tempPoint,FP.camera);
            }
         }
         super.render();
      }
      
      private function onAlarm() : void
      {
         this.sprite.visible = !this.sprite.visible;
         collidable = !collidable;
         if(x + 16 > FP.camera.x && y + height > FP.camera.y && x < FP.camera.x + 320 && y < FP.camera.y + 240)
         {
            if(!collidable && !Assets.SndLaserOff.playing && !Assets.SndLaserOn.playing)
            {
               Assets.SndLaserOff.play();
            }
            else if(collidable && !Assets.SndLaserOn.playing)
            {
               Assets.SndLaserOff.stop();
               Assets.SndLaserOn.play();
            }
         }
         Main.particles.addParticlesArea("laser",x + 2,y + 4,12,height - 4,Math.floor(height / 6));
      }
   }
}
