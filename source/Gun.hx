import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

class Gun extends FlxSprite
{
	final baseHealth:Float = 1;
	final baseSpeed:Float = 100;
	final baseSpread:Float = 5.0;
	final baseFireDelay:Float = 0.01;
	final baseInvulTime:Float = 1.0;
	final baseDamage:Float = 1;

	// health exists in background
	public var speed:Float;
	public var spread:Float;
	public var fireDelay:Float;
	public var invulTime:Float;
	public var damage:Float;

	public var multipliers:Array<Float>;
	public var sArray:Array<Int>;

	var canFire:Bool = true;

	public var canTakeDamage:Bool = true;

	public function new()
	{
		super();

		drag.x = drag.y = 800;

		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);

		multipliers = [1, 1, 1, 1, 1, 1];
		sArray = [0, 1, 2, 3, 4, 5];

		myShuffle(sArray);

		multipliers[sArray[0]] = 10;
		multipliers[sArray[1]] = 2;
		multipliers[sArray[3]] = 10;

		updateVars();
	}

	function myShuffle(arr:Array<Int>):Array<Int>
	{
		for (i in 0...10)
		{
			arr[FlxG.random.int(0, arr.length - 1)] = FlxG.random.int(0, arr.length - 1);
		}
		return arr;
	}

	function updateVars()
	{
		health = baseHealth * multipliers[sArray[0]];
		speed = baseSpeed * multipliers[sArray[1]];
		spread = baseSpread * multipliers[sArray[2]];
		fireDelay = baseFireDelay * multipliers[sArray[3]];
		invulTime = baseInvulTime * multipliers[sArray[4]];
		damage = baseDamage * multipliers[sArray[5]];
	}

	override function update(elapsed:Float)
	{
		var pointerAngle = FlxAngle.angleBetweenMouse(this, true);
		if (pointerAngle >= 90 || pointerAngle <= -90)
			facing = RIGHT;
		else
			facing = LEFT;

		updateMovement();
		updateShooting();
		super.update(elapsed);
	}

	function updateShooting()
	{
		if (FlxG.mouse.pressed)
		{
			if (canFire)
			{
				// create the bullet
				var playState:PlayState = cast FlxG.state;
				var bullet:FlxSprite = playState.bullets.recycle();
				var pointerAngle = FlxAngle.angleBetweenMouse(this, true);
				bullet.angle = pointerAngle + FlxG.random.float(-spread, spread);
				var mid:FlxPoint = getMidpoint();
				bullet.reset(mid.x, mid.y);

				// start the timer
				canFire = false;
				new FlxTimer().start(fireDelay, letFire);
			}
		}
	}

	function letFire(?Timer:FlxTimer):Void
	{
		this.canFire = true;
	}

	function updateMovement()
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);

		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		if (up || down || left || right)
		{
			var newAngle:Float = 0;
			if (up)
			{
				newAngle = -90;
				if (left)
					newAngle -= 45;
				else if (right)
					newAngle += 45;
			}
			else if (down)
			{
				newAngle = 90;
				if (left)
					newAngle += 45;
				else if (right)
					newAngle -= 45;
			}
			else if (left)
				newAngle = 180;
			else if (right)
				newAngle = 0;

			velocity.setPolarDegrees(speed, newAngle);
		}
	}
}
