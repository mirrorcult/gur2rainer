package game
{
   import game.cosmetic.GotCoin;
   import game.engine.Assets;
   import game.particles.ParticleType;
   import net.flashpunk.FP;
   import net.flashpunk.graphics.Spritemap;
   
   public class CoinBlock extends Block
   {
      
      private static const ImgCoinBlock:Class = CoinBlock_ImgCoinBlock;
       
      
      private var coins:uint;
      
      private var sprite:Spritemap;
      
      private const SHAKE:uint = 4;
      
      private var timer:uint = 0;
      
      private var turnOff:Boolean = false;
      
      private const COIN_INTERVAL:uint = 20;
      
      public function CoinBlock(player:Player, x:int, y:int, coins:uint)
      {
         super(player,x,y,16,16);
         this.coins = coins;
         layer = Main.DEPTH_ACTORS;
         graphic = this.sprite = new Spritemap(ImgCoinBlock,16,16);
         this.sprite.add("full",[0]);
         this.sprite.add("give",[1,2,1,2,0],0.15,false);
         this.sprite.add("empty",[1,2,3],0.15,false);
         this.sprite.play("full");
         this.sprite.originX = 8;
         this.sprite.originY = 8;
         active = true;
         visible = true;
      }
      
      override public function update() : void
      {
         if(this.sprite.scale > 1)
         {
            this.sprite.scale = Math.max(1,this.sprite.scale - 0.05);
         }
         if(this.turnOff)
         {
            if(this.sprite.scale == 1)
            {
               active = false;
            }
            return;
         }
         if(this.timer == 0)
         {
            if(player && player.grapple && player.grapple.latched == this)
            {
               this.cashOut();
            }
         }
         else
         {
            this.timer--;
         }
      }
      
      private function cashOut() : void
      {
         shake = this.SHAKE;
         player.collectCoin();
         this.coins--;
         if(this.coins == 0)
         {
            this.sprite.play("empty");
            this.sprite.scale = 2;
            this.turnOff = true;
            Assets.SndCoinBlockDone.play();
            Main.screenShake(1);
         }
         else
         {
            this.sprite.play("give",true);
            this.sprite.scale = 1.5;
            this.timer = this.COIN_INTERVAL;
            Assets.SndCoinBlock.play();
            Main.screenShake(0);
         }
         FP.world.add(new GotCoin(x + 8,y + 4));
         var type:ParticleType = Main.particles.getType("coinBlock");
         type.direction = 0;
         Main.particles.addParticlesArea("coinBlock",x + 14,y + 2,0,12,4);
         type.direction = 90;
         Main.particles.addParticlesArea("coinBlock",x + 2,y + 2,12,0,4);
         type.direction = 180;
         Main.particles.addParticlesArea("coinBlock",x + 2,y + 2,0,12,4);
         type.direction = 270;
         Main.particles.addParticlesArea("coinBlock",x + 2,y + 14,12,0,4);
      }
   }
}
