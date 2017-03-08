package plugins {

	import flash.events.Event;
	import flash.net.FileReference;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class StateWatcher extends FlxBasic {
		
		static public var self:StateWatcher;
		
		private var _frames:Array;
		private var _curFrame:int;
		private var _working:Boolean;
		private var _file:FileReference;
		
		public function StateWatcher() {
			super();
			_working = false;
			self = this;
		}
		
		public function start():void {
			_frames = new Array();
			_curFrame = 0;
			_working = true;
			FlxG.camera.flash(0xaa0000ff, 0.5);
		}
		public function stop():void {
			_working = false;
			FlxG.camera.flash(0xaaff0000, 0.5);
		}
		public function save():void {
			if (_frames.length == 0 || _file != null)
				return;
			_file = new FileReference();
			var string:String = "";
			while (_frames.length > 0)
				string += _frames.shift();
			_file.addEventListener(Event.COMPLETE, onComplete);
			_file.save(string, "state.txt");
		}
		public function write(str:String):void {
			if (_working)
				_frames[_curFrame] += str+"\n";
		}
		
		// Before FlxState.update()
		override public function update():void {
			if (FlxG.keys.CONTROL)
				if (FlxG.keys.justPressed("ONE"))
					start();
				else if (FlxG.keys.justPressed("TWO"))
					stop();
				else if (FlxG.keys.justPressed("S"))
					save();
			if (_working)
				_frames[_curFrame] = "--------------frame_"+_curFrame+"--------------\n";
		}
		// After FlxState.update()
		override public function draw():void {
			if (_working) {
				_frames[_curFrame] +="--------------frame_"+_curFrame+"--------------\n";
				_curFrame++;
			}
		}
		
		private function onComplete(e:Event):void {
			_file.removeEventListener(Event.COMPLETE, onComplete);
			_file = null;
			FlxG.camera.flash(0xaaffffff, 0.5);
		}
	}
}
