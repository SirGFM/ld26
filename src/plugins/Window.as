package plugins {
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Window extends FlxGroup {
		
		[Embed(source = "../../assets/gfx/gui/window.png")]		private var gfx:Class;
		
		private var spr:FlxSprite;
		
		private var buffer:String;
		private var text:FlxText;
		private var time:Number;
		private var i:int;
		private var msgArr:Array;
		private var sleepCounter:Number;
		
		public function Window() {
			text = new FlxText(16, 16, 480, "");
			text.setFormat(null, 16, 0xff4a4a4a, "center", 0x80cfcfcf);
			msgArr = new Array();
			i = -1;
			
			spr = new FlxSprite(0, 0, gfx);
			spr.alpha = 0.75;
			add(spr);
			add(text);
			sleep();
		}
		
		override public function update():void {
			super.update();
			if (FlxG.keys.justPressed("SPACE")) {
				if (i >= 0) {
					text.text = buffer;
					i = -1;
				}
				else
					sleepCounter = 0;
			}
			if (i < 0) {
				if (msgArr.length > 0) {
					buffer = msgArr.shift() as String;
					text.text = "";
					time = 0;
					i = 0;
				}
				else if (isNaN(sleepCounter))
					sleepCounter = 2.5;
			}
			else if (time <= 0) {
				text.text += buffer.charAt(i++);
				if (i > buffer.length)
					i = -1;
				time = 0.08;
			}
			else
				time -= FlxG.elapsed;
			
			if (!isNaN(sleepCounter))
				if( sleepCounter > 0)
					sleepCounter -= FlxG.elapsed;
				else
					sleep();
		}
		
		public function wakeup(str:String):void {
			msgArr.push(str);
			exists = true;
			sleepCounter = NaN;
		}
		public function sleep():void {
			while (msgArr.length > 0)
				msgArr.pop();
			i = -1;
			sleepCounter = NaN;
			exists = false;
		}
		
		public function switchY():void {
			var y:Number;
			if (spr.y == 0)
				y = FlxG.height - spr.height;
			else
				y = 0;
			spr.y = y;
			text.y = y + 16;
		}
		public function overlaps(obj:FlxObject):void {
			if (obj.overlaps(spr))
				switchY();
			else if (spr.y != 0) {
				switchY();
				overlaps(obj);
			}
		}
	}
}
