package game
{
   import net.flashpunk.Entity;
   
   public class EdgeBlock extends Entity
   {
       
      
      public function EdgeBlock(x:int, y:int, width:int, height:int)
      {
         super(x,y);
         this.width = width;
         this.height = height;
         type = "solid";
         visible = false;
         active = false;
      }
   }
}
