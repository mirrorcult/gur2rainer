package game.cosmetic
{
   import game.engine.Level;
   import net.flashpunk.graphics.*;
   
   public class Background2 extends Background
   {
      
      private static const ImgLand1:Class = Background2_ImgLand1;
      
      private static const ImgLand2:Class = Background2_ImgLand2;
      
      private static const ImgRay:Class = Background2_ImgRay;
      
      private static const ImgSun:Class = Background2_ImgSun;
      
      private static const ImgMountains2:Class = Background2_ImgMountains2;
      
      private static const ImgMountains1:Class = Background2_ImgMountains1;
      
      private static const ImgSky:Class = Background2_ImgSky;
       
      
      private const SUN_X:int = 190;
      
      private const SUN_Y:int = 150;
      
      private var rays:Vector.<Spritemap>;
      
      public function Background2(level:Level)
      {
         var bg:Backdrop = null;
         var img:Image = null;
         var sprite:Spritemap = null;
         var i:int = 0;
         layer = Main.DEPTH_BG;
         graphic = list = new Graphiclist();
         img = new Image(ImgSky);
         img.scrollX = img.scrollY = 0;
         list.add(img);
         super(level,16777215,0,0.2);
         sprite = new Spritemap(ImgSun,24,24);
         sprite.scrollX = sprite.scrollY = 0;
         sprite.scale = 4;
         sprite.x = this.SUN_X - 48;
         sprite.y = this.SUN_Y - 48;
         list.add(sprite);
         this.rays = new Vector.<Spritemap>();
         for(i = 0; i < 4; i++)
         {
            sprite = new Spritemap(ImgRay,32,8);
            sprite.scrollX = sprite.scrollY = 0;
            sprite.originY = 4;
            sprite.x = this.SUN_X;
            sprite.y = this.SUN_Y;
            sprite.scale = 8;
            sprite.angle = 90 * i;
            this.rays.push(sprite);
            list.add(sprite);
         }
         bg = new Backdrop(ImgMountains1,true,false);
         bg.scrollX = 0.1;
         bg.scrollY = 0.02;
         bg.x = 12;
         bg.y = 120;
         list.add(bg);
         bg = new Backdrop(ImgMountains2,true,false);
         bg.relative = false;
         bg.scrollX = 0.2;
         bg.scrollY = 0.04;
         bg.y = 120;
         list.add(bg);
         bg = new Backdrop(ImgLand1,true,false);
         bg.scrollX = 0.4;
         bg.scrollY = 0.2;
         bg.y = 155;
         list.add(bg);
         bg = new Backdrop(ImgLand2,true,false);
         bg.scrollX = 0.6;
         bg.scrollY = 0.3;
         bg.y = 150;
         list.add(bg);
      }
      
      override public function update() : void
      {
         for(var i:int = 0; i < 4; i++)
         {
            this.rays[i].angle = this.rays[i].angle - 0.5;
         }
      }
   }
}
