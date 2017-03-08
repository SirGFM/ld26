package states {

	import org.flixel.FlxBasic;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	import plugins.Menu;
	import plugins.Reset;
	import plugins.Twitter;
	import utils.Maps;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Menustate extends FlxState {
		
		override public function create():void {
			FlxG.bgColor = 0xffb0b0b0;
			
			// create horizontal lines
			var s:FlxSprite;
			var i:int = FlxG.random() * 100 % 4 + 1;
			var c:uint;
			while (i > 0) {
				s = new FlxSprite(0, (FlxG.random() * 1000 % 64) * 8);
				s.makeGraphic(512, 10, 0xff4a4a4a);
				add(s);
				i--;
			}
			// create vertical lines
			i = FlxG.random() * 100 % 4 + 1;
			while (i > 0) {
				s = new FlxSprite((FlxG.random() * 1000 % 64) * 8, 0);
				s.makeGraphic(10, 512, 0xff4a4a4a);
				add(s);
				i--;
			}
			// create figures
			/*i = FlxG.random() * 100 % 8 + 1;
			while (i > 0) {
				s = new FlxSprite((FlxG.random() * 100 % 64) * 8, (FlxG.random() * 100 % 64) * 8);
				switch(FlxU.floor(FlxG.random() * 10 % 4)) {
					case 0: c = 0xffbd2d2d; break;
					case 1: c = 0xffbbbd2c; break;
					case 2: c = 0xff2c66bd; break;
					case 3: c = 0xff2cbd2c; break;
				}
				s.makeGraphic((FlxG.random() * 100 % 16 + 1) * 16, (FlxG.random() * 100 % 16 + 1) * 16, c);
				s.drawLine(0, 0, s.width, 0, 0xff4a4a4a, 10);
				s.drawLine(0, s.height, s.width, s.height, 0xff4a4a4a, 10);
				s.drawLine(0, 0, 0, s.height, 0xff4a4a4a, 10);
				s.drawLine(s.width, 0, s.width, s.height, 0xff4a4a4a, 10);
				add(s);
				i--;
			}*/
			
			(add(new FlxText(0, 75, 512, Main.GAMENAME)) as FlxText).setFormat(null, 32, 0xffe3e3e3, "center", 0x808c8c8c);
			
			(add(new FlxText(0, 460, 512, "A Game by GFM")) as FlxText).setFormat(null, 24, 0xff4a4a4a, "center", 0x80cfcfcf);
			add(Maps.levelSelector(150, 200, 3));
			
			var b:FlxBasic = FlxG.getPlugin(Reset);
			if (b)
				b.exists = false;
			b = FlxG.getPlugin(Menu);
			if (b)
				b.exists = false;
			b = FlxG.getPlugin(Twitter);
			if (!b)
				FlxG.addPlugin(new Twitter());
			else
				b.exists = true;
			
			Maps.playMusic();
		}
	}
}
