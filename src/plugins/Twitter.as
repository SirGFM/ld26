package plugins {

	import org.flixel.FlxButton;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Twitter extends FlxButton {
		
		[Embed(source = "../../assets/gfx/gui/twitter.png")]		private var gfx:Class;
		
		public function Twitter() {
			super(10, 10, null, OnClick);
			loadGraphic(gfx, true, false, 16, 16);
		}
		
		override public function update():void {
			preUpdate();
			super.update();
			postUpdate();
		}
		
		public function OnClick():void {
			FlxU.openURL("https://twitter.com/SirGFM");
		}
	}
}
