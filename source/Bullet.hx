import flixel.FlxSprite;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	public static final SPEED = 1000;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		makeGraphic(10, 3, FlxColor.GRAY);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override function reset(x:Float, y:Float)
	{
		super.reset(x, y);
		velocity.setPolarDegrees(SPEED, angle);
	}
}
