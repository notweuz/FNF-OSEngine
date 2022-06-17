package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import flixel.addons.display.FlxBackdrop;
import flash.system.System;

using StringTools;

class GameExitState extends MusicBeatState
{
	var options:Array<String> = ['Yes', 'No'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
    public static var menuText:Alphabet;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Yes':
                //trace('david loh');
                //trace(menuText.x);
                //trace(menuText.y);
                System.exit(0);
			case 'No':
                FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Game Closing Menu", null);
		#end

        var bg:FlxBackdrop = new FlxBackdrop(Paths.image('loading'), 0.2, 0, true, true);
		bg.velocity.set(200, 110);
		bg.alpha = 0.5;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

        menuText = new Alphabet(0, 0, "Quit the game?", true, false, 0, 1);
        menuText.screenCenter();
        menuText.y -= 150;
		menuText.alpha = 1;
        add(menuText);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true, false);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true, false);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true, false);
		add(selectorRight);

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}