package objs.basic {

	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Basic extends FlxSprite {
		
		static protected const gravity:Number = 512;
		
		public function Basic() {
			super();
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X * 16, Y * 16);
		}
	}
}
