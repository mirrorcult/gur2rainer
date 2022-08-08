package game
{
   import game.cosmetic.CollectJetpack;
   import game.cosmetic.Corpse;
   import game.cosmetic.DeadJetpack;
   import game.cosmetic.DeadPlayer;
   import game.cosmetic.Flash;
   import game.cosmetic.Win;
   import game.engine.Assets;
   import game.engine.Level;
   import game.engine.Moveable;
   import game.engine.Stats;
   import net.flashpunk.Entity;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.tweens.misc.Alarm;
   import net.flashpunk.utils.Input;
   import net.flashpunk.Sfx;
   import game.engine.Assets_SCoin;
   
   public class Player extends Moveable
   {
      
      public static const ImgWheel:Class = Player_ImgWheel;
      
      public static const ImgHead:Class = Player_ImgHead;
       
      
      private var wheelSprite:Spritemap;
      
      public var coins:uint = 0;
      
      private const MIN_MOMENTUM:Number = 0.1;
      
      private var jetTime:uint = 0;
      
      public var canRelease:Boolean = true;
      
      private const GRAVITY:Number = 0.15;
      
      private const RADIUS_DOWN:Number = 2.0;
      
      private var jetpack:uint = 0;
      
      private const MAX_MOMENTUM:Number = 2.9;
      
      private const JET_JUMP:Number = -3.0;
      
      private const JUMP:Number = -2.0;
      
      private const C_HOLD:uint = 16711935;
      
      private const MIN_RADIUS:uint = 16;
      
      public var cameraOffsetY:int = 0;
      
      public var onGround:Boolean = false;
      
      public var grapple:Grapple;
      
      private const KILL:Array = ["danger","fire","mine","missile"];
      
      private var canGrapple:Boolean = true;
      
      private const REDUCE:Number = 0.05;
      
      private const RADIUS_UP:Number = 1.5;
      
      private const VARJ_TIME:uint = 14;
      
      private const C_NORMAL:uint = 65280;
      
      private const RUN:Number = 0.6;
      
      public var vSpeed:Number = 0;
      
      public var flip:Boolean = false;
      
      private const MAX_PMOVE:Number = 7.0;
      
      private const MOMENTUM_MULT:Number = 2.5;
      
      private const C_JET:uint = 16711680;
      
      private const JET_ACCEL:Number = 0.1;
      
      private var level:Level;
      
      public var radius:Number = 0;
      
      public const MAX_FALL:Number = 3.0;
      
      private var jetpackSprite:Spritemap;
      
      public var momentum:Number = 0;
      
      private const GRAPPLE_OFFSET:int = -4;
      
      private const SWING_FRIC:Number = 0.04;
      
      private var jetpackFlip:Boolean;
      
      private var headSprite:Spritemap;
      
      private const C_THROW:uint = 16776960;
      
      public var hSpeed:Number = 0;
      
      private const MIN_PMOVE:Number = 0.4;
      
      private const AIR_FRIC:Number = 0.1;
      
      private const JET_AMOUNT:uint = 3;
      
      private const JET_TIME:uint = 16;
      
      private var canPart:Boolean = true;
      
      private const SWING:Number = 0.1;
      
      private const FRIC:Number = 0.6;
      
      private const MAX_RADIUS:uint = 124;
      
      private const MAX_RUN:Number = 2.0;
      
      private const BREAK_RADIUS:uint = 136;
      
      private var varJump:uint = 0;
      
      private const C_FLIP:uint = 65535;
      
      public function Player(level:Level, x:int, y:int)
      {
         super(x,y + 3);
         active = false;
         this.level = level;
         width = 8;
         height = 10;
         originX = 4;
         originY = 5;
         type = "player";
         layer = Main.DEPTH_PLAYER;
         var gl:Graphiclist = new Graphiclist();
         graphic = gl;
         gl.add(this.jetpackSprite = new Spritemap(Jetpack.ImgJetpack,9,10));
         gl.add(this.wheelSprite = new Spritemap(ImgWheel,12,12));
         gl.add(this.headSprite = new Spritemap(ImgHead,12,17));
         this.jetpackSprite.originX = 4;
         this.jetpackSprite.originY = 11;
         this.jetpackSprite.x = -6;
         this.jetpackSprite.y = -11;
         this.jetpackSprite.add("left",[7]);
         this.jetpackSprite.add("right",[11]);
         this.jetpackSprite.visible = false;
         this.wheelSprite.add("spin",[0,1,2,3,4,5,6,7,8,9,10,11],0.5);
         this.wheelSprite.play("spin");
         this.wheelSprite.x = -6;
         this.wheelSprite.y = -6;
         this.headSprite.add("antenna",[0]);
         this.headSprite.add("grapple",[1]);
         this.headSprite.play("antenna");
         this.headSprite.originX = 6;
         this.headSprite.originY = 16;
         this.headSprite.x = -6;
         this.headSprite.y = -16;
         this.wheelSprite.color = this.headSprite.color = 65280;
         addTween(new Alarm(30,this.headBob,Tween.LOOPING),true);

         FP.console.SELECT_LIST.length = 0;
         FP.console.SELECT_LIST.push(this)
      }
      
      public function endWarp() : void
      {
         layer = Main.DEPTH_PLAYER;
         active = true;
         this.headSprite.alpha = 1;
         this.wheelSprite.alpha = 1;
         this.jetpackSprite.alpha = 1;
         if(collide("solid",x,y))
         {
            this.die();
         }
      }
      
      public function release() : void
      {
         FP.angleXY(FP.point,FP.angle(this.grapple.x,this.grapple.y,x,y),this.radius);
         FP.angleXY(FP.point2,FP.angle(this.grapple.x,this.grapple.y,x,y) + this.momentum,this.radius);
         this.hSpeed = FP.point2.x - FP.point.x;
         this.vSpeed = FP.point2.y - FP.point.y;
         this.momentum = 0;
      }
      
      public function startWarp() : void
      {
         layer = Main.DEPTH_ENVIRON;
         active = false;
         this.headSprite.alpha = 0.4;
         this.wheelSprite.alpha = 0.4;
         this.jetpackSprite.alpha = 0.4;
      }
      
      public function lastKeyUpdate() : void
      {
         if(this.wheelSprite.scaleY != 1)
         {
            this.wheelSprite.scaleY = FP.approach(this.wheelSprite.scaleY,1,0.05);
         }
         if(this.headSprite.scaleY != 1)
         {
            this.headSprite.scaleY = FP.approach(this.headSprite.scaleY,1,0.05);
         }
         this.headSprite.angle = FP.angle(x,y,this.grapple.x,this.grapple.y) - 90;
      }
      
      public function grabLastKey() : void
      {
         if(this.jetpack > 0)
         {
            this.jetpack = 0;
            this.dropJetpack(false);
         }
         active = false;
         this.wheelSprite.color = this.headSprite.color = this.C_HOLD;
      }
      
      private function updateJetpack() : void
      {
         this.jetpackFlip = this.headSprite.flipped;
         if(this.jetpackFlip)
         {
            this.jetpackSprite.play("left");
         }
         else
         {
            this.jetpackSprite.play("right");
         }
         this.jetpackSprite.x = !!this.headSprite.flipped?Number(-2):Number(-6);
      }
      
      public function cameraFollow() : void
      {
         FP.camera.x = Math.min(Math.max(x - 160,0),this.level.width - 320);
         FP.camera.y = Math.min(Math.max(y + this.cameraOffsetY - 120,0),this.level.height - 240);
      }
      
      private function dropJetpack(flash:Boolean = true) : void
      {
         this.jetpackSprite.visible = false;
         Assets.SndJetpackDrop.play();
         if(flash)
         {
            Main.screenShake(1);
         }
         FP.world.add(new DeadJetpack(x + this.jetpackSprite.x,y + this.jetpackSprite.y,this.jetpackFlip));
      }
      
      public function latch(stop:Boolean) : void
      {
         if(stop)
         {
            this.momentum = 0;
         }
         else
         {
            this.momentum = (FP.angle(this.grapple.x,this.grapple.y,x + this.hSpeed,y + this.vSpeed) - FP.angle(this.grapple.x,this.grapple.y,x,y)) * this.MOMENTUM_MULT;
         }
         this.hSpeed = 0;
         this.vSpeed = 0;
         this.radius = FP.distance(x,y,this.grapple.x,this.grapple.y);
      }
      
      private function jump() : void
      {
         Assets.SndJump.play();
         this.wheelSprite.scaleY = 1.5;
         this.headSprite.scaleY = 1.5;
         this.varJump = this.VARJ_TIME;
         this.vSpeed = this.JUMP;
      }
      
      public function jetpackJump() : void
      {
         Main.screenShake(0);
         Assets.SndJetpackJump.play();
         if(this.grapple)
         {
            this.grapple.destroy();
         }
         this.headSprite.scaleY = this.wheelSprite.scaleY = 1.6;
         this.canGrapple = false;
         this.jetpack--;
         this.hSpeed = 0;
         this.vSpeed = this.JET_JUMP;
         this.jetTime = this.JET_TIME;
      }
      
      public function die(block:Block = null) : void
      {
         if(!this.level.practice)
         {
            Main.saveData.addDeath();
         }
         Stats.logDeath();
         Assets.SndDie.play();
         if(this.jetpack > 0)
         {
            this.dropJetpack(false);
         }
         if(this.grapple)
         {
            this.grapple.destroy();
         }
         active = false;
         this.level.remove(this);
         this.level.add(new Corpse(x,y,this.headSprite.color));
         this.level.add(new DeadPlayer(this));
         this.level.add(new Flash());
         Main.screenShake(1);
         if(this.level.levelNum > 5 && this.level.levelNum < 20 && this.level.mode == 0)
         {
            Assets.playDeath();
         }
      }
      
      override public function render() : void
      {
         var addX:int = 0;
         var addY:int = 0;
         if(this.grapple && this.grapple.latched)
         {
            addX = -3 + Math.random() * 6;
            addY = -3 + Math.random() * 6;
            this.headSprite.x = this.headSprite.x + addX;
            this.headSprite.y = this.headSprite.y + addY;
            this.wheelSprite.x = this.wheelSprite.x + addX;
            this.wheelSprite.y = this.wheelSprite.y + addY;
            super.render();
            this.headSprite.x = this.headSprite.x - addX;
            this.headSprite.y = this.headSprite.y - addY;
            this.wheelSprite.x = this.wheelSprite.x - addX;
            this.wheelSprite.y = this.wheelSprite.y - addY;
         }
         else
         {
            super.render();
         }
      }
      
      public function collectJetpack(j:Jetpack) : void
      {
         if(this.jetpack > 0)
         {
            this.dropJetpack(false);
         }
         if(!j.active)
         {
            return;
         }
         FP.world.remove(j);
         j.active = false;
         this.jetpack = this.JET_AMOUNT;
         this.jetpackSprite.visible = true;
         this.updateJetpack();
         this.jetpackSprite.angle = this.headSprite.angle;
         Assets.SndJetpackCollect.play();
         FP.world.add(new CollectJetpack(this));
      }
      
      private function headBob() : void
      {
         if(this.headSprite.scaleY == 1 && Assets.music != null && Assets.music != Assets.MusKey)
         {
            this.headSprite.scaleY = 0.7;
         }
      }
      
      override public function update() : void
      {
         var obj:Entity = null;
         var direction:Number = NaN;
         var hitWall:Boolean = false;
         var distance:Number = NaN;
         var cRight:Boolean = false;
         var cLeft:Boolean = false;
         var s:Number = NaN;
         var below:Block = getBelow();
         this.onGround = below != null;
         this.canGrapple = true;
         if(Input.check("restart"))
         {
            this.die();
            return;
         }
         if(y >= this.level.height + 10)
         {
            this.die();
            return;
         }
         if(x >= this.level.width + 4)
         {
            this.win();
            return;
         }
         if((obj = collideTypes(this.KILL,x,y)) != null)
         {
            if(obj is Missile)
            {
               (obj as Missile).explode();
            }
            else if(obj is Mine)
            {
               (obj as Mine).explode();
            }
            else if(obj is NoGrapple)
            {
               (obj as NoGrapple).hit();
            }
            this.die();
            return;
         }
         if((obj = collide("item",x,y)) != null)
         {
            if(obj is Jetpack)
            {
               this.collectJetpack(obj as Jetpack);
            }
            else if(obj is Coin)
            {
               this.collectCoin(obj as Coin);
            }
         }
         if(this.grapple && this.grapple.latched)
         {
            direction = FP.angle(this.grapple.x,this.grapple.y,x,y);
            if(this.grapple.latched.force)
            {
               this.momentum = this.grapple.latched.forceSpin;
            }
            else
            {
               if(this.flip)
               {
                  cRight = Input.check("left");
                  cLeft = Input.check("right");
               }
               else
               {
                  cRight = Input.check("right");
                  cLeft = Input.check("left");
               }
               if(direction < 270 && direction > 90)
               {
                  this.momentum = Math.min(this.momentum + this.GRAVITY,this.MAX_MOMENTUM);
               }
               else if(Math.round(direction) != 270)
               {
                  this.momentum = Math.max(this.momentum - this.GRAVITY,-this.MAX_MOMENTUM);
               }
               if(cRight)
               {
                  this.headSprite.flipped = this.wheelSprite.flipped = false;
                  if(direction > 260 && direction < 280)
                  {
                     s = this.SWING * 3;
                  }
                  else
                  {
                     s = this.SWING;
                  }
                  this.momentum = Math.min(this.momentum + s,this.MAX_MOMENTUM);
               }
               else if(cLeft)
               {
                  this.headSprite.flipped = this.wheelSprite.flipped = true;
                  if(direction > 260 && direction < 280)
                  {
                     s = this.SWING * 3;
                  }
                  else
                  {
                     s = this.SWING;
                  }
                  this.momentum = Math.max(this.momentum - s,-this.MAX_MOMENTUM);
               }
               else if(direction > 260 && direction < 280)
               {
                  this.momentum = FP.approach(this.momentum,0,this.SWING_FRIC);
               }
            }
            if(Input.check("up"))
            {
               this.radius = Math.max(this.MIN_RADIUS,this.radius - this.RADIUS_UP);
            }
            else if(Input.check("down"))
            {
               FP.angleXY(FP.point,direction,this.RADIUS_DOWN);
               if(!collide("solid",x + FP.point.x,y + FP.point.y))
               {
                  this.radius = Math.min(this.MAX_RADIUS,this.radius + this.RADIUS_DOWN);
               }
            }
            direction = direction + this.momentum;
            FP.angleXY(FP.point2,direction,this.radius);
            FP.point2.x = FP.point2.x + (this.grapple.x - x);
            FP.point2.y = FP.point2.y + (this.grapple.y - y);
            FP.point2.x = FP.clamp(FP.point2.x,-this.MAX_PMOVE,this.MAX_PMOVE);
            FP.point2.y = FP.clamp(FP.point2.y,-this.MAX_PMOVE,this.MAX_PMOVE);
            hitWall = false;
            if(Math.abs(FP.point2.x) >= this.MIN_PMOVE)
            {
               if(!moveH(FP.point2.x))
               {
                  hitWall = true;
                  this.momentum = 0;
               }
            }
            if(Math.abs(FP.point2.y) >= this.MIN_PMOVE)
            {
               if(!moveV(FP.point2.y))
               {
                  hitWall = true;
                  this.momentum = 0;
               }
            }
            distance = FP.distance(x,y,this.grapple.x,this.grapple.y);
            if(distance > this.BREAK_RADIUS)
            {
               this.grapple.destroy();
            }
            else if(this.grapple.latched.force)
            {
               if(hitWall)
               {
                  this.radius = this.radius - 1;
               }
               else
               {
                  this.radius = distance;
               }
            }
         }
         else
         {
            if(this.jetTime != 0)
            {
               Main.particles.addParticlesArea("jetpackFire",x - 3,y,6,0);
               this.vSpeed = Math.max(this.vSpeed - this.JET_ACCEL,this.JET_JUMP);
               this.jetTime--;
               if(this.jetTime == 0 && this.jetpack == 0)
               {
                  this.dropJetpack();
               }
            }
            else
            {
               if(Input.check("right"))
               {
                  this.headSprite.flipped = this.wheelSprite.flipped = false;
                  if(!collide("solid",x + 1,y))
                  {
                     if(this.hSpeed < this.MAX_RUN)
                     {
                        this.hSpeed = Math.min(this.hSpeed + this.RUN,this.MAX_RUN);
                     }
                     else
                     {
                        this.hSpeed = Math.max(this.hSpeed - this.REDUCE,this.MAX_RUN);
                     }
                  }
               }
               else if(Input.check("left"))
               {
                  this.headSprite.flipped = this.wheelSprite.flipped = true;
                  if(!collide("solid",x - 1,y))
                  {
                     if(this.hSpeed > -this.MAX_RUN)
                     {
                        this.hSpeed = Math.max(this.hSpeed - this.RUN,-this.MAX_RUN);
                     }
                     else
                     {
                        this.hSpeed = Math.min(this.hSpeed + this.REDUCE,-this.MAX_RUN);
                     }
                  }
               }
               else
               {
                  this.hSpeed = FP.approach(this.hSpeed,0,!!below?Number(this.FRIC):Number(this.AIR_FRIC));
               }
               if(below == null)
               {
                  if(this.varJump > 0)
                  {
                     if(Input.check("jump"))
                     {
                        this.varJump--;
                        this.vSpeed = this.JUMP;
                     }
                     else
                     {
                        this.varJump = 0;
                     }
                  }
                  else
                  {
                     if(this.vSpeed > this.MAX_FALL)
                     {
                        this.vSpeed = Math.max(this.vSpeed - this.REDUCE,this.MAX_FALL);
                     }
                     else
                     {
                        this.vSpeed = Math.min(this.vSpeed + this.GRAVITY,this.MAX_FALL);
                     }
                     if(this.jetpack > 0 && Input.pressed("jump"))
                     {
                        this.jetpackJump();
                     }
                  }
               }
               else if(Input.pressed("jump"))
               {
                  this.jump();
               }
            }
            moveH(this.hSpeed,this.collideH);
            moveV(this.vSpeed,this.collideV);
         }
         if(this.grapple == null)
         {
            if(this.jetTime == 0 && Input.pressed("shoot") && this.canGrapple)
            {
               this.headSprite.scaleY = 2;
               Assets.instance.SndThrow.play();
               FP.world.add(this.grapple = new Grapple(this,x,y + this.GRAPPLE_OFFSET,!!this.headSprite.flipped?135:45));
            }
         }
         else if(this.canRelease && !Input.check("shoot"))
         {
            this.grapple.destroy();
         }
         if(this.wheelSprite.scaleY != 1)
         {
            this.wheelSprite.scaleY = FP.approach(this.wheelSprite.scaleY,1,0.025);
         }
         if(this.headSprite.scaleY != 1)
         {
            this.headSprite.scaleY = FP.approach(this.headSprite.scaleY,1,0.025);
         }
         if(this.grapple && this.grapple.latched)
         {
            this.wheelSprite.rate = this.momentum / this.MAX_MOMENTUM;
         }
         else
         {
            this.wheelSprite.rate = (Math.abs(this.hSpeed) + Math.abs(this.vSpeed)) / this.MAX_RUN;
         }
         if(this.jetTime > 0)
         {
            this.headSprite.play("antenna");
            this.wheelSprite.color = this.headSprite.color = this.C_JET;
         }
         else if(this.grapple)
         {
            this.headSprite.play("grapple");
            if(this.grapple.latched)
            {
               if(this.flip)
               {
                  this.wheelSprite.color = this.headSprite.color = this.C_FLIP;
               }
               else
               {
                  this.wheelSprite.color = this.headSprite.color = this.C_HOLD;
               }
               if(this.canPart)
               {
                  if(this.flip)
                  {
                     Main.particles.addParticlesArea("playerShakeInvert",x - 5,y - 5,10,10);
                  }
                  else
                  {
                     Main.particles.addParticlesArea("playerShake",x - 5,y - 5,10,10);
                  }
               }
               this.canPart = !this.canPart;
            }
            else
            {
               this.wheelSprite.color = this.headSprite.color = this.C_THROW;
            }
            this.headSprite.angle = FP.angle(x,y,this.grapple.x,this.grapple.y) - 90;
         }
         else
         {
            this.headSprite.play("antenna");
            this.wheelSprite.color = this.headSprite.color = this.C_NORMAL;
            this.headSprite.angle = this.headSprite.angle + Main.rotateToward(this.headSprite.angle,this.hSpeed / this.MAX_RUN * 20,this.vSpeed < 0?Number(1):Number(6));
         }
         if(this.jetpackSprite.visible)
         {
            if(this.jetpackFlip != this.headSprite.flipped)
            {
               this.updateJetpack();
            }
            this.jetpackSprite.angle = this.headSprite.angle;
         }
         this.cameraFollow();
      }
      
      private function collideH(other:Block) : void
      {
         this.hSpeed = 0;
      }
      
      private function collideV(other:Block) : void
      {
         this.wheelSprite.scaleY = 1.2;
         this.headSprite.scaleY = 1.2;
         this.vSpeed = 0;
      }
      
      public function win() : void
      {
         if(this.jetpack > 0)
         {
            this.dropJetpack(false);
         }
         active = false;
         FP.world.remove(this);
         if(this.grapple)
         {
            this.grapple.destroy(false);
         }
         if(!Main.saveData.keyLevel && !Main.saveData.startLevel && Main.saveData.level != 61)
         {
            Assets.SndLevelComplete.play();
         }
         if(this.level.practice)
         {
            Main.saveData.coins = this.coins;
            Main.saveData.time = this.level.time;
         }
         else
         {
            Main.saveData.advanceLevels(this.coins,this.level.time, 1, true);
         }
         FP.world.add(new Win());
         FP.tas.StopRecording();
         FP.tas.StopPlayback();
         if(this.level.levelNum == 6 && this.level.mode == 0)
         {
            Assets.playVoice(Assets.VcPlayerWin1);
         }
         else if(this.level.levelNum > 5 && this.level.levelNum < 19 && this.level.mode == 0)
         {
            Assets.playWin();
         }
      }
      
      public function collectCoin(c:Coin = null) : void
      {
         if(c)
         {
            Main.particles.addParticlesArea("coin",c.x - 2,c.y - 2,4,4,3);
            FP.world.remove(c);
         }
         var sfx:Sfx = new Sfx(Assets_SCoin);
         sfx.play();
         this.coins++;
         if(this.level.drawCoins)
         {
            this.level.drawCoins.updateTotal();
         }
      }
   }
}
