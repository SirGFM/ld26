package states {
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import utils.Maps;

	/**
	 * ...
	 * @author GFM
	 */
	public class Teststate extends Playstate {
		
		private var bt:FlxButton;
		
		public function Teststate() {
			super();
			bt = new FlxButton(0, 10, "load", onLoad);
			bt.x = 512 - bt.width;
		}
		
		override public function update():void {
			super.update();
			bt.preUpdate();
			bt.update();
			bt.postUpdate();
		}
		
		override public function draw():void {
			super.draw();
			bt.draw();
		}
		
		private var _level:String;
		private var _loadFile:FileReference;
		private function onLoad():void {
			_loadFile = new FileReference();
			_loadFile.addEventListener(Event.SELECT, selectLvlLoad);
			var fileFilter:FileFilter = new FileFilter("Stage: (*.txt)", "*.txt");
			_loadFile.browse([fileFilter]);
		}
		private function selectLvlLoad(ev:Event):void {
			_loadFile.removeEventListener(Event.SELECT, selectLvlLoad);
			_loadFile.addEventListener(Event.COMPLETE, importLvlLoadComplete);
			_loadFile.load();
		}
		private function importLvlLoadComplete(event:Event):void {
			_loadFile.removeEventListener(Event.COMPLETE, importLvlLoadComplete);
			_level = _loadFile.data.toString();
			
			_loadFile = new FileReference();
			_loadFile.addEventListener(Event.SELECT, selectObjLoad);
			var fileFilter:FileFilter = new FileFilter("Objects: (*.txt)", "*.txt");
			_loadFile.browse([fileFilter]);
		}
		private function selectObjLoad(ev:Event):void {
			_loadFile.removeEventListener(Event.SELECT, selectObjLoad);
			_loadFile.addEventListener(Event.COMPLETE, importObjLoadComplete);
			_loadFile.load();
		}
		private function importObjLoadComplete(event:Event):void {
			_loadFile.removeEventListener(Event.COMPLETE, importObjLoadComplete);
			var str:String = _loadFile.data.toString();
			Maps.manualLoad(map, _level, str);
		}
	}
}
