import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class HUD extends FlxTypedGroup<FlxSprite>
{
	var topBar:FlxSprite;

	public function new()
	{
		super();
		topBar = new FlxSprite().makeGraphic(FlxG.width, 30, FlxColor.fromInt(0xff3b3b3b));
		add(topBar);

		topBar.scrollFactor.set(0, 0);
	}
}
