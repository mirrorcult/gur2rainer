package game.menus
{
   import game.Options;
   import game.cosmetic.Flash;
   import game.cosmetic.MenuBG;
   import game.cosmetic.Transition;
   import game.engine.Assets;
   import game.engine.Level;
   import game.engine.MattWorld;
   import game.engine.SaveData;
   import game.engine.Stats;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.Sfx;
   import net.flashpunk.utils.Input;
   import net.flashpunk.utils.Key;
   import flash.display.StageDisplayState;
   
   public class MainMenu extends MattWorld
   {
       
      
      private var buttons:Vector.<MenuButton>;
      
      private var credits:Boolean = false;
      
      private var options:Boolean = false;
      
      private var toRemove:Vector.<Entity>;
      
      public function MainMenu()
      {
         super();
         this.buttons = new Vector.<MenuButton>();
         this.toRemove = new Vector.<Entity>();
         add(new MenuBG());
         this.gotoMain();

         if (Options.memoryWatch)
         {
            Main.MC_MEMORY_WATCH.visible = false;
         }

         if (Options.fullscreen)
         {
            Main.instance.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
         }
      }
      
      private function newNormalGame(button:MenuButton) : void
      {
         this.deactivateAllButtons();
         Main.saveData = new SaveData();
         Main.saveData.newGame(0);
         FP.world.add(new Transition(new Level(0,1)));
      }
      
      private function gotoMain(m:MenuButton = null) : void
      {
         var hard:MenuButton = null;
         var load:MenuButton = null;
         var stats:MenuButton = null;
         this.options = false;
         this.credits = false;
         Options.saveOptions();
         this.clearButtons();
         this.addButton(new MenuButton(160,110,"New Game",!!Main.saveExists()?this.gotoConfirmNewNormal:this.newNormalGame,!!Main.saveExists()?Assets.instance.SndMenuSelect:Assets.SndNewNormalGame));
         this.addButton(hard = new MenuButton(160,130,"New HARD Game",!!Main.saveExists()?this.gotoConfirmNewHard:this.newHardGame,!!Main.saveExists()?Assets.instance.SndMenuSelect:Assets.SndNewHardGame));
         this.addButton(load = new MenuButton(160,150,"Continue",this.gotoConfirmContinue,Assets.instance.SndMenuSelect));
         this.addButton(stats = new MenuButton(160,170,"Stats",this.gotoStats,Assets.instance.SndMenuSelect));
         this.addButton(new MenuButton(160,190,"Level Select",this.gotoLevelSelector,Assets.instance.SndMenuSelect));
         this.addButton(new MenuButton(160,210,"Options",this.gotoOptions,Assets.instance.SndMenuSelect));
         this.addButton(new MenuButton(160,230,"Credits",this.gotoCredits,Assets.instance.SndMenuSelect));
         if(!Main.saveExists())
         {
            load.deactivate();
         }
         if(!Main.beatenNormal())
         {
            stats.deactivate();
         }
      }
      
      private function toggleVoice(button:MenuButton) : void
      {
         Options.voices = !Options.voices;
         button.setText("Robot Voice: " + this.getBoolName(Options.voices));
      }
      
      private function toggleParticles(button:MenuButton) : void
      {
         Options.particles = !Options.particles;
         button.setText("Particles: " + this.getBoolName(Options.particles));
      }

      private function togglePractice(button:MenuButton) : void
      {
         Options.practiceMode = !Options.practiceMode;
         button.setText("Practice Mode: " + this.getBoolName(Options.practiceMode))
      }

      private function toggleMemWatch(button:MenuButton) : void
      {
         Options.memoryWatch = !Options.memoryWatch;
         button.setText("Memory Watch: " + this.getBoolName(Options.memoryWatch))
      }

      private function toggleFullscreen(button:MenuButton) : void
      {
         Options.fullscreen = !Options.fullscreen;
         button.setText("Fullscreen: " + this.getBoolName(Options.fullscreen))
         Main.instance.stage.displayState = Options.fullscreen ? StageDisplayState.FULL_SCREEN_INTERACTIVE : StageDisplayState.NORMAL;
      }
      
      override public function update() : void
      {
         super.update();
         if(this.options && Input.pressed(Key.DELETE) && Input.check(Key.SHIFT))
         {
            Main.clearEverything();
            Assets.setMusic(Assets.MusMenu);
            Assets.SndDie.play();
            add(new Flash());
            this.gotoOptions();
         }
         if(this.credits && Input.pressed(Key.INSERT) && Input.check(Key.CONTROL) && CustomStage.customStage == null)
         {
            openCustomStage();
         }
      }

      private function openCustomStage(m:MenuButton = null)
      {
         Assets.instance.SndMenuSelect.play();
         FP.stage.addChild(new CustomStage(this));
         this.deactivateAllButtons();
      }
      
      private function gotoConfirmNewNormal(m:MenuButton = null) : void
      {
         this.clearButtons();
         this.toRemove.push(add(new Title(24,"Are You Sure?",160,100,false)));
         this.toRemove.push(add(new Title(16,"Current savefile will be deleted!",160,116,false)));
         this.addButton(new MenuButton(160,170,"Do It!",this.newNormalGame,Assets.SndNewNormalGame));
         this.addButton(new MenuButton(160,195,"Cancel",this.gotoMain,Assets.SndMenuCancel));
      }
      
      private function activateAllButtons() : void
      {
         for(var i:int = 0; i < this.buttons.length; i++)
         {
            this.buttons[i].active = true;
         }
      }
      
      public function loadCustomLevel(str:String) : void
      {
         Main.saveData = new SaveData();
         add(new Transition(new Level(1,0,true,str)));
      }
      
      private function gotoConfirmNewHard(m:MenuButton = null) : void
      {
         this.clearButtons();
         this.toRemove.push(add(new Title(24,"Are You Sure?",160,100,false)));
         this.toRemove.push(add(new Title(16,"Current savefile will be deleted!",160,116,false)));
         this.addButton(new MenuButton(160,170,"Do It!",this.newHardGame,Assets.SndNewHardGame));
         this.addButton(new MenuButton(160,195,"Cancel",this.gotoMain,Assets.SndMenuCancel));
      }

      private function gotoLevelSelector(m:MenuButton = null) : void
      {
         this.clearButtons()

         for (var i:int = 0; i < 5; i++)
         {
            for (var j:int = 1; j < 13; j++)
            {
               this.addButton(new MenuButton(65 + j * 15, 80 + i * 15, "L" + (i * 12 + j), this.levelButtonClicked, Assets.instance.SndMenuSelect, false, 8, 8, 8));
            }
         }

         // 61
         this.addButton(new MenuButton(160, 155, "L61", this.levelButtonClicked, Assets.instance.SndMenuSelect, false, 8, 8, 8));

         // hardmode
         for (var k:int = 1; k < 14; k++)
         {
            this.addButton(new MenuButton(58 + k * 15, 180, "H" + k, this.levelButtonClicked, Assets.instance.SndMenuSelect, false, 8, 8, 8));
         }

         this.addButton(new MenuButton(160, 200, "Custom Level", this.openCustomStage, Assets.SndNewHardGame));
         this.addButton(new MenuButton(160, 225, "Cancel",this.gotoMain,Assets.SndMenuCancel));
      }

      private function levelButtonClicked(m:MenuButton) : void
      {
         var txt = m.getText();
         var mode = txt.substr(0, 1);
         var intMode = mode == "L" ? 0 : 1;

         var level = 1;
         if (txt.length == 2)
         {
            // L1, L2, etc
            level = parseInt(txt.substr(1, 1));
         }
         else if (txt.length == 3)
         {
            // L50, H12, etc
            level = parseInt(txt.substr(1, 2));
         }

         this.deactivateAllButtons();
         Main.saveData = new SaveData();
         Main.saveData.newGame(intMode, level);
         FP.world.add(new Transition(new Level(intMode, level)));
      }
      
      private function toggleShowCoins(button:MenuButton) : void
      {
         Options.showCoins = !Options.showCoins;
         button.setText("Show Coins: " + this.getBoolName(Options.showCoins));
      }
      
      private function getBoolName(bool:Boolean) : String
      {
         if(bool)
         {
            return "ON";
         }
         return "OFF";
      }
      
      private function getVolumeName() : String
      {
         if(FP.volume == 0)
         {
            return "OFF";
         }
         return Number(FP.volume * 100).toFixed() + "%";
      }
      
      private function addNA(y:int) : void
      {
         this.toRemove.push(add(new Title(8,"N/A",240,y,false,8947848)));
      }
      
      private function clearButtons() : void
      {
         var i:int = 0;
         for(i = 0; i < this.buttons.length; i++)
         {
            remove(this.buttons[i]);
         }
         for(i = 0; i < this.toRemove.length; i++)
         {
            remove(this.toRemove[i]);
         }
         this.buttons = new Vector.<MenuButton>();
         this.toRemove = new Vector.<Entity>();
      }
      
      private function gotoConfirmContinue(m:MenuButton = null) : void
      {
         this.clearButtons();
         this.toRemove.push(add(new Title(16,!!Main.saveIsNormalMode()?"Normal Mode":"Hard Mode",160,90,false)));
         this.toRemove.push(add(new Title(8,Main.getSaveLevel(),160,104,false)));
         this.toRemove.push(add(new Title(8,Main.getSaveDeaths(),160,114,false)));
         this.toRemove.push(add(new Title(8,Main.getSaveCoins(),160,124,false)));
         this.toRemove.push(add(new Title(8,Main.getSaveTime(),160,134,false)));
         this.addButton(new MenuButton(160,170,"Continue",this.loadGame,!!Main.saveIsNormalMode()?Assets.SndNewNormalGame:Assets.SndNewHardGame));
         this.addButton(new MenuButton(160,195,"Cancel",this.gotoMain,Assets.SndMenuCancel));
      }
      
      private function gotoSoundTest(m:MenuButton = null) : void
      {
         this.options = false;
         Assets.setMusic();
         this.clearButtons();
         this.addButton(new MenuButton(160,225,"Back",this.gotoOptions,Assets.SndMenuCancel));
      }
      
      override public function begin() : void
      {
         add(new Title(8,"Maddy Thorson & cyclowns present",160,20,false,11184810));
         add(new GameTitle());
         Assets.setMusic(Assets.MusMenu);
         FP.camera.y = 0;
         FP.camera.x = 0;
      }
      
      private function toggleShowTime(button:MenuButton) : void
      {
         Options.showTime = !Options.showTime;
         button.setText("Show Time: " + this.getBoolName(Options.showTime));
      }
      
      private function switchVolume(button:MenuButton) : void
      {
         FP.volume = FP.volume + 0.25;
         if(FP.volume > 1)
         {
            FP.volume = 0;
         }
         if(FP.volume == 0)
         {
            Assets.setMusic();
         }
         else
         {
            Assets.setMusic(Assets.MusMenu);
         }
         button.setText("Audio: " + this.getVolumeName());
      }
      
      private function addButton(m:MenuButton) : void
      {
         add(m);
         this.buttons.push(m);
      }
      
      private function deactivateAllButtons() : void
      {
         for(var i:int = 0; i < this.buttons.length; i++)
         {
            this.buttons[i].active = false;
         }
      }
      
      private function gotoCredits(m:MenuButton = null) : void
      {
         this.credits = true;
         this.clearButtons();
         this.toRemove.push(add(new Title(8,"Graphics, Audio, Programming and Design by",160,72,false,11184810)));
         this.toRemove.push(add(new Title(16,"Maddy Thorson",160,82,false)));
         this.toRemove.push(add(new Title(8,"With Voices by",160,100,false,11184810)));
         this.toRemove.push(add(new Title(16,"Rachel Williamson",160,110,false)));
         this.toRemove.push(add(new Title(8,"Testing and Feedback from",160,128,false,11184810)));
         this.toRemove.push(add(new Title(8,"Chevy Johnston",120,138,false)));
         this.toRemove.push(add(new Title(8,"Ben Williamson",120,148,false)));
         this.toRemove.push(add(new Title(8,"Noel Berry",200,138,false)));
         this.toRemove.push(add(new Title(8,"Alexander Bruce",200,148,false)));
         this.toRemove.push(add(new Title(8,"Adult Swim Games",160,158,false)));
         this.toRemove.push(add(new Title(8,"Maddy\'s Portfolio is at",114,178,false,11184810)));
         this.toRemove.push(add(new Title(8,"exok.com",206,178,false)));
         this.toRemove.push(add(new Title(8,"Levels made using",125,190,false,11184810)));
         this.toRemove.push(add(new Title(8,"OgmoEditor.com",199,190,false)));
         this.toRemove.push(add(new Title(8,"Game engine",131,202,false,11184810)));
         this.toRemove.push(add(new Title(8,"FlashPunk.net",189,202,false)));
         this.toRemove.push(add(new Title(8,Main.VERSION,16,236,false,8947848)));
         this.addButton(new MenuButton(160,224,"Back",this.gotoMain,Assets.SndMenuCancel));
      }
      
      private function loadGame(button:MenuButton) : void
      {
         this.deactivateAllButtons();
         Main.loadGame();
         FP.world.add(new Transition(Main.getLevel(true)));
      }
      
      public function cancelCustomLevel() : void
      {
         Assets.SndMenuCancel.play();
         this.activateAllButtons();
      }
      
      private function gotoOptions(m:MenuButton = null) : void
      {
         this.options = true;
         Assets.setMusic(Assets.MusMenu);
         this.clearButtons();
         this.addButton(new MenuButton(160,225,"Back",this.gotoMain,Assets.SndMenuCancel));
         this.addButton(new MenuButton(80,80,"Show Coins: " + this.getBoolName(Options.showCoins),this.toggleShowCoins,Assets.instance.SndMenuSelect));
         this.addButton(new MenuButton(80,100,"Show Time: " + this.getBoolName(Options.showTime),this.toggleShowTime,Assets.instance.SndMenuSelect));
         this.addButton(new MenuButton(80,120,"UP to Jump: " + this.getBoolName(Options.upToJump),this.toggleUpToJump,Assets.instance.SndMenuSelect));
         this.addButton(new MenuButton(80,140,"Robot Voice: " + this.getBoolName(Options.voices),this.toggleVoice,Assets.instance.SndMenuSelect));
         this.addButton(new MenuButton(80,160,"Audio: " + this.getVolumeName(),this.switchVolume,Assets.instance.SndMenuSelect));
         this.addButton(new MenuButton(80,180,"Particles: " + this.getBoolName(Options.particles),this.toggleParticles,Assets.instance.SndMenuSelect));
         this.addButton(new MenuButton(80,200,"Practice Mode: " + this.getBoolName(Options.practiceMode),this.togglePractice,Assets.instance.SndMenuSelect));
         this.addButton(new MenuButton(240,80,"Memory Watch: " + this.getBoolName(Options.memoryWatch),this.toggleMemWatch,Assets.instance.SndMenuSelect));
         this.addButton(new MenuButton(240,100,"Fullscreen: " + this.getBoolName(Options.fullscreen),this.toggleFullscreen,Assets.instance.SndMenuSelect));
      }
      
      private function gotoStats(m:MenuButton = null) : void
      {
         this.clearButtons();
         var stats:Object = Stats.getStats();
         var yy:int = 105;
         var hard:* = stats.comp_hard > 0;
         this.toRemove.push(add(new Title(16,"Total Deaths: " + stats.deaths,160,yy,false)));
         yy = yy + 25;
         this.toRemove.push(add(new Title(8,"Normal",160,yy,false,12303291)));
         this.toRemove.push(add(new Title(8,"Hard",240,yy,false,12303291)));
         yy = yy + 15;
         this.toRemove.push(add(new Title(8,"Completions:",80,yy,false)));
         this.toRemove.push(add(new Title(8,String(stats.comp_normal),160,yy,false)));
         this.toRemove.push(add(new Title(8,String(stats.comp_hard),240,yy,false)));
         yy = yy + 12;
         this.toRemove.push(add(new Title(8,"Least Deaths:",80,yy,false)));
         this.toRemove.push(add(new Title(8,String(stats.best_deaths_normal),160,yy,false)));
         if(hard)
         {
            this.toRemove.push(add(new Title(8,String(stats.best_deaths_hard),240,yy,false)));
         }
         else
         {
            this.addNA(yy);
         }
         yy = yy + 12;
         this.toRemove.push(add(new Title(8,"Most Coins:",80,yy,false)));
         this.toRemove.push(add(new Title(8,String(stats.best_coins_normal),160,yy,false)));
         if(hard)
         {
            this.toRemove.push(add(new Title(8,String(stats.best_coins_hard),240,yy,false)));
         }
         else
         {
            this.addNA(yy);
         }
         yy = yy + 12;
         this.toRemove.push(add(new Title(8,"Fastest:",80,yy,false)));
         this.toRemove.push(add(new Title(8,Main.formatTime(stats.best_time_normal),160,yy,false)));
         if(hard)
         {
            this.toRemove.push(add(new Title(8,Main.formatTime(stats.best_time_hard),240,yy,false)));
         }
         else
         {
            this.addNA(yy);
         }
         yy = yy + 12;
         this.toRemove.push(add(new Title(8,"High Score:",80,yy,false)));
         this.toRemove.push(add(new Title(8,Main.convertScoreString(stats.best_score_normal),160,yy,false)));
         if(hard)
         {
            this.toRemove.push(add(new Title(8,Main.convertScoreString(stats.best_score_hard),240,yy,false)));
         }
         else
         {
            this.addNA(yy);
         }
         yy = yy + 12;
         this.addButton(new MenuButton(160,225,"Back",this.gotoMain,Assets.SndMenuCancel));
      }
      
      private function newHardGame(button:MenuButton) : void
      {
         this.deactivateAllButtons();
         Main.saveData = new SaveData();
         Main.saveData.newGame(1);
         FP.world.add(new Transition(new Level(1,1)));
      }
      
      private function toggleUpToJump(button:MenuButton) : void
      {
         Options.upToJump = !Options.upToJump;
         button.setText("UP to Jump: " + this.getBoolName(Options.upToJump));
      }
   }
}
