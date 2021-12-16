package game.engine
{
   import game.EdgeBlock;
   import game.cosmetic.BGKey;
   import game.cosmetic.PlayerFly;
   import net.flashpunk.Tween;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class StartLevel extends Level
   {
       
      
      public function StartLevel(num:uint)
      {
         super(0,num);
      }
      
      override protected function specifics() : void
      {
         player.y = -6;
         player.vSpeed = player.MAX_FALL;
         add(new PlayerFly(480,250,true));
         addTween(new Alarm(120,this.makePlayer,Tween.ONESHOT),true);
         addTween(new Alarm(150,this.makeRoof,Tween.ONESHOT),true);
         addTween(new Alarm(240,this.makeBG,Tween.ONESHOT),true);
      }
      
      private function makeRoof() : void
      {
         add(new EdgeBlock(0,-8,width,8));
      }
      
      private function makeBG() : void
      {
         add(new BGKey(-24,150));
      }
      
      override protected function loadLevel(mode:uint, num:uint) : void
      {
         var world:uint = 0;
         if(num >= WORLD3)
         {
            world = 3;
         }
         else if(num >= WORLD2)
         {
            world = 2;
         }
         load(new Assets["S" + world]());
         countTime = false;
      }
      
      private function makePlayer() : void
      {
         spawn();
      }
   }
}
