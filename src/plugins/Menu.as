package plugins {

	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import states.Menustate;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Menu extends FlxButton {
		
		[Embed(source = "../../assets/gfx/gui/menu.png")]		private var gfx:Class;
		
		public function Menu() {
			super(10,10,null, onMenu);
			loadGraphic(gfx, true, false, 16, 16);
		}
		override public function update():void {
			if (FlxG.keys.justPressed("Q")) {
				onMenu();
				return;
			}
			preUpdate();
			super.update();
			postUpdate();
		}
		
		public function onMenu():void {
			FlxG.fade(0xff000000, 0.5, function():void { FlxG.switchState(new Menustate()); } );
		}
	}
}