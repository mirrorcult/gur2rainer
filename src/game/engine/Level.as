package game.engine
{
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import game.Boss;
   import game.BossChase;
   import game.Cloud;
   import game.Coin;
   import game.CoinBlock;
   import game.Conveyor;
   import game.CrackedBlock;
   import game.Door;
   import game.EdgeBlock;
   import game.FallingBlock;
   import game.FireBall;
   import game.FlipBlock;
   import game.GiantLever;
   import game.Jetpack;
   import game.LaserH;
   import game.LaserV;
   import game.LastKey;
   import game.Launcher;
   import game.Lever;
   import game.Mine;
   import game.MovingPlat;
   import game.NoGrapple;
   import game.NumBlock;
   import game.Options;
   import game.Player;
   import game.Rebound;
   import game.Saw;
   import game.WarpBlock;
   import game.cosmetic.Background;
   import game.cosmetic.Background1;
   import game.cosmetic.Background1Dead;
   import game.cosmetic.Background2;
   import game.cosmetic.Background3;
   import game.cosmetic.BackgroundHard;
   import game.cosmetic.BossBG;
   import game.cosmetic.DrawCoins;
   import game.cosmetic.DrawTime;
   import game.cosmetic.FakeKey;
   import game.cosmetic.Tiler;
   import game.cosmetic.Tiles1;
   import game.cosmetic.Tiles1Dead;
   import game.cosmetic.Tiles2;
   import game.cosmetic.Tiles3;
   import game.cosmetic.TilesHard;
   import game.cosmetic.Transition;
   import game.menus.MainMenu;
   import game.menus.TASWatermark;
   import game.tutorial.Tutorial1;
   import game.tutorial.Tutorial2;
   import game.tutorial.Tutorial3;
   import game.tutorial.Tutorial4;
   import game.tutorial.Tutorial5;
   import game.tutorial.TutorialHard;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.tweens.misc.Alarm;
   import net.flashpunk.utils.Input;
   import net.flashpunk.utils.Key;
   
   public class Level extends MattWorld
   {
      
      public static const WORLD2:int = 21;
      
      public static const WORLD3:int = 41;
      
      public static const WORLD1:int = 6;
       
      
      public var tiles:Tiler;
      
      public var width:uint;
      
      public var blocks:Blocks;
      
      public var time:uint;
      
      public var xml:XML;
      
      public var drawCoins:DrawCoins;
      
      public var player:Player;
      
      public var mode:uint;
      
      public var attempt:int = 0;
      
      public var height:uint;
      
      public var background:Background;
      
      public var custom:Boolean;
      
      private var drawTime:DrawTime;
      
      public var levelNum:uint;
      
      public var practice:Boolean;
      
      public var countTime:Boolean;

      public var tasWatermark:TASWatermark;
      
      public function Level(mode:uint, num:uint, alwaysPractice:Boolean = false, str:String = null)
      {
         super();
         this.mode = mode;
         this.levelNum = num;
         this.practice = Options.practiceMode || alwaysPractice;
         this.custom = false;
         if(str == null)
         {
            this.loadLevel(mode,num);
         }
         else
         {
            this.custom = true;
            this.loadFromString(str);
         }
      }
      
      protected function specifics() : void
      {
         var bb:Boss = null;
         var boss:BossChase = null;
         if(this.mode == 0)
         {
            if(this.levelNum == 1)
            {
               this.countTime = false;
               add(new Tutorial1(this.player));
            }
            else if(this.levelNum == 2)
            {
               add(new Tutorial2(this.player));
            }
            else if(this.levelNum == 3)
            {
               add(new Tutorial3(this.player));
            }
            else if(this.levelNum == 4)
            {
               add(new Tutorial4(this.player));
            }
            else if(this.levelNum == 5)
            {
               add(new Tutorial5(this.player));
               this.player.cameraOffsetY = -90;
               add(new GiantLever(this.player,128,40,new Background1(this),new Tiles1(this)));
            }
            else if(this.levelNum == 20 || this.levelNum == 40 || this.levelNum == 60)
            {
               bb = new Boss(this.player,256,32,this.levelNum / 20 - 1);
               add(bb);
               add(new BossBG(bb));
               this.player.cameraOffsetY = -32;
            }
            else if(this.levelNum == 61)
            {
               add(new FakeKey(this.player,216,96));
               add(boss = new BossChase(this.player));
               add(new LastKey(this.player,boss,3128,64));
            }
         }
         else if(this.levelNum == 1 && this.attempt == 1)
         {
            add(new TutorialHard(this.player));
         }
         else if(this.levelNum == 11 || this.levelNum == 12)
         {
            add(new BossChase(this.player));
         }
      }
      
      public function setTheme(tiles:Tiler, bg:Background) : void
      {
         remove(this.tiles);
         remove(this.background);
         this.tiles = tiles;
         this.background = bg;
         add(tiles);
         add(bg);
      }
      
      override public function update() : void
      {
         super.update();

         if(this.player && this.player.active && this.countTime)
         {
            this.time++;
            if(this.drawTime)
            {
               this.drawTime.updateTotal();
            }
         }
         if(Input.pressed("return"))
         {
            Assets.MusPowerOn.stop();
            add(new Transition(new MainMenu()));
         }

         if ((FP.world as MattWorld).changing) return;

         if(Input.pressed("next"))
         {
            Assets.MusPowerOn.stop();
            if (levelExists(mode, levelNum + 1)) 
            {
               Main.saveData.advanceLevels(player.coins, time, 1);
               add(new Transition(Main.getLevel()));
            }
         }
         if(Input.pressed("back"))
         {
            Assets.MusPowerOn.stop();
            if (levelExists(mode, levelNum - 1))
            {
               Main.saveData.advanceLevels(0, 0, -1);
               add(new Transition(Main.getLevel()));
            }
         }
      }
      
      public function restart(transition:Transition = null) : void
      {
         var o:XML = null;
         var oo:XML = null;
         var s:StartUp = null;
         var saw:Saw = null;
         var go:Vector.<Point> = null;
         this.attempt++;
         this.countTime = true;
         var world:int = 0;
         if(this.levelNum >= WORLD3)
         {
            world = 3;
         }
         else if(this.levelNum >= WORLD2)
         {
            world = 2;
         }
         else if(this.levelNum >= WORLD1)
         {
            world = 1;
         }
         if(this is EndLevel)
         {
            world--;
         }
         if(this.practice)
         {
            Main.saveData.coins = 0;
            Main.saveData.time = 0;
         }
         this.time = 0;
         removeAll();
         if(transition != null)
         {
            add(transition);
         }
         this.width = this.xml.width[0];
         this.height = this.xml.height[0];
         for each(o in this.xml.objects[0].player)
         {
            add(this.player = new Player(this,o.@x,o.@y));
         }
         if(this.attempt == 1)
         {
            this.blocks = new Blocks(this.player,this);
            for each(o in this.xml.solids[0].rect)
            {
               this.blocks.grid.setRect(int(o.@x) / 8,int(o.@y) / 8,int(o.@w) / 8,int(o.@h) / 8);
            }
         }
         add(this.blocks);
         if(this.attempt == 1)
         {
            this.initTiles(world);
            this.initBackground(world);
         }
         else
         {
            add(this.tiles);
            add(this.background);
         }
         this.specifics();
         for each(o in this.xml.objects[0].saw)
         {
            add(saw = new Saw(o.@x,o.@y,o.@flip == "false"?-1:1));
            if(o.node.length() > 0)
            {
               saw.setMotion(o.node[0].@x,o.node[0].@y,o.@speed,o.@dontMove == "true",o.@stopAtEnd == "true");
            }
         }
         for each(o in this.xml.objects[0].fireBall)
         {
            add(new FireBall(o.@x,o.@y));
         }
         for each(o in this.xml.objects[0].launcher)
         {
            add(new Launcher(this.player,o.@x,o.@y,o.@angle * -1));
         }
         for each(o in this.xml.objects[0].laserH)
         {
            add(new LaserH(o.@x,o.@y,o.@width,o.@onOff == "true",o.@startOff == "true"));
         }
         for each(o in this.xml.objects[0].laserV)
         {
            add(new LaserV(o.@x,o.@y,o.@height,o.@onOff == "true",o.@startOff == "true"));
         }
         for each(o in this.xml.objects[0].cloud)
         {
            add(new Cloud(this.player,o.@x,o.@y));
         }
         for each(o in this.xml.objects[0].coin)
         {
            add(new Coin(o.@x,o.@y));
         }
         for each(o in this.xml.objects[0].jetpack)
         {
            add(new Jetpack(o.@x,o.@y));
         }
         for each(o in this.xml.objects[0].coinBlock)
         {
            add(new CoinBlock(this.player,o.@x,o.@y,o.@coins));
         }
         for each(o in this.xml.objects[0].crackedBlock)
         {
            add(new CrackedBlock(this.player,o.@x,o.@y));
         }
         for each(o in this.xml.objects[0].movingPlat)
         {
            add(new MovingPlat(this.player,o.@x,o.@y,o.@width,o.@height,o.node[0].@x,o.node[0].@y,o.@speed,o.@dontMove == "true",o.@stopAtEnd == "true"));
         }
         for each(o in this.xml.objects[0].fallingPlat)
         {
            add(new FallingBlock(this.player,o.@x,o.@y,o.@width,o.@height));
         }
         for each(o in this.xml.objects[0].lever)
         {
            add(new Lever(this.player,o.@x,o.@y,o.@distance,o.@stayDown == "true",o.@controlDoors == "true"));
         }
         for each(o in this.xml.objects[0].door)
         {
            add(new Door(this.player,o.@x,o.@y));
         }
         for each(o in this.xml.objects[0].numBlock)
         {
            add(new NumBlock(this.player,o.@x,o.@y,o.@num));
         }
         for each(o in this.xml.objects[0].mine)
         {
            add(new Mine(this.player,o.@x,o.@y));
         }
         for each(o in this.xml.objects[0].noGrapple)
         {
            add(new NoGrapple(this.player,o.@x,o.@y,o.@width,o.@height));
         }
         for each(o in this.xml.objects[0].flipBlock)
         {
            add(new FlipBlock(this.player,o.@x,o.@y));
         }
         for each(o in this.xml.objects[0].conveyor0)
         {
            add(new Conveyor(this.player,o.@x,o.@y,o.@width,o.@height,0,o.@speed));
         }
         for each(o in this.xml.objects[0].conveyor90)
         {
            add(new Conveyor(this.player,o.@x,o.@y,o.@width,o.@height,90,o.@speed));
         }
         for each(o in this.xml.objects[0].conveyor180)
         {
            add(new Conveyor(this.player,o.@x,o.@y,o.@width,o.@height,180,o.@speed));
         }
         for each(o in this.xml.objects[0].conveyor270)
         {
            add(new Conveyor(this.player,o.@x,o.@y,o.@width,o.@height,270,o.@speed));
         }
         for each(o in this.xml.objects[0].warpBlock)
         {
            go = new Vector.<Point>();
            for each(oo in o.node)
            {
               go.push(new Point(oo.@x,oo.@y));
            }
            add(new WarpBlock(this.player,o.@x,o.@y,go));
         }
         for each(o in this.xml.objects[0].rebound)
         {
            add(new Rebound(this.player,o.@x,o.@y,o.@width,o.@height));
         }
         add(new EdgeBlock(-8,0,8,this.height));
         if(!(this is EndLevel || this is StartLevel))
         {
            add(new EdgeBlock(0,-8,this.width,8));
         }
         Main.particles.clearParticles();
         add(Main.particles);
         updateLists();
         var startUps:Array = new Array();
         getClass(StartUp,startUps);
         for each(s in startUps)
         {
            s.startUp();
         }
         if((this.levelNum != 1 || this.mode == 1 && this.attempt > 1) && !(this is StartLevel))
         {
            addTween(new Alarm(20,this.spawn,Tween.ONESHOT),true);
         }
         this.player.cameraFollow();
         if(Options.showCoins)
         {
            add(this.drawCoins = new DrawCoins(this.player));
         }
         if(Options.showTime)
         {
            add(this.drawTime = new DrawTime(this));
         }
         this.setMusic(world);
         add(this.tasWatermark = new TASWatermark());
         this.changing = false;
      }
      
      public function spawn() : void
      {
         this.player.active = true;
      }
      
      private function initTiles(world:uint) : void
      {
         if(this.mode == 1)
         {
            add(this.tiles = new TilesHard(this));
         }
         else if(world == 0)
         {
            add(this.tiles = new Tiles1Dead(this));
         }
         else if(world == 1)
         {
            add(this.tiles = new Tiles1(this));
         }
         else if(world == 2)
         {
            add(this.tiles = new Tiles2(this));
         }
         else if(world == 3)
         {
            add(this.tiles = new Tiles3(this));
         }
      }
      
      protected function load(file:ByteArray) : void
      {
         this.xml = new XML(file.readUTFBytes(file.length));
         this.time = 0;
         this.countTime = true;
      }
      
      private function loadFromString(str:String) : void
      {
         try
         {
            this.xml = new XML(str);
         }
         catch(e:Error)
         {
            add(new Transition(new MainMenu()));
         }
         this.time = 0;
         this.countTime = true;
      }
      
      private function setMusic(world:uint) : void
      {
         if(this is StartLevel)
         {
            Assets.setMusic();
         }
         else if(this is EndLevel)
         {
            Assets.setMusic(Assets.MusKey);
         }
         else if(this.mode == 1)
         {
            if(this.levelNum == 11 && this.attempt == 1)
            {
               Assets.setMusic();
            }
            else if(this.levelNum >= 11)
            {
               Assets.setMusic(Assets.MusBoss);
            }
            else
            {
               Assets.setMusic(Assets.MusHard);
            }
         }
         else if(this.levelNum == 61)
         {
            if(this.attempt == 1)
            {
               Assets.setMusic(Assets.MusKey);
            }
            else
            {
               Assets.setMusic(Assets.MusBoss);
            }
         }
         else if(this.levelNum == 20 || this.levelNum == 40 || this.levelNum == 60)
         {
            if(this.attempt == 1)
            {
               Assets.setMusic();
            }
            else
            {
               Assets.setMusic(Assets.MusBoss);
            }
         }
         else if(world == 0)
         {
            Assets.setMusic(Assets.MusPowerOff);
         }
         else if(world == 1)
         {
            Assets.setMusic(Assets.MusWorld1);
         }
         else if(world == 2)
         {
            Assets.setMusic(Assets.MusWorld2);
         }
         else if(world == 3)
         {
            Assets.setMusic(Assets.MusWorld3);
         }
      }
      
      private function initBackground(world:uint) : void
      {
         if(this.mode == 1)
         {
            add(this.background = new BackgroundHard(this));
         }
         else if(world == 0)
         {
            add(this.background = new Background1Dead(this));
         }
         else if(world == 1)
         {
            add(this.background = new Background1(this));
         }
         else if(world == 2)
         {
            add(this.background = new Background2(this));
         }
         else if(world == 3)
         {
            add(this.background = new Background3(this));
         }
      }
      
      override public function begin() : void
      {
         super.begin();
         if(this.custom)
         {
            try
            {
               this.restart();
            }
            catch(e:Error)
            {
               add(new Transition(new MainMenu()));
            }
         }
         else
         {
            this.restart();
         }
      }

      public function toString() : String
      {
         var prefix:String;
         if (this is StartLevel)
         {
            prefix = "S";
         }
         else if (this is EndLevel)
         {
            prefix = "E";
         }
         else if (this.mode == 0)
         {
            prefix = "L";
         }
         else
         {
            prefix = "H";
         }

         return prefix + levelNum;
      }

      protected function levelExists(mode:uint, num:uint) : Boolean
      {
         return Assets[Assets.PREFIX[mode] + num] != null;
      }
      
      protected function loadLevel(mode:uint, num:uint) : void
      {
         this.load(new Assets[Assets.PREFIX[mode] + num]());
      }
   }
}
