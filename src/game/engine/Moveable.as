package game.engine
{
   import game.Block;
   import net.flashpunk.Entity;
   
   public class Moveable extends Entity
   {
       
      
      private var hCounter:Number = 0;
      
      private var vCounter:Number = 0;
      
      public function Moveable(x:int, y:int)
      {
         super(x,y);
      }
      
      public function moveV(num:Number, onCollide:Function = null) : Boolean
      {
         var go:int = 0;
         var s:Entity = null;
         this.vCounter = this.vCounter + num;
         go = Math.round(this.vCounter);
         this.vCounter = this.vCounter - go;
         var sign:int = go > 0?1:-1;
         while(go != 0)
         {
            if((s = collide("solid",x,y + sign)) != null)
            {
               if(onCollide != null)
               {
                  onCollide(s as Block);
               }
               return false;
            }
            y = y + sign;
            go = go - sign;
         }
         return true;
      }
      
      public function moveH(num:Number, onCollide:Function = null) : Boolean
      {
         var s:Entity = null;
         this.hCounter = this.hCounter + num;
         var go:int = Math.round(this.hCounter);
         this.hCounter = this.hCounter - go;
         var sign:int = go > 0?1:-1;
         while(go != 0)
         {
            if((s = collide("solid",x + sign,y)) != null)
            {
               if(onCollide != null)
               {
                  onCollide(s as Block);
               }
               return false;
            }
            x = x + sign;
            go = go - sign;
         }
         return true;
      }
      
      protected function getBelow() : Block
      {
         var obj:Entity = null;
         if((obj = collide("solid",x,y + 1)) != null)
         {
            return obj as Block;
         }
         return null;
      }
   }
}
