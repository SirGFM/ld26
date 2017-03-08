package objs.panels {

	import objs.basic.Panel;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class ShootPanel extends Panel {
		
		[Embed(source = "../../../assets/gfx/objs/panels/shootPanel.png")]		private var gfx:Class;
		
		public function ShootPanel() {
			super();
			type = SHOOT;
			loadGraphic(gfx, true, false, 16, 32);
			setHB();
		}
	}
}
