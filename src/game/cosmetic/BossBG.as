package game.cosmetic
{
   import flash.display.BitmapData;
   import game.Boss;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Image;
   
   public class BossBG extends Entity
   {
       
      
      private var list:Graphiclist;
      
      private const KILL:int = 2;
      
      private var bottom:Image;
      
      private var boss:Boss;
      
      private var top:Image;
      
      private var kill:Boolean = false;
      
      public function BossBG(boss:Boss)
      {
         var bd:BitmapData = null;
         super();
         this.boss = boss;
         layer = Main.DEPTH_BGEFFECT;
         graphic = this.list = new Graphiclist();
         bd = new BitmapData(320,120,true,4294901760);
         this.top = new Image(bd);
         this.top.alpha = 0.4;
         this.top.scrollX = this.top.scrollY = 0;
         this.top.y = -120;
         this.list.add(this.top);
         this.bottom = new Image(bd);
         this.bottom.alpha = 0.4;
         this.bottom.scrollX = this.bottom.scrollY = 0;
         this.bottom.y = 240;
         this.list.add(this.bottom);
      }
      
      override public function update() : void
      {
         var move:Number = NaN;
         if(this.kill)
         {
            this.top.y = Math.max(-120,this.top.y - this.KILL);
            this.bottom.y = Math.min(240,this.bottom.y + this.KILL);
            if(this.top.y == -120)
            {
               FP.world.remove(this);
            }
         }
         else
         {
            if(!this.boss.active)
            {
               this.kill = true;
               return;
            }
            move = Math.max(2,-this.top.y / 6);
            if(this.boss.grapple)
            {
               this.top.y = Math.min(0,this.top.y + move);
               this.bottom.y = Math.max(120,this.bottom.y - move);
            }
            else
            {
               this.top.y = Math.max(-120,this.top.y - move);
               this.bottom.y = Math.min(240,this.bottom.y + move);
            }
         }
      }
   }
}
