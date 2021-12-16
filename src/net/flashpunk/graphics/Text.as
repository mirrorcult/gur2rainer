package net.flashpunk.graphics
{
   import flash.display.BitmapData;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class Text extends Image
   {
      
      private static var _FONT_DEFAULT:Class = Text__FONT_DEFAULT;
      
      public static var size:uint = 16;
      
      public static var font:String = "default";
       
      
      private var _size:uint;
      
      private var _form:TextFormat;
      
      private var _text:String;
      
      private var _height:uint;
      
      private var _width:uint;
      
      private var _field:TextField;
      
      private var _font:String;
      
      public function Text(text:String, x:Number = 0, y:Number = 0, width:uint = 0, height:uint = 0)
      {
         this._field = new TextField();
         this._field.embedFonts = true;
         this._field.defaultTextFormat = this._form = new TextFormat(Text.font,Text.size,16777215);
         this._field.text = this._text = text;
         if(!width)
         {
            width = this._field.textWidth + 4;
         }
         if(!height)
         {
            height = this._field.textHeight + 4;
         }
         _source = new BitmapData(width,height,true,0);
         super(_source);
         this.updateBuffer();
         this.x = x;
         this.y = y;
      }
      
      public function get size() : uint
      {
         return this._size;
      }
      
      public function set size(value:uint) : void
      {
         if(this._size == value)
         {
            return;
         }
         this._form.size = this._size = value;
         this.updateBuffer();
      }
      
      override public function get width() : uint
      {
         return this._width;
      }
      
      override public function get height() : uint
      {
         return this._height;
      }
      
      override public function updateBuffer() : void
      {
         this._field.setTextFormat(this._form);
         this._field.width = this._width = this._field.textWidth + 4;
         this._field.height = this._height = this._field.textHeight + 4;
         _source.fillRect(_sourceRect,0);
         _source.draw(this._field);
         super.updateBuffer();
      }
      
      override public function centerOrigin() : void
      {
         originX = this._width / 2;
         originY = this._height / 2;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function get font() : String
      {
         return this._font;
      }
      
      public function set text(value:String) : void
      {
         if(this._text == value)
         {
            return;
         }
         this._field.text = this._text = value;
         this.updateBuffer();
      }
      
      public function set font(value:String) : void
      {
         if(this._font == value)
         {
            return;
         }
         this._form.font = this._font = value;
         this.updateBuffer();
      }
   }
}
