import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class Enemy extends FlxSprite
{
	public static var maxSpeed = 100;
	public static var maxHealth = 5;
	public static var maxDamage = 2;

	public var speed:Float;
	public var damage:Float;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		speed = maxSpeed;
		health = maxHealth;
		damage = maxDamage;
		makeGraphic(20, 20, FlxColor.CYAN);
	}

	override function update(elapsed:Float)
	{
		if (health <= 0)
			kill();
		updateMovement();
		super.update(elapsed);
	}

	function updateMovement()
	{
		var playState:PlayState = cast FlxG.state;
		var player = playState.gunMan;
		angle = FlxAngle.angleBetween(this, player, true);
		velocity.setPolarDegrees(speed, angle);
	}

	override function reset(x:Float, y:Float)
	{
		super.reset(x, y);
		speed = maxSpeed;
		health = maxHealth;
		damage = maxDamage;
	}

	override function kill()
	{
		alive = false;
		FlxTween.tween(this, {alpha: 0}, 0.33, {ease: FlxEase.circOut, onComplete: finishKill});
	}

	function finishKill(_)
	{
		exists = false;
	}
}
