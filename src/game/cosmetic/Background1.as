package game.cosmetic
{
   import game.engine.Level;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Backdrop;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Spritemap;
   
   public class Background1 extends Background
   {
      
      public static const ImgBG:Class = Background1_ImgBG;
      
      public static const ImgPara1:Class = Background1_ImgPara1;
      
      public static const ImgPara2:Class = Background1_ImgPara2;
      
      public static const ImgGear:Class = Background1_ImgGear;
      
      public static const ImgPara3:Class = Background1_ImgPara3;
      
      public static const ImgPara1Flip:Class = Background1_ImgPara1Flip;
      
      public static const ImgPara2Flip:Class = Background1_ImgPara2Flip;
      
      public static const ImgPara3Flip:Class = Background1_ImgPara3Flip;
       
      
      private var para3flip:Backdrop;
      
      private var gears:Vector.<Spritemap>;
      
      private var bg:Backdrop;
      
      private var para1:Backdrop;
      
      private var para2:Backdrop;
      
      private var para3:Backdrop;
      
      private var blen:Number = 0;
      
      private var para1flip:Backdrop;
      
      private var para2flip:Backdrop;
      
      public function Background1(level:Level)
      {
         var sprite:Spritemap = null;
         layer = Main.DEPTH_BG;
         graphic = list = new Graphiclist();
         this.bg = new Backdrop(ImgBG);
         this.bg.scrollX = this.bg.scrollY = 0;
         list.add(this.bg);
         super(level,12303291,30,0.1);
         this.gears = new Vector.<Spritemap>(3);
         for(var i:int = 0; i < 3; i++)
         {
            sprite = new Spritemap(ImgGear,24,24);
            sprite.add("go",[0,2,3,3,3,3,3,0,0],0.4);
            sprite.play("go");
            sprite.originX = sprite.originY = 12;
            sprite.scrollX = sprite.scrollY = 0;
            sprite.alpha = 0.6;
            sprite.scale = 3;
            sprite.x = 58 + 90 * i;
            sprite.y = 108;
            sprite.color = 3355443;
            sprite.angle = 33 + 66 * i;
            list.add(sprite);
            this.gears[i] = sprite;
         }
         this.para1 = new Backdrop(ImgPara1,true,false);
         this.para1.scrollX = 0.2;
         this.para1.scrollY = 0.02;
         this.para1.y = 160;
         list.add(this.para1);
         this.para1flip = new Backdrop(ImgPara1Flip,true,false);
         this.para1flip.scrollX = 0.2;
         this.para1flip.scrollY = 0.02;
         this.para1flip.y = -48;
         list.add(this.para1flip);
         this.para2 = new Backdrop(ImgPara2,true,false);
         this.para2.scrollX = 0.4;
         this.para2.scrollY = 0.04;
         this.para2.y = 170;
         list.add(this.para2);
         this.para2flip = new Backdrop(ImgPara2Flip,true,false);
         this.para2flip.scrollX = 0.4;
         this.para2flip.scrollY = 0.04;
         this.para2flip.y = -58;
         list.add(this.para2flip);
         this.para3 = new Backdrop(ImgPara3,true,false);
         this.para3.scrollX = 0.6;
         this.para3.scrollY = 0.06;
         this.para3.y = 180;
         list.add(this.para3);
         this.para3flip = new Backdrop(ImgPara3Flip,true,false);
         this.para3flip.scrollX = 0.6;
         this.para3flip.scrollY = 0.06;
         this.para3flip.y = -68;
         list.add(this.para3flip);
      }
      
      override public function update() : void
      {
         this.blen = (this.blen + Math.PI / 16) % (Math.PI * 4);
         var sine:Number = Math.sin(this.blen);
         var sine2:Number = Math.sin(this.blen + Math.PI * 2 / 3);
         var sine3:Number = Math.sin(this.blen + Math.PI * 4 / 3);
         this.bg.y--;
         this.bg.x--;
         if(this.bg.x <= -8)
         {
            this.bg.x = this.bg.x + 8;
            this.bg.y = this.bg.y + 8;
         }
         this.bg.color = FP.getColorRGB(255 - (sine + 1) * 60,255 - (sine2 + 1) * 60,255 - (sine3 + 1) * 60);
         this.para1.color = this.para1flip.color = FP.getColorRGB(120 - (sine + 1) * 30,120 - (sine2 + 1) * 30,120 - (sine3 + 1) * 30);
         this.para2.color = this.para2flip.color = FP.getColorRGB(120 - (sine + 1) * 30,120 - (sine2 + 1) * 30,120 - (sine3 + 1) * 30);
         this.para3.color = this.para3flip.color = FP.getColorRGB(130 - (sine + 1) * 30,130 - (sine2 + 1) * 30,130 - (sine3 + 1) * 30);
         this.para1.y = 160 + sine * 4;
         this.para1flip.y = -48 + sine * 4;
         this.para2.y = 170 + sine2 * 4;
         this.para2flip.y = -58 + sine2 * 4;
         this.para3.y = 180 + sine3 * 4;
         this.para3flip.y = -68 + sine3 * 4;
         for(var i:int = 0; i < 3; i++)
         {
            this.gears[i].color = FP.getColorRGB(90 - (sine + 1) * 20,90 - (sine2 + 1) * 20,90 - (sine3 + 1) * 20);
            this.gears[i].angle = this.gears[i].angle + 0.5;
         }
      }
   }
}
