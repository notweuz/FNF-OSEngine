package;

import hscript.Interp;

import PlayState;  
import Discord;
import Character;
import Boyfriend;
import Song;
import GameOverSubstate;
import HealthIcon;
import Section;
import StrumNote;
import ClientPrefs;
import Note; 
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

class HscriptHandler {
    public static function setVars(interp:Interp) {
        interp.variables.set('PlayState', PlayState);
        interp.variables.set('Character', Character);
        interp.variables.set('Boyfriend', Boyfriend);
        interp.variables.set('HealthIcon', HealthIcon);
        interp.variables.set('StrumNote', StrumNote);
        interp.variables.set('ClientPrefs', ClientPrefs);
        interp.variables.set('GameOverSubstate', GameOverSubstate);
        interp.variables.set('Note', Note);
        interp.variables.set('FlxG', FlxG);
        interp.variables.set('Song', Song);
        interp.variables.set('FlxGame', FlxGame);
        interp.variables.set('FlxBar', FlxBar);
        interp.variables.set('Section', Section);
        interp.variables.set('FlxState', FlxState);
        interp.variables.set('NoteSplash', NoteSplash);
        interp.variables.set('FlxSprite', FlxSprite);
        interp.variables.set('FlxBasic', FlxBasic);
        return interp;
    }
}