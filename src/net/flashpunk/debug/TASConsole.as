package net.flashpunk.debug
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import mx.controls.Text;
	import flash.text.TextFieldType;
	
	public class TASConsole extends Sprite
    {
        public var CurrentFrameLabel:TextField = new TextField;
        public var NextFrameLabel:TextField = new TextField;
        public var CurrentFrameField:TextField = new TextField;
        public var NextFrameField:TextField = new TextField;

        public var SaveButton:Bitmap;

        public function TASConsole()
        {
        }

        public function Enable(console:Console):void
        {
            x = FP.width / 2 + 100;
            y = 40;

            graphics.clear();
            graphics.beginFill(0, .75);
            graphics.drawRoundRectComplex(0, 0, 140, 60, 5, 5, 5, 5);

            addChild(CurrentFrameLabel);
            CurrentFrameLabel.defaultTextFormat = console.format(12, 0xFFFFFF, "left");
            CurrentFrameLabel.text = "Current Frame: ";
            CurrentFrameLabel.embedFonts = true;
            CurrentFrameLabel.selectable = false;
            CurrentFrameLabel.width = 100;
            CurrentFrameLabel.height = 16;
            CurrentFrameLabel.x = 4;
            CurrentFrameLabel.y = 4;

            addChild(CurrentFrameField);
            CurrentFrameField.defaultTextFormat = console.format(12, 0xFFFFFF, "right");
            CurrentFrameField.text = "...";
            CurrentFrameField.embedFonts = true;
            CurrentFrameField.selectable = true;
            CurrentFrameField.type = TextFieldType.INPUT;
            CurrentFrameField.width = 40;
            CurrentFrameField.height = 16;
            CurrentFrameField.x = 100;
            CurrentFrameField.y = 4;

            addChild(NextFrameLabel);
            NextFrameLabel.defaultTextFormat = console.format(12, 0xFFFFFF, "left");
            NextFrameLabel.text = "Next Frame: ";
            NextFrameLabel.embedFonts = true;
            NextFrameLabel.selectable = false;
            NextFrameLabel.width = 100;
            NextFrameLabel.height = 16;
            NextFrameLabel.x = 4;
            NextFrameLabel.y = 24;

            addChild(NextFrameField);
            NextFrameField.defaultTextFormat = console.format(12, 0xFFFFFF, "right");
            NextFrameField.text = "...";
            NextFrameField.embedFonts = true;
            NextFrameField.selectable = true;
            NextFrameField.type = TextFieldType.INPUT;
            NextFrameField.width = 40;
            NextFrameField.height = 16;
            NextFrameField.x = 100;
            NextFrameField.y = 24;

            addChild(SaveButton = new CONSOLE_SAVE);
            SaveButton.x = 120;
            SaveButton.y = 40;
            SaveButton.alpha = .5;
        }

        [Embed(source = 'console_save.png')] private const CONSOLE_SAVE:Class;
    }

}