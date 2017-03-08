package objs.map {
	
	import objs.basic.Basic;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxU;
	import states.Playstate;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Pushable extends Basic {
		
		[Embed(source = "../../../assets/sfx/push.mp3")]		private var sfx:Class;
		[Embed(source = "../../../assets/gfx/objs/map/pushable.png")]		private var gfx:Class;
		
		private var sound:FlxSound;
		
		static private var __I__:int = 0;
		public function Pushable() {
			super();
			loadGraphic(gfx, true, false, 16, 16);
			width = 15;
			height = 16;
			centerOffsets();
			
			acceleration.y = gravity;
			
			FlxG.watch(this, "y", "push" + __I__++ +".y");
		}
		override public function destroy():void {
			super.destroy();
			if (sound)
				sound.destroy();
			sound = null;
		}
		
		override public function update():void {
			super.update();
			var t:uint = touching & WALL;
			if (!t)
				drag.x = 512;
			else
				drag.x = 450;
			if (velocity.x != 0) {
				var min:Number = FlxU.min(-velocity.x / 10, -velocity.x / 2);
				var max:Number = FlxU.max( -velocity.x / 10, -velocity.x / 2);
				Playstate.explode(this, min - 20, max + 20, -20, 20, 0.5);
			}
			if (t != 0)
				if (!sound)
					sound = FlxG.loadSound(sfx, 1.0, false, false, true);
				else
					sound.play();
		}
		
		// auto-adjust
		/*
		override public function update():void {
			super.update();
			var tmp:Number = x % 16;
			if (tmp != 0) {
				if (FlxU.abs(tmp) < 0.1)
					tmp = FlxU.floor(tmp);
				if (tmp > 12)
					x += (16 - tmp) * FlxG.elapsed;
				else
					x -= tmp * FlxG.elapsed;
			}
		}
		*/
	}
}
