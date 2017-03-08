package objs {

	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Bullet extends FlxSprite {
		
		[Embed(source = "../../assets/gfx/objs/bullet.png")]		private var gfx:Class;
		
		protected const speed:Number = 200;
		
		public function Bullet() {
			super();
			loadGraphic(gfx, false, true);
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			velocity.x = speed;
			if (facing == LEFT)
				velocity.x *= -1;
		}
	}
}
