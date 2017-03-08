package objs.panels {

	import objs.basic.Panel;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class JumpPanel extends Panel {
		
		[Embed(source = "../../../assets/gfx/objs/panels/jumpPanel.png")]		private var gfx:Class;
		
		public function JumpPanel() {
			super();
			type = JUMP;
			loadGraphic(gfx, true, false, 24, 32);
			setHB();
		}
	}
}
