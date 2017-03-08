package objs.map {
	
	import objs.basic.Basic;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSound;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Spring extends Basic {
		
		[Embed(source = "../../../assets/sfx/spring.mp3")]			private var sfx:Class;
		[Embed(source = "../../../assets/gfx/objs/map/spring.png")]		private var gfx:Class;
		
		private var sound:FlxSound;
		
		public function Spring() {
			super();
			loadGraphic(gfx, true, false, 16, 16);
			immovable = true;
			moves = false;
		}
		override public function destroy():void {
			super.destroy();
			if (sound)
				sound.destroy();
			sound = null;
		}
		
		public function activate(obj:FlxObject):void {
			// TODO spring animation
			obj.velocity.y = -getVY(obj, 64);
			if (!sound)
				sound = FlxG.loadSound(sfx, 1.0, false, false, true);
			else
				sound.play(true);
		}
		
		protected function getVY(obj:FlxObject, Height:Number):Number {
			var t:Number = Math.sqrt(Height * 2 / obj.acceleration.y);
			return obj.acceleration.y * t;
		}
	}
}
