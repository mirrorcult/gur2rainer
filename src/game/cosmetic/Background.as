package game.cosmetic
{
   import game.engine.EndLevel;
   import game.engine.Level;
   import game.engine.StartLevel;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Text;
   
   public class Background extends Entity
   {
       
      
      protected var level:Level;
      
      protected var list:Graphiclist;
      
      public function Background(level:Level, color:uint, addY:int = 0, alpha:Number = 0.5)
      {
         var str:String = null;
         var text:Text = null;
         super();
         this.level = level;
         if(FP.world is EndLevel || FP.world is StartLevel || level.levelNum == 61)
         {
            return;
         }
         if(level.levelNum == 0 && level.custom)
         {
            str = "Custom Level";
         }
         else
         {
            str = (Main.saveData.mode == 0?"Level ":"Hard ") + Main.saveData.level;
         }
         text = new Text(str,20,20 + addY,280,200);
         text.scrollY = 0;
         text.scrollX = 0;
         text.size = 40;
         text.color = color;
         text.alpha = alpha;
         this.list.add(text);
      }
   }
}
