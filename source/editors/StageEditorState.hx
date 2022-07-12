package editors;

#if desktop
import Discord.DiscordClient;
#end
import animateatlas.AtlasFrameMaker;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import Paths;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import haxe.Json;
import Character;
import flixel.system.debug.interaction.tools.Pointer.GraphicCursorCross;
import lime.system.Clipboard;
import flixel.animation.FlxAnimation;

#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

class StageEditorState extends MusicBeatState
{
	var bf:Character;
    var dad:Character;
    var gf:Character;

	var UI_box:FlxUITabMenu;

    var characterList:Dynamic;

    var guideButton:FlxButton;
    var betaTXT:FlxText;

    private var camEditor:FlxCamera;
	private var camHUD:FlxCamera;

    var bfjson:Dynamic;
    var gfjson:Dynamic;
    var dadjson:Dynamic;
    var top10awesome:Dynamic;

    var bfidle:Array<Int> = [0, 0];
    var gfidle:Array<Int> = [0, 0];
    var dadidle:Array<Int> = [0, 0];

    var daAnim:String;

	private var camMenu:FlxCamera;

    var selectedObj:FlxSprite;
    var objectName:String;
    var tagName:String;

    var selectedObjName:Int; // it's supposed to be a string, but its int now

	var bgLayer:FlxTypedGroup<FlxSprite>;

    var bgMap:Map<FlxSprite, Dynamic> = [];

	var charLayer:FlxTypedGroup<Character>;

    var spritesLayer:Array<String> = [];

    var defaultcamzoom:Float = 1;
    var stageispixel:Bool = false;

    var charactersOnStage:Array<String>;
    var charactersObjects:Array<Character>;

	var camFollow:FlxObject;
	var cameraFollowPointer:FlxSprite;

    override function create() {
		FlxG.sound.playMusic(Paths.music('breakfast'), 0.5);

        camEditor = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camMenu = new FlxCamera();
		camMenu.bgColor.alpha = 0;

        var uibox_tabs = [
            {name: 'Characters', label: 'Characters'},
            {name: 'Objects Info', label: 'Objects Info'},
            {name: 'Add/Remove', label: 'Add/Remove'},
        ];

        betaTXT = new FlxText(12, FlxG.height - 24, 0, "ALPHA", 20);
		betaTXT.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		betaTXT.scrollFactor.set();
		betaTXT.borderSize = 1;
		betaTXT.cameras = [camMenu];
        betaTXT.visible = true;
		add(betaTXT);

		FlxG.cameras.reset(camEditor);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camMenu);
		FlxCamera.defaultCameras = [camEditor];

        UI_box = new FlxUITabMenu(null, uibox_tabs, true);
		UI_box.cameras = [camMenu];

		UI_box.resize(300, 250);
		UI_box.x = FlxG.width - 325;
		UI_box.y = 25;
		UI_box.scrollFactor.set();

        var tipTextArray:Array<String> = "E/Q - Camera Zoom In/Out
        \nO/P - Object Size Increase/Decrease
		\nR - Reset Camera Zoom
		\nJKLI - Move Camera
		\nArrow Keys - Move Object Offset
		\nHold Shift to Move 10x faster
        \nHold Ctrl to Move 100x faster\n".split('\n');

		for (i in 0...tipTextArray.length-1)
		{
			var tipText:FlxText = new FlxText(FlxG.width - 320, FlxG.height - 15 - 16 * (tipTextArray.length - i), 300, tipTextArray[i], 12);
			tipText.cameras = [camHUD];
			tipText.setFormat(null, 12, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
			tipText.scrollFactor.set();
			tipText.borderSize = 1;
			add(tipText);
		}

        camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

        bgLayer = new FlxTypedGroup<FlxSprite>();
		add(bgLayer);
		charLayer = new FlxTypedGroup<Character>();
		add(charLayer);

		FlxG.camera.follow(camFollow);
        FlxG.camera.zoom = 0.5; // big big big big big

        bf = new Boyfriend(1500, 0, "bf");
        gf = new Character(600, 0, "gf", false);
        dad = new Character(0, 0, "dad", false);

        charLayer.add(gf);
        charLayer.add(dad);
        charLayer.add(bf);

        charactersOnStage = ['bf', 'gf', 'dad'];
        charactersObjects = [bf, gf, dad];

        for (i in charactersObjects) {
            i.updateHitbox(); //dflsdflsdkfdslfkslfk hitboxes i hate them so much
        }

		add(UI_box);

        selectedObj = bf;

        for (i in charactersOnStage) {
            var cjson:CharacterFile = characterjson(i);
            
            if (i == 'dad') {
                dadjson = cjson;
                dadidle = getIdleOffset('dad');
            } else if (i == 'gf') {
                gfjson = cjson;
                gfidle = getIdleOffset('gf');
            } else {
                bfjson = cjson;
                bfidle = getIdleOffset('bf');
            }
        }

        addCharactersUI();
        addObjectsUI();
        addAddRemoveUI();

		UI_box.selected_tab_id = 'Add/Remove';

		FlxG.mouse.visible = true;

        guideButton = new FlxButton(12, FlxG.height - 50, "Guide", function() {
            CoolUtil.browserLoad("https://youtu.be/LwqHwiF4CF8"); // there's supposed to be google.com actually (cuz it should be funny... but it isn't)
        });
		guideButton.cameras = [camMenu];

        add(guideButton);

        #if desktop
        // Updating Discord Rich Presence
        DiscordClient.changePresence("In Stage Editor", "Making a stage...");
        #end

        super.create();
    }

    var objectInputText:FlxUIInputText;
    var tagInputText:FlxUIInputText;
    var objectAdd:FlxButton;
    var objectRemove:FlxButton;
    var spritesDropDown:FlxUIDropDownMenuCustom;

    function addAddRemoveUI() {
        var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Add/Remove";
        
        objectInputText = new FlxUIInputText(10, 30, 100, "examplefolder/example", 8);

        tagInputText = new FlxUIInputText(objectInputText.x + 150, objectInputText.y, 100, "tag", 8);

        objectAdd = new FlxButton(objectInputText.x, objectInputText.y + 22, "Add Sprite", function() {
            if (FileSystem.exists(Paths.modsImages(objectName))) {
                var sprite:FlxSprite = new FlxSprite();
                sprite.loadGraphic(Paths.image(objectName), false, 0, 0, false, objectName);
                sprite.x = 0;
                sprite.y = 0;
                sprite.updateHitbox();
                var objectArray:Array<Dynamic> = [
                    tagName,
                    objectName,
                    sprite.x,
                    sprite.y,
                    sprite.scale.x,
                    sprite.scale.y,
                    false,
                    sprite
                ];
                bgMap.set(sprite, objectArray);
                bgLayer.add(sprite);
                spritesLayer.push(objectArray[0]);
                selectedObj = sprite;
                selectedObj.updateHitbox();
                reloadSpritesDropdown();
            }
        });

        objectRemove = new FlxButton(objectAdd.x + 90, objectAdd.y, "Remove Sprite", function() {
            if (selectedObj != gf && selectedObj != bf && selectedObj != dad && selectedObj != null) {
                bgLayer.remove(selectedObj, true);
                for (i in bgMap.keys()) {
                    if (i == selectedObj) {
                        bgMap.remove(selectedObj);
                    }
                }
                selectedObj.destroy();
                spritesLayer.splice(selectedObjName, 1);
                selectedObj = bf;
                reloadSpritesDropdown();
                selectedObjName = -1;
                bgLayer.update(1);
            }
        });

        spritesDropDown = new FlxUIDropDownMenuCustom(objectInputText.x, objectInputText.y + 60, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(sprite:String)
		{
            bgLayer.update(1);
            selectedObj = bgLayer.members[Std.parseInt(sprite)];
            spritesDropDown.selectedLabel = "";
            selectedObjName = Std.parseInt(sprite);
            selectedObj.updateHitbox();
            updateCoords();
            updateSize();
		});

        tab_group.add(objectAdd);
        tab_group.add(objectRemove);
        tab_group.add(spritesDropDown);
		tab_group.add(new FlxText(spritesDropDown.x, spritesDropDown.y - 18, 0, 'Background Sprite:'));
		tab_group.add(new FlxText(objectInputText.x, objectInputText.y - 18, 0, 'Image Path:'));
		tab_group.add(new FlxText(tagInputText.x, tagInputText.y - 18, 0, 'Object Tag:'));
        tab_group.add(objectInputText);
        tab_group.add(tagInputText);
        UI_box.addGroup(tab_group);
	}

    var objCoords:FlxText;
    var objSize:FlxText;
    var objCopyCoords:FlxButton;
    var objCopySize:FlxButton;
    var saveCharacterCoordsBtn:FlxButton;
    var saveAdvancedCoordsBtn:FlxButton;

    function addObjectsUI() {
        var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Objects Info";

        objCoords = new FlxText(10, 30, 0, 'Object Coords: - -');
        objSize = new FlxText(objCoords.x, objCoords.y + 15, 0, 'Object Size: - -');

        objCopyCoords = new FlxButton(objSize.x, objSize.y + 20, "Copy Coords", function() {
            if (selectedObj != null && selectedObj != bf && selectedObj != gf && selectedObj != dad) {
                Clipboard.text = "makeLuaSprite('name', '"+ spritesLayer[selectedObjName] +"', "+ selectedObj.x +", "+ selectedObj.y +");";
            }
        });

        objCopySize = new FlxButton(objCopyCoords.x, objCopyCoords.y + 25, "Copy Size", function() {
            if (selectedObj != null && selectedObj != bf && selectedObj != gf && selectedObj != dad) {
                Clipboard.text = "scaleObject('name', "+ selectedObj.scale.x +", "+ selectedObj.scale.y +");";
            }
        });

        saveCharacterCoordsBtn = new FlxButton(objCopySize.x, objCopySize.y + 25, "Save Char Json", function() {
            saveCharacterCoords();
        });

        saveAdvancedCoordsBtn = new FlxButton(saveCharacterCoordsBtn.x+85, saveCharacterCoordsBtn.y, 'Save Advanced Json', function() {
            saveAdvancedJson();
        });

		var check_Pixel = new FlxUICheckBox(saveCharacterCoordsBtn.x, saveCharacterCoordsBtn.y+30, null, null, "Pixel Stage", 100);
		check_Pixel.checked = stageispixel;
		check_Pixel.callback = function()
		{
			stageispixel = check_Pixel.checked;
		};

		var stepper_Zoom:FlxUINumericStepper = new FlxUINumericStepper(check_Pixel.x, check_Pixel.y+30, .05, 1, 0.1, 10, 2);
		stepper_Zoom.value = defaultcamzoom;
		stepper_Zoom.name = 'stage_zoom';

		var check_hideGirlfriend = new FlxUICheckBox(stepper_Zoom.x, stepper_Zoom.y+30, null, null, "Hide Girlfriend", 100);
		check_hideGirlfriend.checked = !gf.visible;
		check_hideGirlfriend.callback = function()
		{
			gf.visible = !check_hideGirlfriend.checked;
		};

        tab_group.add(stepper_Zoom);
        //tab_group.add(objCopyCoords);
		tab_group.add(new FlxText(stepper_Zoom.x, stepper_Zoom.y - 15, 0, 'Default Zoom:'));
        tab_group.add(check_Pixel);
        tab_group.add(check_hideGirlfriend);
        tab_group.add(saveCharacterCoordsBtn);
        tab_group.add(saveAdvancedCoordsBtn);
        //tab_group.add(objCopySize);
        tab_group.add(objCoords);
        tab_group.add(objSize);
        UI_box.addGroup(tab_group);
	}

    var dadSelect:FlxUIDropDownMenuCustom;
    var bfSelect:FlxUIDropDownMenuCustom;
    var gfSelect:FlxUIDropDownMenuCustom;
    var charDropDown:FlxUIDropDownMenuCustom;

    function addCharactersUI() {
        var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Characters";
        
        dadSelect = new FlxUIDropDownMenuCustom(10, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(sprite:String)
            {
                //dad.x = 0;
                //dad.y = 0;

                charLayer.remove(dad);
                dad = new Character(dad.x, dad.y, characterList[Std.parseInt(sprite)], false);
                dadSelect.selectedLabel = "";
                charLayer.add(dad);
                dad.updateHitbox();
                charactersObjects = [bf, gf, dad];

                var json:CharacterFile = characterjson(characterList[Std.parseInt(sprite)]);

                dadjson = json;
                dadidle = getIdleOffset(characterList[Std.parseInt(sprite)]);
            });

        bfSelect = new FlxUIDropDownMenuCustom(dadSelect.x+130, dadSelect.y, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(sprite:String)
            {
                //dad.x = 0;
                //dad.y = 0;

                charLayer.remove(bf);
                bf = new Boyfriend(bf.x, bf.y, characterList[Std.parseInt(sprite)]);
                bfSelect.selectedLabel = "";
                charLayer.add(bf);
                bf.updateHitbox();
                charactersObjects = [bf, gf, dad];

                var json:CharacterFile = characterjson(characterList[Std.parseInt(sprite)]);

                bfjson = json;
                bfidle = getIdleOffset(characterList[Std.parseInt(sprite)]);
            });

        gfSelect = new FlxUIDropDownMenuCustom(dadSelect.x - 130, dadSelect.y, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(sprite:String)
            {
                //dad.x = 0;
                //dad.y = 0;

                charLayer.remove(gf);
                gf = new Character(gf.x, gf.y, characterList[Std.parseInt(sprite)], false);
                gfSelect.selectedLabel = "";
                charLayer.add(gf);
                gf.updateHitbox();
                charactersObjects = [bf, gf, dad];

                var json:CharacterFile = characterjson(characterList[Std.parseInt(sprite)]);

                gfjson = json;
                gfidle = getIdleOffset(characterList[Std.parseInt(sprite)]);
            });

        reloadCharDrops();
        
        charDropDown = new FlxUIDropDownMenuCustom(gfSelect.x-130, dadSelect.y, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(character:String)
		{
            selectedObj = charactersObjects[Std.parseInt(character)];
            reloadCharacterDropDown();
            charDropDown.selectedLabel = charactersOnStage[Std.parseInt(character)];
            selectedObj.updateHitbox();
            updateCoords();
            updateSize();
		});
		reloadCharacterDropDown();
            
        tab_group.add(dadSelect);
        tab_group.add(new FlxText(dadSelect.x, dadSelect.y - 15, 0, 'Opponent:'));
        tab_group.add(bfSelect);
        tab_group.add(new FlxText(bfSelect.x, bfSelect.y - 15, 0, 'Player:'));
        tab_group.add(gfSelect);
        tab_group.add(new FlxText(gfSelect.x, gfSelect.y - 15, 0, 'Girlfriend:'));
        tab_group.add(charDropDown);
		tab_group.add(new FlxText(charDropDown.x, charDropDown.y - 18, 0, 'Character:'));
        UI_box.addGroup(tab_group);
	}

    
    function reloadCharDrops() {
        var charsLoaded:Map<String, Bool> = new Map();

		#if MODS_ALLOWED
		characterList = [];
		var directories:Array<String> = [Paths.mods('characters/'), Paths.mods(Paths.currentModDirectory + '/characters/'), Paths.getPreloadPath('characters/')];
		for(mod in Paths.getGlobalMods())
			directories.push(Paths.mods(mod + '/characters/'));
		for (i in 0...directories.length) {
			var directory:String = directories[i];
			if(FileSystem.exists(directory)) {
				for (file in FileSystem.readDirectory(directory)) {
					var path = haxe.io.Path.join([directory, file]);
					if (!sys.FileSystem.isDirectory(path) && file.endsWith('.json')) {
						var charToCheck:String = file.substr(0, file.length - 5);
						if(!charsLoaded.exists(charToCheck)) {
							characterList.push(charToCheck);
							charsLoaded.set(charToCheck, true);
						}
					}
				}
			}
		}
		#else
		characterList = CoolUtil.coolTextFile(Paths.txt('characterList'));
		#end

		dadSelect.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(characterList, true));
        bfSelect.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(characterList, true));
        gfSelect.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(characterList, true));
		dadSelect.selectedLabel = daAnim;
		bfSelect.selectedLabel = daAnim;
		gfSelect.selectedLabel = daAnim;
    }

    function characterjson(characteruse:String) {
        var characterPath:String = 'characters/' + characteruse + '.json';

        #if MODS_ALLOWED
        var path:String = Paths.modFolders(characterPath);
        if (!FileSystem.exists(path)) {
            path = Paths.getPreloadPath(characterPath);
        }

        if (!FileSystem.exists(path))
        #else
        var path:String = Paths.getPreloadPath(characterPath);
        if (!Assets.exists(path))
        #end
        {
            path = Paths.getPreloadPath('characters/bf.json'); //If a character couldn't be found, change him to BF just to prevent a crash
        }

        #if MODS_ALLOWED
        var rawJson = File.getContent(path);
        #else
        var rawJson = Assets.getText(path);
        #end

        var json:CharacterFile = cast Json.parse(rawJson);
        return json;
    }

    function reloadCharacterDropDown() {
		charDropDown.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(charactersOnStage, true));
	}

    function reloadSpritesDropdown() {
        bgLayer.update(1);
        spritesDropDown.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(spritesLayer, true));
    }

    function updateCoords() {
        if (selectedObj == bf || selectedObj == dad) {
            var xobj = selectedObj.x;
            var yobj = selectedObj.y-230;
            objCoords.text = 'Object Coords: [' + xobj + '; ' + yobj + ']';
        } else {
            objCoords.text = 'Object Coords: [' + selectedObj.x + '; ' + selectedObj.y + ']';
            for (i in bgMap.keys()) {
                if (i == selectedObj) {
                    var objectArray:Array<Dynamic> = [
                        bgMap[i][0],
                        bgMap[i][1],
                        selectedObj.x,
                        selectedObj.y,
                        bgMap[i][4],
                        bgMap[i][5],
                        bgMap[i][6],
                        bgMap[i][7]
                    ];
                    bgMap.set(i, objectArray);
                }
            }
        }
        selectedObj.updateHitbox();
    }      
    
    function updateSize() {
        selectedObj.updateHitbox();
        objSize.text = 'Object Size: [' + selectedObj.scale.x + '; ' + selectedObj.scale.y + ']';
        for (i in bgMap.keys()) {
            if (i == selectedObj) {
                var objectArray:Array<Dynamic> = [
                    bgMap[i][0],
                    bgMap[i][1],
                    bgMap[i][2],
                    bgMap[i][3],
                    selectedObj.scale.x,
                    selectedObj.scale.y,
                    bgMap[i][6],
                    bgMap[i][7]
                ];
                bgMap.set(i, objectArray);
            }
        }
        updateCoords();
    }

	var _file:FileReference;

    function onSaveComplete(_):Void
        {
            _file.removeEventListener(Event.COMPLETE, onSaveComplete);
            _file.removeEventListener(Event.CANCEL, onSaveCancel);
            _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file = null;
            FlxG.log.notice("Successfully saved file.");
        }
    
        /**
            * Called when the save file dialog is cancelled.
            */
        function onSaveCancel(_):Void
        {
            _file.removeEventListener(Event.COMPLETE, onSaveComplete);
            _file.removeEventListener(Event.CANCEL, onSaveCancel);
            _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file = null;
        }
    
        /**
            * Called if there is an error while saving the gameplay recording.
            */
        function onSaveError(_):Void
        {
            _file.removeEventListener(Event.COMPLETE, onSaveComplete);
            _file.removeEventListener(Event.CANCEL, onSaveCancel);
            _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file = null;
            FlxG.log.error("Problem saving file");
        }

    function saveCharacterCoords() {
        var json = {
            "directory": "", // honestly i have no idea what is the point of directory
            "defaultZoom": defaultcamzoom,
            "isPixelStage": stageispixel,
            "boyfriend": [ bf.x - bfjson.position[0] + bfidle[0], bf.y - bfjson.position[1] + bfidle[1] ],
            "girlfriend": [ gf.x - gfjson.position[0] + gfidle[0], gf.y- gfjson.position[1] + gfidle[1] ],
            "opponent": [ dad.x - dadjson.position[0] + dadidle[0], dad.y - dadjson.position[1] + dadidle[1] ],
            "hide_girlfriend": !gf.visible  
        };

		var data:String = Json.stringify(json, "\t");

		if (data.length > 0)
            {
                _file = new FileReference();
                _file.addEventListener(Event.COMPLETE, onSaveComplete);
                _file.addEventListener(Event.CANCEL, onSaveCancel);
                _file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
                _file.save(data, "stage.json");
            }
    }

    function saveAdvancedJson() {
        var json = {};
        var tempid:Int = 0; 
        for (i in bgMap.keys()) {
            if (i == selectedObj) {
                var tempy = bgMap[i];
                json = {
                    "tag": tempy[0],
                    "path": tempy[1],
                    "x": tempy[2],
                    "y": tempy[3],
                    "scalex": tempy[4],
                    "scaley": tempy[5],
                    "animated": tempy[6]
                }
            }
        }

		var data:String = Json.stringify(json, "\t");

		if (data.length > 0)
            {
                _file = new FileReference();
                _file.addEventListener(Event.COMPLETE, onSaveComplete);
                _file.addEventListener(Event.CANCEL, onSaveCancel);
                _file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
                _file.save(data, "object.json");
            }
    }
    
    
    override function update(elapsed:Float) {
        var inputTexts:Array<FlxUIInputText> = [objectInputText, tagInputText];
		for (i in 0...inputTexts.length) {
			if(inputTexts[i].hasFocus) {
				if(FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.V && Clipboard.text != null) { //Copy paste
					inputTexts[i].text = ClipboardAdd(inputTexts[i].text);
					inputTexts[i].caretIndex = inputTexts[i].text.length;
					getEvent(FlxUIInputText.CHANGE_EVENT, inputTexts[i], null, []);
				}
				if(FlxG.keys.justPressed.ENTER) {
					inputTexts[i].hasFocus = false;
				}
				FlxG.sound.muteKeys = [];
				FlxG.sound.volumeDownKeys = [];
				FlxG.sound.volumeUpKeys = [];
				super.update(elapsed);
				return;
			}
		}

        FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;

        if(!charDropDown.dropPanel.visible) {

            if (FlxG.keys.justPressed.ESCAPE) {
                MusicBeatState.switchState(new editors.MasterEditorMenu());
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
				FlxG.mouse.visible = false;
			}

            if (FlxG.keys.justPressed.R) {
                FlxG.camera.zoom = 1;
            }

            if (FlxG.keys.pressed.E && FlxG.camera.zoom < 3) {
                FlxG.camera.zoom += elapsed * FlxG.camera.zoom;
                if(FlxG.camera.zoom > 3) FlxG.camera.zoom = 3;
            }
            if (FlxG.keys.pressed.Q && FlxG.camera.zoom > 0.1) {
                FlxG.camera.zoom -= elapsed * FlxG.camera.zoom;
                if(FlxG.camera.zoom < 0.1) FlxG.camera.zoom = 0.1;
            }

            if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
            {
                var addToCam:Float = 500 * elapsed;
                if (FlxG.keys.pressed.SHIFT)
                    addToCam *= 4;

                if (FlxG.keys.pressed.I)
                    camFollow.y -= addToCam;
                else if (FlxG.keys.pressed.K)
                    camFollow.y += addToCam;

                if (FlxG.keys.pressed.J)
                    camFollow.x -= addToCam;
                else if (FlxG.keys.pressed.L)
                    camFollow.x += addToCam;
            }
            if (FlxG.keys.justPressed.LEFT) {
                var addToObj:Float = 1;
                if (FlxG.keys.pressed.SHIFT) {
                    addToObj *= 10;
                } else if (FlxG.keys.pressed.CONTROL) {
                    addToObj *= 100;
                }
                selectedObj.x = selectedObj.x - addToObj;
                updateCoords();
            } else if (FlxG.keys.justPressed.UP) {
                var addToObj:Float = 1;
                if (FlxG.keys.pressed.SHIFT) {
                    addToObj *= 10;
                } else if (FlxG.keys.pressed.CONTROL) {
                    addToObj *= 100;
                }
                selectedObj.y = selectedObj.y - addToObj;
                updateCoords();
            } else if (FlxG.keys.justPressed.RIGHT) {
                var addToObj:Float = 1;
                if (FlxG.keys.pressed.SHIFT) {
                    addToObj *= 10;
                } else if (FlxG.keys.pressed.CONTROL) {
                    addToObj *= 100;
                }
                selectedObj.x = selectedObj.x + addToObj;
                updateCoords();
            } else if (FlxG.keys.justPressed.DOWN) {
                var addToObj:Float = 1;
                if (FlxG.keys.pressed.SHIFT) {
                    addToObj *= 10;
                } else if (FlxG.keys.pressed.CONTROL) {
                    addToObj *= 100;
                }
                selectedObj.y = selectedObj.y + addToObj;
                updateCoords();
            }

            if (FlxG.keys.justPressed.O && selectedObj != bf && selectedObj != gf && selectedObj != dad) {
                if (!FlxG.keys.pressed.SHIFT) {
                    selectedObj.scale.x += 0.1;
                    selectedObj.scale.y += 0.1;
                    updateSize();
                } else {
                    selectedObj.scale.x += 1;
                    selectedObj.scale.y += 1;
                    updateSize();
                }
            } else if (FlxG.keys.justPressed.P && selectedObj != bf && selectedObj != gf && selectedObj != dad) {
                if (!FlxG.keys.pressed.SHIFT) {
                    selectedObj.scale.x -= 0.1;
                    selectedObj.scale.y -= 0.1;
                    updateSize();
                } else {
                    selectedObj.scale.x -= 1;
                    selectedObj.scale.y -= 1;
                    updateSize();
                }
            }
        }
        super.update(elapsed);
    }

    function getIdleOffset(character:String) {
        var tempjson = characterjson(character);

        for (i in tempjson.animations) {
            if (i.anim == "idle") {
                top10awesome = i.offsets;
            }
        }
        return top10awesome;
    }

    function ClipboardAdd(prefix:String = ''):String {
		if(prefix.toLowerCase().endsWith('v')) //probably copy paste attempt
		{
			prefix = prefix.substring(0, prefix.length-1);
		}

		var text:String = prefix + Clipboard.text.replace('\n', '');
		return text;
	}
    
    override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
        if(id == FlxUIInputText.CHANGE_EVENT && (sender is FlxUIInputText)) {
			if(sender == objectInputText) {
				objectName = objectInputText.text;
			}
            if (sender == tagInputText) {
                tagName = tagInputText.text;
            }
		} else if(id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper)) {
			var nums:FlxUINumericStepper = cast sender;
			var wname = nums.name;
			FlxG.log.add(wname);
            if (wname == 'stage_zoom') {
                defaultcamzoom = nums.value;
            }            
		}
    }
}