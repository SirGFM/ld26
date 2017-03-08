package objs.map {
	
	import objs.basic.Basic;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Breakable extends Basic {
		
		[Embed(source = "../../../assets/gfx/objs/map/breakable.png")]		private var gfx:Class;
		
		private var animDeath:Boolean;
		
		public function Breakable() {
			super();
			loadGraphic(gfx, true, false, 16, 16);
			immovable = true;
			moves = false;
			animDeath = false;
		}
		
		override public function update():void {
			if (animDeath && finished) {
				animDeath = false;
				exists = false;
			}
		}
		
		public function deactivate():void {
			if (!alive)
				return;
			alive = false;
			animDeath = true;
			
			finished = true;
		}
	}
}
