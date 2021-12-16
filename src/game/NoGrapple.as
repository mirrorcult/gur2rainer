package game
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import game.particles.ParticleType;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class NoGrapple extends Block
   {
      
      private static const ImgNoGrapple:Class = NoGrapple_ImgNoGrapple;
       
      
      private const C_DONE:uint = 10845777;
      
      private const C_DONESYM:uint = 7033140;
      
      private const C_ONE:uint = 16756224;
      
      private var block:Image;
      
      private var partType:ParticleType;
      
      private const C_TWO:uint = 16772608;
      
      private var symbol:Image;
      
      private var list:Graphiclist;
      
      public var canGrapple:Boolean = false;
      
      public function NoGrapple(player:Player, x:int, y:int, width:int, height:int)
      {
         super(player,x,y,width,height);
         visible = true;
         active = true;
         type = "danger";
         layer = Main.DEPTH_ACTORS;
         graphic = this.list = new Graphiclist();
         var bd:BitmapData = new BitmapData(width,height,true,4278190080);
         bd.fillRect(new Rectangle(1,1,bd.width - 2,bd.height - 2),4294967295);
         var q:int = Math.floor(bd.height / 4);
         bd.fillRect(new Rectangle(1,bd.height - 1 - q,bd.width - 2,q),4292730333);
         this.list.add(this.block = new Image(bd));
         this.block.originX = this.block.width / 2;
         this.block.originY = this.block.height / 2;
         this.block.color = this.C_ONE;
         this.symbol = new Image(ImgNoGrapple);
         this.symbol.x = width / 2 - 3;
         this.symbol.y = height / 2 - 6;
         this.symbol.originX = 3;
         this.symbol.originY = 4;
         this.list.add(this.symbol);
         this.symbol.color = this.C_TWO;
         addTween(new Alarm(10,this.onAlarm,Tween.LOOPING),true);
         this.partType = Main.particles.getType("coinBlock");
         if(Main.saveData.mode == 0 && Main.saveData.level == 5)
         {
            this.deactivate();
         }
      }
      
      public function hit() : void
      {
         this.symbol.scale = 1.3;
         this.block.scale = 1.3;
         this.partType.direction = 0;
         Main.particles.addParticlesArea("coinBlock",x + width - 2,y + 2,0,height - 4,height / 4);
         this.partType.direction = 90;
         Main.particles.addParticlesArea("coinBlock",x + 2,y + 2,width - 4,0,width / 4);
         this.partType.direction = 180;
         Main.particles.addParticlesArea("coinBlock",x + 2,y + 2,0,height - 4,height / 4);
         this.partType.direction = 270;
         Main.particles.addParticlesArea("coinBlock",x + 2,y + height - 2,width - 4,0,width / 4);
      }
      
      override public function update() : void
      {
         if(this.block.scale > 1)
         {
            this.block.scale = this.symbol.scale = Math.max(1,this.block.scale - 0.02);
         }
      }
      
      public function activate() : void
      {
         type = "danger";
         this.block.color = this.C_ONE;
         this.symbol.color = this.C_TWO;
         addTween(new Alarm(10,this.onAlarm,Tween.LOOPING),true);
         this.canGrapple = false;
      }
      
      private function onAlarm() : void
      {
         if(this.block.color == this.C_ONE)
         {
            this.block.color = this.C_TWO;
            this.symbol.color = this.C_ONE;
         }
         else
         {
            this.block.color = this.C_ONE;
            this.symbol.color = this.C_TWO;
         }
      }
      
      public function deactivate() : void
      {
         type = "solid";
         this.block.color = this.C_DONE;
         this.symbol.color = this.C_DONESYM;
         clearTweens();
         this.canGrapple = true;
      }
   }
}
