package states {
	
	import objs.basic.Basic;
	import objs.Bullet;
	import objs.map.*;
	import objs.basic.Panel;
	import objs.Player;
	import org.flixel.FlxBasic;
	import org.flixel.FlxButton;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	import plugins.Menu;
	import plugins.Reset;
	import plugins.Twitter;
	import plugins.Window;
	import utils.Maps;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Playstate extends FlxState {
		
		[Embed(source = "../../assets/sfx/goal.mp3")]	private var sfx:Class;
		
		[Embed(source = "../../assets/gfx/objs/cloud.png")]		private var gfx:Class;
		
		private static var self:Playstate;
		
		private var _pl:Player;
		private var map:FlxTilemap;
		
		private var fading:Boolean;
		private var sound:FlxSound;
		
		private var _emitter:FlxEmitter;
		
		override public function create():void {
			FlxG.worldBounds.make(0, 0, 512, 512);
			
			_pl = new Player();
			
			map = new FlxTilemap();
			
			add(_pl);
			
			fading = false;
			Maps.retry(map);
			
			
			var b:FlxBasic = FlxG.getPlugin(Twitter);
			if (b)
				b.exists = false;
			b = FlxG.getPlugin(Reset);
			if (!b)
				FlxG.addPlugin(new Reset());
			else
				b.exists = true;
			b = FlxG.getPlugin(Menu);
			if (!b)
				FlxG.addPlugin(new Menu());
			else
				b.exists = true;
			
			Maps.playMusic();
			
			self = this;
			
			_emitter = new FlxEmitter(0, 0, 128);
			_emitter.makeParticles(gfx, 128, 360, false, 0);
			_emitter.setRotation( -360, 360);
			add(_emitter);
		}
		override public function destroy():void {
			super.destroy();
			map.destroy();
			map = null;
			if (sound)
				sound.destroy();
			sound = null;
		}
		
		override public function update():void {
			var i:int;
			var obj:FlxObject;
			
			if (!_pl.exists) {
				Maps.retry(map);
			}
			
			super.update();
			map.preUpdate();
			map.update();
			map.postUpdate();
			
			FlxG.overlap(this, null, onOverlap);
			i = 0;
			while (i < length) {
				obj = members[i++] as FlxObject;
				if (obj && obj != map && obj.exists && obj.moves)
					map.overlapsWithCallback(obj, FlxObject.separate);
			}
		}
		override public function draw():void {
			map.draw();
			super.draw();
		}
		
		static public function onRetry():void {
			Maps.retry(self.map);
		}
		
		public function onOverlap(o1:FlxObject, o2:FlxObject):void {
			var notSkip:Boolean = true;
			var pl:Player = getFromClass(o1, o2, Player) as Player;
			var panel:Panel = getFromClass(o1, o2, Panel) as Panel;
			if (panel) {
				if (pl && panel.active)
					pl.switchTo(panel);
				return;
			}
			
			if (pl && getFromClass(o1, o2, Goal)) {
				Maps.next(map);
				FlxG.camera.flash();
				if (!sound)
					sound = FlxG.loadSound(sfx, 1.0, false, false, true);
				else
					sound.play(true);
				return;
			}
			
			// if it's working, don't touch it... don't even look at it!
			var push:Pushable = getFromClass(o1, o2, Pushable) as Pushable;
			if (push) {
				var down:uint = FlxObject.DOWN
				notSkip = false;
				if (pl) {
					if (!pl.canPush)
						push.immovable = true;
					FlxObject.separateX(pl, push);
					push.immovable = true;
					if (FlxObject.separateY(pl, push) && (pl.y < push.y))
						pl.y = push.y - pl.height-0.1;
					push.immovable = false;
				}
				else {
					var t1:uint = o1.touching;
					var t2:uint = o2.touching;
					var i1:Boolean = o1.immovable;
					var i2:Boolean = o2.immovable;
					o1.touching = 0;
					o2.touching = 0;
					if (FlxObject.separate(o1, o2) && (o1.touching & down) == 0 && (o2.touching & down) == 0) {
						o1.x = o1.last.x;
						o2.x = o2.last.x;
					}
					else if (!i1 && !i2) {
						if (o1.y < o2.y)
							o2.immovable = true;
						else
							o1.immovable = true;
						FlxObject.separateY(o1, o2);
						o1.immovable = i1;
						o2.immovable = i2;
					}
					o1.touching |= t1;
					o2.touching |= t2;
				}
			}
			// if it's working, don't touch it... don't even look at it!
			
			if (notSkip)
				FlxObject.separate(o1, o2);
			
			var bl:Bullet = getFromClass(o1, o2, Bullet) as Bullet;
			if (bl)
				bl.kill();
			
			var br:Breakable = getFromClass(o1, o2, Breakable) as Breakable;
			if (br && bl) {
				br.deactivate();
				return;
			}
			
			var sand:Sand = getFromClass(o1, o2, Sand) as Sand;
			if (sand) {
				sand.deactivate();
				return;
			}
			
			var tmp:FlxObject;
			var spring:Spring = getFromClass(o1, o2, Spring) as Spring;
			if (spring) {
				tmp = getDiffClass(o1, o2, Spring) as FlxObject; 
				if ((tmp.touching & FlxObject.DOWN) && (spring.touching & FlxObject.UP))
					spring.activate(getDiffClass(o1, o2, Spring) as FlxObject);
				return;
			}
			
			var spike:Spike = getFromClass(o1, o2, Spike) as Spike;
			if (spike && !push) {
				tmp = getDiffClass(o1, o2, Spike) as FlxObject; 
				if ((tmp.touching & FlxObject.DOWN) && (spike.touching & FlxObject.UP))
					if (pl)
						pl.coolDeath();
					else
						tmp.kill();
				return;
			}
		}
		
		private function getFromClass(o1:Object, o2:Object, _class:Class):Object {
			return (o1 is _class?o1:(o2 is _class?o2:null));
		}
		private function getDiffClass(o1:Object, o2:Object, _class:Class):Object {
			return (!(o1 is _class)?o1:(!(o2 is _class)?o2:null));
		}
		
		static public function get player():Player {
			return self._pl;
		}
		
		static public function get Map():FlxTilemap {
			return self.map;
		}
		
		static public function explode(who:FlxObject, minsx:Number, sx:Number, minsy:Number, sy:Number, amount:Number = 1):void {
			if (amount < 1)
				if (FlxG.random() > amount)
					return;
				else
					amount = 1;
			self._emitter.at(who);
			self._emitter.setXSpeed(minsx, sx);
			self._emitter.setYSpeed(minsy, sy);
			self._emitter.start(true, 0.5, 0, amount);
		}
		
		static public function getPanelByID(id:int):Panel {
			var tmp:Panel;
			var i:int = 0;
			
			while (i < self.length)
				if ( (tmp = self.members[i++]) && tmp.ID == id)
					return tmp;
			
			return null;
		}
	}
}
