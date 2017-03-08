package objs.map {
	
	import objs.basic.Basic;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Sand extends Basic {
		
		[Embed(source = "../../../assets/sfx/sand.mp3")]		private var sfx:Class;
		[Embed(source = "../../../assets/gfx/objs/map/sand.png")]		private var gfx:Class;
		
		private const vanishTime:Number = 0.5;
		
		private var animDeath:Boolean;
		private var timer:Number;
		private var sound:FlxSound;
		
		public function Sand() {
			super();
			loadGraphic(gfx, true, false, 16, 16);
			addAnimation("def", [0], 0, false);
			addAnimation("vanish", [1, 2, 3, 4, 5, 6], 8, false);
			play("def");
			immovable = true;
			moves = false;
			animDeath = false;
			timer = 0;
		}
		override public function destroy():void {
			super.destroy();
			if (sound)
				sound.destroy();
			sound = null;
		}
		
		override public function update():void {
			if (animDeath && finished) {
				animDeath = false;
				exists = false;
				alpha = 1;
				allowCollisions = NONE;
			}
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			
			play("def");
			animDeath = false;
			timer = 0;
			allowCollisions = ANY;
			
			alpha = 1;
		}
		
		public function deactivate():void {
			if (!alive)
				return;
			alive = false;
			animDeath = true;
			timer = vanishTime;
			alpha = 1;
			play("vanish");
			if (!sound)
				sound = FlxG.loadSound(sfx, 1.0, false, false, true);
			else
				sound.play(true);
		}
	}
}
