package objs.panels {

	import objs.basic.Panel;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class PushPanel extends Panel {
		
		[Embed(source = "../../../assets/gfx/objs/panels/pushPanel.png")]		private var gfx:Class;
		
		public function PushPanel() {
			super();
			type = PUSH;
			loadGraphic(gfx, true, false, 24, 32);
			setHB();
		}
	}
}
