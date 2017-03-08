package objs {
	
	import objs.basic.*;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import states.Playstate;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Player extends Basic {
		
		[Embed(source = "../../assets/sfx/jump.mp3")]		private var jSFX:Class;
		[Embed(source = "../../assets/sfx/death.mp3")]		private var dSFX:Class;
		
		[Embed(source = "../../assets/gfx/objs/player.png")]		private var gfx:Class;
		[Embed(source = "../../assets/gfx/objs/playerEyes.png")]		private var gfxE:Class;
		
		protected const speed:Number = 512;
		protected const maxSpeed:Number = 156;
		protected const runMaxSpeed:Number = 320;
		protected const cShootDelay:Number = 10;
		
		protected var canJump:Boolean;
		protected var y0:Number;
		protected var releaseHeight:Number;
		protected var minJumpSpeed:Number;
		protected var maxJumpSpeed:Number;
		
		protected var canRun:Boolean;
		public var canPush:Boolean;
		
		protected var canShoot:Boolean;
		protected var shootDelay:Number;
		
		private var _panel:Panel;
		private var jSound:FlxSound;
		private var dSound:FlxSound;
		
		public function Player() {
			super();
			loadGraphic(gfx, true, true, 16, 16);
			addAnimation("stand", [0, 0, 0, 1, 0, 0, 0, 2, 3, 3, 2, 1, 0, 0], 8);
			addAnimation("walk", [6, 7, 9, 8, 9, 7], 8);
			addAnimation("push", [12, 13, 15, 14, 15, 13], 8);
			addAnimation("jump", [5, 11], 8, false);
			addAnimation("death", [4, 10, 16], 8, false);
			width = 15;
			height = 15;
			centerOffsets();
			
			acceleration.y = gravity;
			drag.x = 1024;
			maxVelocity.x = maxSpeed;
			
			reset(0, 0);
		}
		override public function destroy():void {
			super.destroy();
			_panel = null;
			if (jSound)
				jSound.destroy();
			jSound = null;
			if (dSound)
				dSound.destroy();
			dSound = null;
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			
			alive = true;
			alpha = 1;
			color = 0xffffff;
			play("stand");
			_panel = null;
			
			canJump = false;
			maxJumpSpeed = getVY(3.2 * 16.125);
			minJumpSpeed = getVY(0.5 * 16.125);
			releaseHeight = 2.7 * height;
			
			canShoot = false;
			shootDelay = 0;
			
			canRun = false;
			maxVelocity.x = maxSpeed;
			
			canPush = false;
		}
		
		override public function update():void {
			if (!alive) {
				if (finished)
					exists = false;
				return;
			}
			if (!onScreen()) {
				coolDeath();
				return;
			}
			updateControls();
			manageAnimation();
		}
		
		public function coolDeath():void {
			if (!alive)
				return;
			alive = false;
			play("death");
			FlxG.camera.shake();
			FlxG.camera.flash();
			if (!dSound)
				dSound = FlxG.loadSound(dSFX, 1.0, false, false, true);
			else
				dSound.play();
		}
		
		public function switchTo(panel:Panel):void {
			if (_panel)
				_panel.activate();
			
			if (canJump)
				canJump = false;
			else if (canShoot)
				canShoot = false;
			else if (canPush)
				canPush = false;
			else if (canRun) {
				canRun = false;
				maxVelocity.x = maxSpeed;
			}
			switch(panel.type) {
				case Panel.PUSH : canPush = true; color = 0xe8a54e; break;
				case Panel.JUMP : canJump = true; color = 0x80c880; break;
				case Panel.SHOOT : canShoot = true; shootDelay = 0; break;
				case Panel.RUN : canRun = true; maxVelocity.x = runMaxSpeed; color = 0x81bbd7;break;
			}
			
			panel.deactivate();
			_panel = panel;
		}
		
		protected function manageAnimation():void {
			if (!alive && _curAnim.name != "death")
				play("death");
			else if (canPush && (touching & WALL) != 0)
				play("push");
			else if (touching & DOWN)
				if (FlxG.keys.justPressed("X"))
					play("jump");
				else if (velocity.x != 0)
					play("walk");
				else
					play("stand");
		}
		
		protected function updateControls():void {
			if (FlxG.keys.LEFT) {
				acceleration.x = -speed;
				if (velocity.x > 0) {
					velocity.x -= speed * FlxG.elapsed;
					Playstate.explode(this, 60, 100, -10, 10,0.5);
				}
				facing = LEFT;
			}
			else if (FlxG.keys.RIGHT) {
				acceleration.x = speed;
				if (velocity.x < 0) {
					velocity.x += speed * FlxG.elapsed;
					Playstate.explode(this, -100, -60, -10, 10,0.5);
				}
				facing = RIGHT;
			}
			else
				acceleration.x = 0;
			
			if (canJump)
				if ((touching & DOWN) && FlxG.keys.justPressed("X")) {
					velocity.y = -maxJumpSpeed;
					y0 = y;
					var min:Number = FlxU.min( -velocity.x / 10, -velocity.x/2);
					var max:Number = FlxU.max( -velocity.x / 10, -velocity.x/2);
					Playstate.explode(this, min-20, max+20, 20, 70, 8);
					if (!jSound)
						jSound = FlxG.loadSound(jSFX, 1.0, false, false, true);
					else
						jSound.play(true);
				}
				else if (!isNaN(y0) && !FlxG.keys.X)
					if (velocity.y < 0 && y0 - y < releaseHeight) {
						y0 = NaN;
						velocity.y = -minJumpSpeed;
					}
					else
						y0 = NaN;
			
			if (canShoot)
				if (shootDelay <= 0 && FlxG.keys.C) {
					shootDelay = cShootDelay;
					var b:Bullet = FlxG.state.recycle(Bullet)as Bullet;
					var _x:Number = x - 2;
					if (facing == RIGHT)
						_x += width + 4;
					b.facing = facing;
					b.reset(_x, y + height / 2);
				}
				else if (shootDelay > 0)
					shootDelay -= FlxG.elapsed;
		}
		
		protected function getVY(Height:Number):Number {
			var t:Number = Math.sqrt(Height * 2 / acceleration.y);
			return acceleration.y * t;
		}
	}
}
