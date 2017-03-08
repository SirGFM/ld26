package objs.map {
	
	import objs.basic.Basic;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Goal extends Basic {
		
		[Embed(source = "../../../assets/gfx/objs/map/goal.png")]		private var gfx:Class;
		
		public function Goal() {
			super();
			loadGraphic(gfx);
			height = 16;
			offset.y += 8;
			immovable = true;
			moves = false;
		}
	}
}
