package {
	
	import org.flixel.FlxGame;
	import states.Menustate;
	import states.Playstate;
	import utils.Maps;
	
	[SWF(width="512",height="512",backgroundColor="0x000000")]
	[Frame(factoryClass="Preloader")]
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Main extends FlxGame {
		
		static public var GAMENAME:String = "NoBility";
		
		public function Main():void {
			super(512, 512, Menustate, 1, 60, 30, true);
			Maps.importAll();
		}
	}
}
