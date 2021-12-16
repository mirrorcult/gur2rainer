package game.cosmetic
{
   import game.engine.Level;
   import net.flashpunk.graphics.Backdrop;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.graphics.Spritemap;
   
   public class Background1Dead extends Background
   {
       
      
      public function Background1Dead(level:Level)
      {
         var bg:Backdrop = null;
         var img:Image = null;
         var sprite:Spritemap = null;
         var i:int = 0;
         layer = Main.DEPTH_BG;
         graphic = list = new Graphiclist();
         img = new Image(Background1.ImgBG);
         img.scrollX = img.scrollY = 0;
         list.add(img);
         super(level,3355443,30);
         for(i = 0; i < 3; i++)
         {
            sprite = new Spritemap(Background1.ImgGear,24,24);
            sprite.originX = sprite.originY = 12;
            sprite.scrollX = sprite.scrollY = 0;
            sprite.alpha = 0.5;
            sprite.scale = 3;
            sprite.x = 58 + 90 * i;
            sprite.y = 108;
            sprite.color = 2236962;
            sprite.angle = 33 + 66 * i;
            list.add(sprite);
         }
         bg = new Backdrop(Background1.ImgPara1,true,false);
         bg.scrollX = 0.2;
         bg.scrollY = 0.02;
         bg.color = 2236962;
         bg.y = 160;
         list.add(bg);
         bg = new Backdrop(Background1.ImgPara1Flip,true,false);
         bg.scrollX = 0.2;
         bg.scrollY = 0.02;
         bg.color = 2236962;
         bg.y = -48;
         list.add(bg);
         bg = new Backdrop(Background1.ImgPara2,true,false);
         bg.scrollX = 0.4;
         bg.scrollY = 0.04;
         bg.color = 3355443;
         bg.y = 170;
         list.add(bg);
         bg = new Backdrop(Background1.ImgPara2Flip,true,false);
         bg.scrollX = 0.4;
         bg.scrollY = 0.04;
         bg.color = 3355443;
         bg.y = -58;
         list.add(bg);
         bg = new Backdrop(Background1.ImgPara3,true,false);
         bg.scrollX = 0.6;
         bg.scrollY = 0.06;
         bg.color = 4473924;
         bg.y = 180;
         list.add(bg);
         bg = new Backdrop(Background1.ImgPara3Flip,true,false);
         bg.scrollX = 0.6;
         bg.scrollY = 0.06;
         bg.color = 4473924;
         bg.y = -68;
         list.add(bg);
      }
   }
}
