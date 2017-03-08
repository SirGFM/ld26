package plugins {

	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import states.Playstate;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Reset extends FlxButton {
		
		[Embed(source = "../../assets/gfx/gui/reset.png")]		private var gfx:Class;
		
		public function Reset() {
			super(36, 10, null, Playstate.onRetry);
			loadGraphic(gfx, true, false, 16, 16);
		}
		
		override public function update():void {
			if (FlxG.keys.justPressed("R")) {
				onUp();
				return;
			}
			preUpdate();
			super.update();
			postUpdate();
		}
	}
}
