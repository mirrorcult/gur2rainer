package game.cosmetic
{
   import flash.geom.Rectangle;
   import game.engine.Level;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Backdrop;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class Background3 extends Background
   {
      
      private static const ImgCity1:Class = Background3_ImgCity1;
      
      private static const ImgRay:Class = Background3_ImgRay;
      
      private static const ImgCars:Class = Background3_ImgCars;
      
      private static const ImgCity2:Class = Background3_ImgCity2;
      
      private static const ImgBridge:Class = Background3_ImgBridge;
      
      private static const ImgSky:Class = Background3_ImgSky;
       
      
      private var carWidth:Number;
      
      private const CARS:int = 6;
      
      private const RAYS:int = 15;
      
      private var rays:Vector.<Image>;
      
      private var carAlarm:Alarm;
      
      private var cars:Vector.<Image>;
      
      public function Background3(level:Level)
      {
         var i:int = 0;
         var bg:Backdrop = null;
         var img:Image = null;
         layer = Main.DEPTH_BG;
         graphic = list = new Graphiclist();
         img = new Image(ImgSky);
         img.scrollX = img.scrollY = 0;
         list.add(img);
         super(level,16777215,0,0.1);
         this.rays = new Vector.<Image>(this.RAYS);
         for(i = 0; i < this.RAYS; i++)
         {
            this.rays[i] = new Image(ImgRay);
            this.rays[i].x = 160;
            this.rays[i].y = 240;
            this.rays[i].originY = 16;
            this.rays[i].scrollX = 0;
            this.rays[i].scrollY = 0;
            this.rays[i].alpha = 0.1;
            this.rays[i].angle = 180 / this.RAYS * i;
            list.add(this.rays[i]);
         }
         bg = new Backdrop(ImgCity2,true,false);
         bg.scrollX = 0.2;
         bg.scrollY = 0.05;
         bg.y = 170;
         list.add(bg);
         bg = new Backdrop(ImgCity1,true,false);
         bg.scrollX = 0.4;
         bg.scrollY = 0.1;
         bg.y = 185;
         list.add(bg);
         this.cars = new Vector.<Image>(this.CARS);
         this.carWidth = 320 + (level.width - 320) * 0.6;
         for(i = 0; i < this.CARS; i++)
         {
            this.cars[i] = new Image(ImgCars,new Rectangle(i % 2 * 8,0,8,5));
            this.cars[i].y = 217;
            this.cars[i].scrollX = 0.6;
            this.cars[i].scrollY = 0.05;
            this.cars[i].x = 20 + Math.random() * (this.carWidth - 40);
            this.cars[i].flipped = FP.choose(true,false);
            list.add(this.cars[i]);
         }
         addTween(this.carAlarm = new Alarm(60,this.makeCar,Tween.PERSIST),true);
         bg = new Backdrop(ImgBridge,true,false);
         bg.scrollX = 0.6;
         bg.scrollY = 0.05;
         bg.y = 220;
         list.add(bg);
      }
      
      private function makeCar() : void
      {
         this.carAlarm.reset(30 + Math.random() * 80);
         this.carAlarm.start();
         var car:Image = null;
         for(var i:int = 0; i < this.cars.length; i++)
         {
            if(!this.cars[i].visible)
            {
               car = this.cars[i];
               break;
            }
         }
         if(car == null)
         {
            return;
         }
         car.visible = true;
         car.flipped = FP.choose(true,false);
         car.x = !!car.flipped?Number(this.carWidth + 5):Number(-5);
      }
      
      override public function update() : void
      {
         var i:int = 0;
         var spd:Number = level.player.grapple != null?Number(0.8):Number(0.4);
         for(i = 0; i < this.rays.length; i++)
         {
            this.rays[i].angle = (this.rays[i].angle + spd) % 180;
         }
         for(i = 0; i < this.cars.length; i++)
         {
            if(this.cars[i].visible)
            {
               this.cars[i].x = this.cars[i].x + (!!this.cars[i].flipped?-0.8:0.8);
               if(this.cars[i].x < -5 || this.cars[i].x > this.carWidth + 5)
               {
                  this.cars[i].visible = false;
               }
            }
         }
      }
   }
}
