package net.flashpunk
{
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class Entity extends Tweener
   {
       
      
      var _typePrev:Entity;
      
      private const HITBOX:Mask = new Mask();
      
      var _added:Boolean;
      
      private var _y:Number;
      
      var _renderPrev:Entity;
      
      public var y:Number = 0;
      
      var _world:World;
      
      private var _point:Point;
      
      var _type:String = "";
      
      private var _x:Number;
      
      var _updateNext:Entity;
      
      public var originX:int;
      
      public var height:int;
      
      var _graphic:Graphic;
      
      var _typeNext:Entity;
      
      var _updatePrev:Entity;
      
      private var _camera:Point;
      
      public var width:int;
      
      var _renderNext:Entity;
      
      private var _mask:Mask;
      
      var _layer:int;
      
      public var collidable:Boolean = true;
      
      var _recycleNext:Entity;
      
      public var visible:Boolean = true;
      
      public var originY:int;
      
      public var x:Number = 0;
      
      var _class:Class;
      
      public function Entity(x:Number = 0, y:Number = 0, graphic:Graphic = null, mask:Mask = null)
      {
         this._point = FP.point;
         this._camera = FP.point2;
         super();
         this.x = x;
         this.y = y;
         if(graphic)
         {
            this.graphic = graphic;
         }
         if(mask)
         {
            this.mask = mask;
         }
         this.HITBOX.assignTo(this);
         this._class = Class(getDefinitionByName(getQualifiedClassName(this)));
      }
      
      public function added() : void
      {
      }
      
      public function collidePoint(x:Number, y:Number, pX:Number, pY:Number) : Boolean
      {
         if(pX >= x - this.originX && pY >= y - this.originY && pX < x - this.originX + this.width && pY < y - this.originY + this.height)
         {
            if(!this._mask)
            {
               return true;
            }
            this._x = this.x;
            this._y = this.y;
            this.x = x;
            this.y = y;
            FP.entity.x = pX;
            FP.entity.y = pY;
            FP.entity.width = 1;
            FP.entity.height = 1;
            if(this._mask.collide(FP.entity.HITBOX))
            {
               this.x = this._x;
               this.y = this._y;
               return true;
            }
            this.x = this._x;
            this.y = this._y;
            return false;
         }
         return false;
      }
      
      public function render() : void
      {
         if(this._graphic && this._graphic.visible)
         {
            if(this._graphic.relative)
            {
               this._point.x = this.x;
               this._point.y = this.y;
            }
            else
            {
               this._point.y = 0;
               this._point.x = 0;
            }
            this._camera.x = FP.camera.x;
            this._camera.y = FP.camera.y;
            this._graphic.render(this._point,this._camera);
         }
      }
      
      public function distanceToPoint(px:Number, py:Number, useHitbox:Boolean = false) : Number
      {
         if(!useHitbox)
         {
            return Math.sqrt((this.x - px) * (this.x - px) + (this.y - py) * (this.y - py));
         }
         return FP.distanceRectPoint(px,py,this.x - this.originX,this.y - this.originY,this.width,this.height);
      }
      
      public function set layer(value:int) : void
      {
         if(this._layer == value)
         {
            return;
         }
         if(!this._added)
         {
            this._layer = value;
            return;
         }
         this._world.removeRender(this);
         this._layer = value;
         this._world.addRender(this);
      }
      
      public function collideWith(e:Entity, x:Number, y:Number) : Entity
      {
         this._x = this.x;
         this._y = this.y;
         this.x = x;
         this.y = y;
         if(x - this.originX + this.width > e.x - e.originX && y - this.originY + this.height > e.y - e.originY && x - this.originX < e.x - e.originX + e.width && y - this.originY < e.y - e.originY + e.height && this.collidable && e.collidable)
         {
            if(!this._mask)
            {
               if(!e._mask || e._mask.collide(this.HITBOX))
               {
                  this.x = this._x;
                  this.y = this._y;
                  return e;
               }
               this.x = this._x;
               this.y = this._y;
               return null;
            }
            if(this._mask.collide(!!e._mask?e._mask:e.HITBOX))
            {
               this.x = this._x;
               this.y = this._y;
               return e;
            }
         }
         this.x = this._x;
         this.y = this._y;
         return null;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function collideInto(type:String, x:Number, y:Number, array:Object) : void
      {
         var e:Entity = FP._world._typeFirst[type];
         if(!this.collidable || !e)
         {
            return;
         }
         this._x = this.x;
         this._y = this.y;
         this.x = x;
         this.y = y;
         var n:uint = array.length;
         if(!this._mask)
         {
            while(e)
            {
               if(x - this.originX + this.width > e.x - e.originX && y - this.originY + this.height > e.y - e.originY && x - this.originX < e.x - e.originX + e.width && y - this.originY < e.y - e.originY + e.height && e.collidable && e !== this)
               {
                  if(!e._mask || e._mask.collide(this.HITBOX))
                  {
                     array[n++] = e;
                  }
               }
               e = e._typeNext;
            }
            this.x = this._x;
            this.y = this._y;
            return;
         }
         while(e)
         {
            if(x - this.originX + this.width > e.x - e.originX && y - this.originY + this.height > e.y - e.originY && x - this.originX < e.x - e.originX + e.width && y - this.originY < e.y - e.originY + e.height && e.collidable && e !== this)
            {
               if(this._mask.collide(!!e._mask?e._mask:e.HITBOX))
               {
                  array[n++] = e;
               }
            }
            e = e._typeNext;
         }
         this.x = this._x;
         this.y = this._y;
      }
      
      public function distanceFrom(e:Entity, useHitboxes:Boolean = false) : Number
      {
         if(!useHitboxes)
         {
            return Math.sqrt((this.x - e.x) * (this.x - e.x) + (this.y - e.y) * (this.y - e.y));
         }
         return FP.distanceRects(this.x - this.originX,this.y - this.originY,this.width,this.height,e.x - e.originX,e.y - e.originY,e.width,e.height);
      }
      
      public function collide(type:String, x:Number, y:Number) : Entity
      {
         var e:Entity = null;
         e = FP._world._typeFirst[type];
         if(!this.collidable || !e)
         {
            return null;
         }
         this._x = this.x;
         this._y = this.y;
         this.x = x;
         this.y = y;
         if(!this._mask)
         {
            while(e)
            {
               if(x - this.originX + this.width > e.x - e.originX && y - this.originY + this.height > e.y - e.originY && x - this.originX < e.x - e.originX + e.width && y - this.originY < e.y - e.originY + e.height && e.collidable && e !== this)
               {
                  if(!e._mask || e._mask.collide(this.HITBOX))
                  {
                     this.x = this._x;
                     this.y = this._y;
                     return e;
                  }
               }
               e = e._typeNext;
            }
            this.x = this._x;
            this.y = this._y;
            return null;
         }
         while(e)
         {
            if(x - this.originX + this.width > e.x - e.originX && y - this.originY + this.height > e.y - e.originY && x - this.originX < e.x - e.originX + e.width && y - this.originY < e.y - e.originY + e.height && e.collidable && e !== this)
            {
               if(this._mask.collide(!!e._mask?e._mask:e.HITBOX))
               {
                  this.x = this._x;
                  this.y = this._y;
                  return e;
               }
            }
            e = e._typeNext;
         }
         this.x = this._x;
         this.y = this._y;
         return null;
      }
      
      override public function update() : void
      {
      }
      
      public function set graphic(value:Graphic) : void
      {
         if(this._graphic == value)
         {
            return;
         }
         this._graphic = value;
         if(value && value._assign != null)
         {
            value._assign();
         }
      }
      
      public function collideRect(x:Number, y:Number, rX:Number, rY:Number, rWidth:Number, rHeight:Number) : Boolean
      {
         if(x - this.originX + this.width >= rX && y - this.originY + this.height >= rY && x - this.originX <= rX + rWidth && y - this.originY <= rY + rHeight)
         {
            if(!this._mask)
            {
               return true;
            }
            this._x = this.x;
            this._y = this.y;
            this.x = x;
            this.y = y;
            FP.entity.x = rX;
            FP.entity.y = rY;
            FP.entity.width = rWidth;
            FP.entity.height = rHeight;
            if(this._mask.collide(FP.entity.HITBOX))
            {
               this.x = this._x;
               this.y = this._y;
               return true;
            }
            this.x = this._x;
            this.y = this._y;
            return false;
         }
         return false;
      }
      
      public function distanceToRect(rx:Number, ry:Number, rwidth:Number, rheight:Number) : Number
      {
         return FP.distanceRects(rx,ry,rwidth,rheight,this.x - this.originX,this.y - this.originY,this.width,this.height);
      }
      
      public function get layer() : int
      {
         return this._layer;
      }
      
      public function setHitbox(width:int = 0, height:int = 0, originX:int = 0, originY:int = 0) : void
      {
         this.width = width;
         this.height = height;
         this.originX = originX;
         this.originY = originY;
      }
      
      public function collideTypes(types:Object, x:Number, y:Number) : Entity
      {
         var e:Entity = null;
         var type:String = null;
         for each(type in types)
         {
            if(e = this.collide(type,x,y))
            {
               return e;
            }
         }
         return null;
      }
      
      public function set mask(value:Mask) : void
      {
         if(this._mask == value)
         {
            return;
         }
         if(this._mask)
         {
            this._mask.assignTo(null);
         }
         this._mask = value;
         if(value)
         {
            this._mask.assignTo(this);
         }
      }
      
      public function removed() : void
      {
      }
      
      public function collideTypesInto(types:Object, x:Number, y:Number, array:Object) : void
      {
         var type:String = null;
         for each(type in types)
         {
            this.collideInto(type,x,y,array);
         }
      }
      
      public function get graphic() : Graphic
      {
         return this._graphic;
      }
      
      public function get mask() : Mask
      {
         return this._mask;
      }
      
      public function set type(value:String) : void
      {
         if(this._type == value)
         {
            return;
         }
         if(!this._added)
         {
            this._type = value;
            return;
         }
         if(this._type)
         {
            this._world.removeType(this);
         }
         this._type = value;
         if(value)
         {
            this._world.addType(this);
         }
      }
      
      public function toString() : String
      {
         var s:String = String(this._class);
         return s.substring(7,s.length - 1);
      }
   }
}
