package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.FlxAccelerometer;
import flixel.math.FlxRandom;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	var numBullets:Int = 80;
	var numEnemies:Int = 800;
	var waveTime:Float = 5.0;
	var gameOver:Bool = false;

	public var gunMan:Gun;
	public var bullets:FlxTypedGroup<FlxSprite>;
	public var enemies:FlxTypedGroup<FlxSprite>;

	var monitorCamera:FlxCamera;
	var monitor:FlxSprite;

	var hud:HUD;

	var randomGen:FlxRandom;

	override public function create()
	{
		super.create();

		randomGen = new FlxRandom();

		FlxG.log.redirectTraces = true;

		// create our man
		gunMan = new Gun();
		gunMan.loadGraphic(AssetPaths.player__png, true, 32, 32);
		add(gunMan);

		// create the bullets offscreen
		var temp:FlxSprite;
		bullets = new FlxTypedGroup<FlxSprite>(numBullets);
		for (i in 0...numBullets)
		{
			temp = new Bullet(-100, -100);
			temp.exists = false;
			bullets.add(temp);
		}
		add(bullets);

		// create the enemies
		enemies = new FlxTypedGroup<FlxSprite>(numEnemies);
		for (i in 0...numEnemies)
		{
			temp = new Enemy(-100, -100);
			temp.exists = false;
			enemies.add(temp);
		}
		add(enemies);

		hud = new HUD();
		add(hud);

		monitorCamera = new FlxCamera(0, 0, FlxG.camera.width, FlxG.camera.height);
		monitorCamera.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(monitorCamera, false);
		monitor = new FlxSprite();
		monitor.loadGraphic(AssetPaths.monitor__png, false, 640, 480);
		monitor.cameras = [monitorCamera];
		add(monitor);

		FlxG.camera.follow(gunMan, TOPDOWN_TIGHT, 1);
		FlxG.camera.zoom = 1.5;
		newWave();
	}

	override public function update(elapsed:Float)
	{
		FlxG.watch.add(gunMan, "health");

		// collisions only work in worldBounds
		// Im so glad I wasn't told that :(
		var pX = gunMan.x;
		var pY = gunMan.y;
		FlxG.worldBounds.set(pX - 320, pY - 240, 640, 480);

		FlxG.collide(enemies, bullets, enemyHit);
		FlxG.collide(gunMan, enemies, playerHit);
		FlxG.collide(enemies, enemies);

		super.update(elapsed);
		if (gameOver)
		{
			return;
		}
	}

	function newWave(?timer:FlxTimer):Void
	{
		trace("placing enemies");
		trace("alive:" + enemies.countLiving());
		trace("dead: " + enemies.countDead());
		var enemy:FlxSprite;

		for (i in 0...10)
		{
			var eX = randomGen.float(-640, -320) + gunMan.x;
			var eY = randomGen.float(-480, -240) + gunMan.y;
			enemy = enemies.recycle();
			enemy.reset(eX, eY);
		}
		for (i in 0...10)
		{
			var eX = randomGen.float(320, 640) + gunMan.x;
			var eY = randomGen.float(240, 480) + gunMan.y;
			enemy = enemies.recycle();
			enemy.reset(eX, eY);
		}

		new FlxTimer().start(waveTime, newWave);
	}

	function playerHit(player:FlxSprite, enemy:Enemy):Void
	{
		if (gunMan.canTakeDamage)
		{
			FlxTween.tween(gunMan, {color: FlxColor.RED}, 0.3, {ease: FlxEase.circInOut, type: FlxTweenType.BACKWARD});
			gunMan.health -= enemy.damage;
			gunMan.canTakeDamage = false;
			new FlxTimer().start(gunMan.invulTime, resetInvul);
		}
		if (gunMan.health <= 0)
		{
			gameOver = true;
			FlxG.camera.fade(FlxColor.BLACK, 0.3, false, goToMenu);
		}

		enemy.kill();
	}

	function resetInvul(?timer:FlxTimer):Void
	{
		gunMan.canTakeDamage = true;
	}

	function enemyHit(enemy:FlxSprite, bullet:FlxSprite):Void
	{
		bullet.kill();
		enemy.health -= gunMan.damage;
	}

	function goToMenu()
	{
		FlxG.switchState(new MenuState());
	}
}
