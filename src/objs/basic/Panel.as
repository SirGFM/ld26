package objs.basic {
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Panel extends Basic {
		
		[Embed(source = "../../../assets/sfx/pup.mp3")]		private var sfx:Class;
		
		static private var uniqueID:int = 0;
		
		static public const PUSH:uint = 0x1;
		static public const JUMP:uint = 0x2;
		static public const SHOOT:uint = 0x4;
		static public const RUN:uint = 0x8;
		
		public var type:uint;
		private var sound:FlxSound;
		
		public function Panel() {
			super();
			
			addAnimation("active", [1, 2, 3, 4, 5, 6], 6);
			addAnimation("inactive", [0], 0, false);
			
			immovable = true;
			moves = false;
			ID = uniqueID++;
		}
		override public function destroy():void {
			super.destroy();
			if (sound)
				sound.destroy();
			sound = null;
		}
		
		public function activate():void {
			play("active");
			active = true;
		}
		public function deactivate():void {
			play("inactive");
			active = false;
			if (!sound)
				sound = FlxG.loadSound(sfx, 1.0, false, false, true);
			else
				sound.play(true);
		}
		
		protected function setHB():void {
			width = 16;
			height = 16;
			offset.x += 4;
			offset.y += 16;
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			activate();
		}
	}
}
