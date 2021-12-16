package game
{
   import game.engine.Assets;
   import game.engine.StartUp;
   import net.flashpunk.FP;
   import net.flashpunk.Tween;
   import net.flashpunk.graphics.Graphiclist;
   import net.flashpunk.graphics.Spritemap;
   import net.flashpunk.graphics.Text;
   import net.flashpunk.tweens.misc.Alarm;
   
   public class NumBlock extends Block implements StartUp
   {
      
      private static const ImgNumBlock:Class = NumBlock_ImgNumBlock;
       
      
      private var sprite:Spritemap;
      
      public var num:int;
      
      private var allBlocks:Vector.<NumBlock>;
      
      private var text:Text;
      
      private var alarm:Alarm;
      
      private var list:Graphiclist;
      
      public function NumBlock(player:Player, x:int, y:int, num:int)
      {
         this.alarm = new Alarm(30,this.onAlarm,Tween.PERSIST);
         super(player,x,y,16,16);
         this.num = num;
         visible = true;
         active = true;
         graphic = this.list = new Graphiclist();
         this.sprite = new Spritemap(ImgNumBlock,16,16);
         this.sprite.add("wait",[0]);
         this.sprite.add("active",[1,2],0.15);
         this.sprite.add("done",[3]);
         this.sprite.add("dead",[4]);
         this.list.add(this.sprite);
         this.sprite.play("wait");
         this.text = new Text(String(num + 1));
         this.text.size = 8;
         this.text.color = 0;
         this.text.alpha = 0.6;
         this.text.x = 9 - this.text.width / 2;
         this.text.y = 6 - this.text.height / 2;
         this.list.add(this.text);
         addTween(this.alarm);
         this.alarm.active = false;
         if(num == 0)
         {
            this.updateState();
         }
      }
      
      public function updateState() : void
      {
         if(!this.alarm.active)
         {
            this.alarm.start();
         }
      }
      
      public function done() : void
      {
         shake = 10;
         this.sprite.play("dead");
         active = false;
      }
      
      override public function onGrapple() : void
      {
         var i:int = 0;
         var vec:Vector.<Door> = null;
         var vec2:Vector.<LaserV> = null;
         var vec3:Vector.<LaserH> = null;
         var vec4:Vector.<Launcher> = null;
         var vec5:Vector.<NoGrapple> = null;
         if(this.sprite.currentAnim == "active")
         {
            if(this.num == this.allBlocks.length - 1)
            {
               for(i = 0; i < this.allBlocks.length; i++)
               {
                  this.allBlocks[i].done();
               }
               vec = new Vector.<Door>();
               FP.world.getClass(Door,vec);
               for(i = 0; i < vec.length; i++)
               {
                  vec[i].open();
               }
               vec2 = new Vector.<LaserV>();
               FP.world.getClass(LaserV,vec2);
               for(i = 0; i < vec2.length; i++)
               {
                  vec2[i].deactivate();
               }
               vec3 = new Vector.<LaserH>();
               FP.world.getClass(LaserH,vec3);
               for(i = 0; i < vec3.length; i++)
               {
                  vec3[i].deactivate();
               }
               vec4 = new Vector.<Launcher>();
               FP.world.getClass(Launcher,vec4);
               for(i = 0; i < vec4.length; i++)
               {
                  vec4[i].deactivate();
               }
               vec5 = new Vector.<NoGrapple>();
               FP.world.getClass(NoGrapple,vec5);
               for(i = 0; i < vec5.length; i++)
               {
                  vec5[i].deactivate();
               }
               Main.screenShake(1);
               Assets.SndDoorOpen.play();
               Assets.setMusic();
            }
            else
            {
               shake = 10;
               this.sprite.play("done");
               this.allBlocks[this.num + 1].updateState();
               if(this.num == 0)
               {
                  Assets.SndButton1.play();
               }
               else if(this.num == 1)
               {
                  Assets.SndButton2.play();
               }
               else if(this.num == 2)
               {
                  Assets.SndButton3.play();
               }
               else
               {
                  Assets.SndButton4.play();
               }
            }
         }
      }
      
      private function onAlarm() : void
      {
         if(grapple)
         {
            this.onGrapple();
         }
         else
         {
            this.sprite.play("active");
            shake = 10;
            Assets.SndButtonLight.play();
         }
      }
      
      public function startUp() : void
      {
         var temp:Vector.<NumBlock> = new Vector.<NumBlock>();
         FP.world.getClass(NumBlock,temp);
         this.allBlocks = new Vector.<NumBlock>(temp.length);
         for(var i:int = 0; i < temp.length; i++)
         {
            this.allBlocks[temp[i].num] = temp[i];
         }
      }
   }
}
