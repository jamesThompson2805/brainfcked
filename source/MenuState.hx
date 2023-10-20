import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	var text:FlxText;
	var textCol:FlxColor;

	var tape:Array<Float>;
	var bf:BrainFuck;

	override public function create()
	{
		super.create();

		FlxG.sound.volumeUpKeys = null;
		FlxG.sound.volumeDownKeys = null;

		text = new FlxText();
		text.text = "";
		textCol = FlxColor.fromInt(0xff04e9ac);
		text.color = textCol;
		text.size = 32;

		text.alignment = FlxTextAlign.CENTER;
		text.screenCenter();

		tape = [1, 0, 2];
		bf = new BrainFuck(tape);
		FlxG.log.redirectTraces = true;

		text.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.fromInt(0xff10845c), 1);
		add(text);
	}

	override function update(elapsed:Float)
	{
		var symbol:String = "";
		if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.PERIOD)
			symbol = ">";
		else if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.COMMA)
			symbol = "<";
		else if (FlxG.keys.justPressed.PLUS)
			symbol = "+";
		else if (FlxG.keys.justPressed.MINUS)
			symbol = "-";
		else if (FlxG.keys.justPressed.LBRACKET)
			symbol = "[";
		else if (FlxG.keys.justPressed.RBRACKET)
			symbol = "]";
		else if (FlxG.keys.justPressed.BACKSPACE)
		{
			if (text.text.length > 0)
				text.text = text.text.substr(0, text.text.length - 1);
		}
		else if (FlxG.keys.justPressed.ENTER)
		{
			var success = bf.evalExpr(text.text);
			if (!success)
			{
				FlxTween.color(text, 0.5, FlxColor.fromInt(0xffb61a29), textCol);
			}
			else
				trace(bf.getTape());
		}

		text.text = text.text + symbol;
		text.screenCenter();
		super.update(elapsed);
	}
}
