package objs.panels {

	import objs.basic.Panel;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class RunPanel extends Panel {
		
		[Embed(source = "../../../assets/gfx/objs/panels/runPanel.png")]		private var gfx:Class;
		
		public function RunPanel() {
			super();
			type = RUN;
			loadGraphic(gfx, true, false, 24, 32);
			setHB();
		}
	}
}
