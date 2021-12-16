package game.cosmetic
{
   import game.engine.Level;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Tilemap;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class Tiles1 extends Tiler
   {
      
      private static const ImgTiles2:Class = Tiles1_ImgTiles2;
      
      private static const ImgTiles1:Class = Tiles1_ImgTiles1;
       
      
      private var timer:Alarm;
      
      private var t1:Tilemap;
      
      private var t2:Tilemap;
      
      public function Tiles1(level:Level)
      {
         this.timer = new Alarm(10,this.tick,Tween.LOOPING);
         this.t1 = new Tilemap(ImgTiles1,level.width,level.height,4,4);
         this.t2 = new Tilemap(ImgTiles2,level.width,level.height,4,4);
         super(level,this.setTile);
         addTween(this.timer,true);
         var list:Graphiclist = new Graphiclist();
         list.add(this.t1);
         list.add(this.t2);
         graphic = list;
         this.t2.visible = false;
      }
      
      private function setTile(row:uint, col:uint, id:uint) : void
      {
         this.t1.setTile(row,col,id);
         this.t2.setTile(row,col,id);
      }
      
      private function tick() : void
      {
         this.t1.visible = !this.t1.visible;
         this.t2.visible = !this.t2.visible;
      }
   }
}
