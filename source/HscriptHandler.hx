package;

import hscript.Interp;

import PlayState;  
import Discord;
import Character;
import Boyfriend;
import Song;
import GameOverSubstate;
import HealthIcon;
import sys.FileSystem;
import sys.io.File;
import haxe.Json;
import Section;
import StrumNote;
import ClientPrefs;
import Conductor;
import Note; 
import MainMenuState; 
import NoteSplash; 

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class HscriptHandler {
    public static function setVars(interp:Interp) {
        interp.variables.set('PlayState', PlayState);
        interp.variables.set('Character', Character);
        interp.variables.set('Paths', Paths);
        interp.variables.set('Boyfriend', Boyfriend);
        interp.variables.set('HealthIcon', HealthIcon);
        interp.variables.set('StrumNote', StrumNote);
        interp.variables.set('Conductor', Conductor);
        interp.variables.set('ClientPrefs', ClientPrefs);
        interp.variables.set('GameOverSubstate', GameOverSubstate);
        interp.variables.set('Note', Note);
        interp.variables.set('FlxG', FlxG);
        interp.variables.set('MainMenuState', MainMenuState);
        interp.variables.set('Song', Song);
        interp.variables.set('FlxGame', FlxGame);
        interp.variables.set('FlxBackdrop', FlxBackdrop);
        interp.variables.set('FlxBar', FlxBar);
        interp.variables.set('Section', Section);
        interp.variables.set('FlxState', FlxState);
        interp.variables.set('FlxEase', FlxEase);
        interp.variables.set('FlxTween', FlxTween);
        interp.variables.set('NoteSplash', NoteSplash);
        interp.variables.set('FlxSprite', FlxSprite);
        interp.variables.set('FlxBasic', FlxBasic);
        return interp;
    }
}