package utils {
	
	import objs.map.*;
	import objs.panels.*;
	import objs.Player;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSave;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	import plugins.Window;
	import states.Menustate;
	import states.Playstate;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Maps {
		
		[Embed(source = "../../assets/sfx/song.mp3")]		static private var music:Class;
		[Embed(source = "../../assets/gfx/gui/button.png")]		static private var gfx:Class;
		[Embed(source = "../../assets/gfx/map/tileset2.png")]		static private var tiles:Class;
		
		[Embed(source = "../../assets/maps/test/otest.txt", mimeType = "application/octet-stream")]		static private var otest:Class;
		[Embed(source = "../../assets/maps/test/test.txt", mimeType = "application/octet-stream")]		static private var test:Class;
		
		[Embed(source = "../../assets/maps/000.txt", mimeType = "application/octet-stream")]		static private var _000:Class;
		[Embed(source = "../../assets/maps/001.txt", mimeType = "application/octet-stream")]		static private var _001:Class;
		[Embed(source = "../../assets/maps/002.txt", mimeType = "application/octet-stream")]		static private var _002:Class;
		[Embed(source = "../../assets/maps/003.txt", mimeType = "application/octet-stream")]		static private var _003:Class;
		[Embed(source = "../../assets/maps/004.txt", mimeType = "application/octet-stream")]		static private var _004:Class;
		[Embed(source = "../../assets/maps/005.txt", mimeType = "application/octet-stream")]		static private var _005:Class;
		[Embed(source = "../../assets/maps/006.txt", mimeType = "application/octet-stream")]		static private var _006:Class;
		[Embed(source = "../../assets/maps/007.txt", mimeType = "application/octet-stream")]		static private var _007:Class;
		[Embed(source = "../../assets/maps/008.txt", mimeType = "application/octet-stream")]		static private var _008:Class;
		[Embed(source = "../../assets/maps/o008.txt", mimeType = "application/octet-stream")]		static private var o_008:Class;
		[Embed(source = "../../assets/maps/o007.txt", mimeType = "application/octet-stream")]		static private var o_007:Class;
		[Embed(source = "../../assets/maps/o006.txt", mimeType = "application/octet-stream")]		static private var o_006:Class;
		[Embed(source = "../../assets/maps/o005.txt", mimeType = "application/octet-stream")]		static private var o_005:Class;
		[Embed(source = "../../assets/maps/o004.txt", mimeType = "application/octet-stream")]		static private var o_004:Class;
		[Embed(source = "../../assets/maps/o003.txt", mimeType = "application/octet-stream")]		static private var o_003:Class;
		[Embed(source = "../../assets/maps/o002.txt", mimeType = "application/octet-stream")]		static private var o_002:Class;
		[Embed(source = "../../assets/maps/o001.txt", mimeType = "application/octet-stream")]		static private var o_001:Class;
		[Embed(source = "../../assets/maps/o000.txt", mimeType = "application/octet-stream")]		static private var o_000:Class;
		
		static private var _enabledLevels:int = 1;
		static private var _curLevel:int = 0;
		static private var _maxLevel:int = 9;
		
		static private var _lvlStr:String = new _000;
		static private var _lvlObj:String = new o_000;
		
		static public function importAll():void {
			Player; Breakable; Goal; Pushable; Sand; Spike; Spring; JumpPanel; PushPanel; RunPanel; ShootPanel;
			checkProgress();
		}
		static public function playMusic():void {
			if (FlxG.music)
				FlxG.music.play();
			else
				FlxG.playMusic(music);
		}
		
		/**
		 * Stores and loads progress
		 */
		static private function checkProgress():void {
			var save:FlxSave = new FlxSave();
			save.bind("ld26_gfm_save");
			if (!save.data.enabledLevels || save.data.enabledLevels < _enabledLevels)
				save.data.enabledLevels = _enabledLevels;
			else
				_enabledLevels = save.data.enabledLevels;
			save.close();
		}
		
		static public function testMap(map:FlxTilemap):void {
			loadMap(map, "test");
		}
		
		static public function next(map:FlxTilemap):void {
			_curLevel = (_curLevel + 1) % _maxLevel;
			if (_curLevel == 0) {
				FlxG.switchState(new Menustate());
				return;
			}
			loadMap(map, levelName(_curLevel));
			
			if (_curLevel+1 > _enabledLevels)
				_enabledLevels = _curLevel + 1;
			checkProgress();
		}
		static public function retry(map:FlxTilemap):void {
			var state:FlxState = FlxG.state;
			state.callAll("kill");
			
			map.reset(0, 0);
			map.loadMap(_lvlStr, tiles, 16, 16, FlxTilemap.OFF, 0, 0, 6);
			map.setDirty();
			
			var objs:Array = _lvlObj.split("\n");
			for each (var item:String in objs) {
				if (!item)
					continue;
				var obj:Array = item.split(",");
				if (obj[0] == "msg") {
					obj.shift();
					var w:Window = FlxG.getPlugin(Window) as Window;
					w.sleep();
					if (!w)
						w = FlxG.addPlugin(new Window()) as Window;
					while (obj.length > 0)
						w.wakeup(obj.shift());
				}
				else
					(state.recycle(FlxU.getClass(obj[0])) as FlxObject).reset(int(obj[1]), int(obj[2]));
			}
		}
		
		static public function loadMap(map:FlxTilemap, level:String):void {
			var csv:String = new Maps[level];
			_lvlStr = csv;
			var objStr:String = new Maps["o" + level];
			_lvlObj = objStr;
			retry(map);
		}
		
		static public function levelName(lvl:int):String {
			var str:String = "_";
			if (lvl < 100)
				str += "0";
			if (lvl < 10)
				str += "0";
			str += lvl.toString();
			return str;
		}
		
		/*static public function reloadMap(map:FlxTilemap):void {
			var state:FlxState = FlxG.state;
			state.callAll("kill");
			
			map.reset(0, 0);
			map.loadMap(_lvlStr, tiles, 16, 16, FlxTilemap.OFF, 0, 0, 6);
			map.setDirty();
			
			var objs:Array = _lvlObj.split("\n");
			for each (var item:String in objs) {
				if (!item)
					continue;
				var obj:Array = item.split(",");
				if (obj[0] == "msg") {
					obj.shift();
					var w:Window = FlxG.getPlugin(Window) as Window;
					w.sleep();
					if (!w)
						w = FlxG.addPlugin(new Window()) as Window;
					while (obj.length > 0)
						w.wakeup(obj.shift());
				}
				else
					(state.recycle(FlxU.getClass(obj[0])) as FlxObject).reset(int(obj[1]), int(obj[2]));
			}
		}*/
		
		static public function levelSelector(X:Number, Y:Number, perLine:int = 5):FlxGroup {
			var g:FlxGroup = new FlxGroup();
			var bt:FlxButton;
			var x:Number;
			var y:Number;
			var i:int = 0;
			while (i < _maxLevel) {
				x = X + (i % perLine) * (FlxG.width - 2 * X) / perLine;
				y = Y + (i / perLine) * (FlxG.height - 2 * Y) / (_maxLevel / perLine);
				bt = new FlxButton(x, y, (i+1)+"", function():void { Maps.setLevel(this.ID); FlxG.switchState(new Playstate()); } );
				bt.ID = i;
				bt.loadGraphic(gfx, true, false, 20, 20);
				bt.scale.make(2, 2);
				bt.width *= 2;
				bt.height *= 2;
				bt.centerOffsets();
				bt.label.size = 16;
				bt.labelOffset.x += 4;
				bt.labelOffset.y += 4;
				
				if (i >= _enabledLevels)
					bt.active = false;
				
				bt.preUpdate();
				bt.update();
				if (i >= _enabledLevels)
					bt.frame = 2;
				bt.postUpdate();
				g.add(bt);
				i++;
			}
			return g;
		}
		
		static public function setLevel(val:int):void {
			var name:String = levelName(val);
			_curLevel = val;
			var csv:String = new Maps[name];
			_lvlStr = csv;
			var objStr:String = new Maps["o" + name];
			_lvlObj = objStr;
		}
		
		static public function manualLoad(map:FlxTilemap, level:String, objs:String):void {
			_lvlStr = level;
			_lvlObj = objs;
			retry(map);
		}
	}
}
