package objs.map {
	
	import objs.basic.Basic;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Spike extends Basic {
		
		[Embed(source = "../../../assets/gfx/objs/map/spikes.png")]		private var gfx:Class;
		
		public function Spike() {
			super();
			loadGraphic(gfx, true, false, 16, 16);
			immovable = true;
			moves = false;
		}
	}
}
