package game.cosmetic
{
   import game.SubmitLever;
   import game.engine.Assets;
   import game.menus.ImageButton;
   import game.menus.MenuButton;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Text;
   
   public class FinalScoreTally extends Entity
   {
       
      
      private var win:YouWin;
      
      private var list:Graphiclist;
      
      private const C_TEXT:uint = 16777215;
      
      private var sine:Number = 0;
      
      private const C_SCORE:uint = 16776960;
      
      private var scoreText:Text;
      
      public function FinalScoreTally(win:YouWin, x:int, y:int)
      {
         var oldSize:int = 0;
         var text:Text = null;
         super(x,y);
         this.win = win;
         graphic = this.list = new Graphiclist();
         oldSize = Text.size;
         Text.size = 16;
         text = new Text("Score:",160,92);
         text.color = this.C_TEXT;
         text.alpha = 0.8;
         text.centerOO();
         this.list.add(text);
         Text.size = 32;
         this.scoreText = new Text(String(Main.saveData.getScoreString()),160,112);
         this.scoreText.color = this.C_SCORE;
         this.scoreText.centerOO();
         this.list.add(this.scoreText);
         Text.size = oldSize;
         FP.world.add(new MenuButton(x + 160,226,"Done",win.done,Assets.SndMenuCancel));
         FP.world.add(new ImageButton(x + 110,160,SubmitLever.ImgTwitter,"Post score to Twitter!",Main.submitTwitter));
         FP.world.add(new ImageButton(x + 160,160,SubmitLever.ImgFacebook,"Share with Facebook!",Main.submitFacebook));
         FP.world.add(new ImageButton(x + 210,160,SubmitLever.ImgAdultSwim,"Play more awesome games!",function():void
         {
            Main.link("endofgame");
         }));
      }
      
      override public function update() : void
      {
         this.sine = (this.sine + Math.PI / 128) % (Math.PI * 4);
         this.scoreText.angle = Math.sin(this.sine) * 6;
      }
   }
}
