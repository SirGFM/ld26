package objs.basic {

	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import plugins.StateWatcher;
	
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
		
		override public function preUpdate():void {
			super.preUpdate();
			StateWatcher.self.write("\t" + FlxU.getClassName(this, true)+
											"\n\t-----Prior-----"+
											"\n\t\tx="+x.toFixed(2)+
											"\n\t\ty="+y.toFixed(2)+
											"\n\t\tvx="+velocity.x.toFixed(2)+
											"\n\t\tvy="+velocity.y.toFixed(2)+
											"\n\t\tax="+acceleration.x.toFixed(2)+
											"\n\t\tay="+acceleration.y.toFixed(2));
		}
		override public function draw():void {
			super.draw();
			StateWatcher.self.write("\t" + FlxU.getClassName(this, true)+
											"\n\t-----After-----"+
											"\n\t\tx="+x.toFixed(2)+
											"\n\t\ty="+y.toFixed(2)+
											"\n\t\tvx="+velocity.x.toFixed(2)+
											"\n\t\tvy="+velocity.y.toFixed(2)+
											"\n\t\tax="+acceleration.x.toFixed(2)+
											"\n\t\tay="+acceleration.y.toFixed(2)+
											"\n\t\tleft="+(touching&LEFT)+
											"\n\t\tright="+(touching&RIGHT)+
											"\n\t\tup="+(touching&UP)+
											"\n\t\tdown="+(touching&DOWN));
		}
	}
}
