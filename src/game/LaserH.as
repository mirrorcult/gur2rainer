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
   
   public class LaserH extends Entity
   {
      
      private static const ImgLaserH:Class = LaserH_ImgLaserH;
      
      public static const ImgLaserPort:Class = LaserH_ImgLaserPort;
       
      
      private var sprite:Spritemap;
      
      private var tempPoint:Point;
      
      private var list:Graphiclist;

      private var _alarm:Alarm;

      public function get timeLeft():Number
      {
         if (_alarm == null) return 0;
         return _alarm.remaining;
      }
      
      public function LaserH(x:int, y:int, width:int, onOff:Boolean, startOff:Boolean)
      {
         var img:Image = null;
         super(x,y);
         type = "fire";
         this.width = width;
         height = 6;
         originY = -5;
         graphic = this.list = new Graphiclist();
         this.sprite = new Spritemap(ImgLaserH,16,16);
         this.sprite.add("go",[0,1,2,3,4,5,6,7],1.4);
         this.sprite.play("go");
         this.list.add(this.sprite);
         if(x != 0)
         {
            img = new Image(ImgLaserPort);
            this.list.add(img);
         }
         if(x + width != (FP.world as Level).width)
         {
            img = new Image(ImgLaserPort);
            img.flipped = true;
            img.x = width - 4;
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
            Main.particles.addParticlesArea("laser",x + 4,y + 2,width - 4,12,Math.floor(width / 6));
         }
         active = false;
      }
      
      override public function render() : void
      {
         var i:int = 0;
         if(this.sprite.visible)
         {
            for(i = x + 16; i < x + width; i = i + 16)
            {
               this.tempPoint.x = i;
               this.tempPoint.y = y;
               this.sprite.render(this.tempPoint,FP.camera);
            }
         }
         super.render();
      }
      
      private function onAlarm() : void
      {
         this.sprite.visible = !this.sprite.visible;
         collidable = !collidable;
         if(x + width > FP.camera.x && y + 16 > FP.camera.y && x < FP.camera.x + 320 && y < FP.camera.y + 240)
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
         Main.particles.addParticlesArea("laser",x + 4,y + 2,width - 4,12,Math.floor(width / 6));
      }
   }
}
