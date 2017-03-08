package {
	
	import flash.events.Event;
	import org.flixel.FlxGame;
	import states.Menustate;
	import states.Playstate;
	import states.Teststate;
	import utils.Maps;
	import com.wordpress.gfmgamecorner.LogoGFM;
	
	[SWF(width="512",height="512",backgroundColor="0x000000")]
	[Frame(factoryClass="Preloader")]
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Main extends FlxGame {
		
		static public var GAMENAME:String = "NoBility";
		
		
		public function Main():void {
			//super(512, 512, Menustate, 1, 60, 30, true);
			super(512, 512, Teststate, 1, 90, 30, true);
			Maps.importAll();
		}
		
		private var logo:LogoGFM;
		override protected function create(FlashEvent:Event):void {
			if (stage && !logo) {
				logo = new LogoGFM();
				logo.scaleX = 2;
				logo.scaleY = 2;
				logo.x = (512 - logo.width) / 2;
				logo.y = (512 - logo.height) / 2;
				addChild(logo);
				return;
			}
			else if (logo.visible)
				return;
			super.create(FlashEvent);
			removeChild(logo);
			logo.destroy();
			logo = null;
		}
	}
}
