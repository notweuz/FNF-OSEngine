![](https://media.discordapp.net/attachments/969211146412363828/980124443164672000/23336ff517a80f27.png?width=1101&height=701)
# Friday Night Funkin' - OS Engine - Modded Psych Engine 
![](https://img.shields.io/github/issues/notweuz/FNF-OSEngine) ![](https://img.shields.io/github/forks/notweuz/FNF-OSEngine) ![](https://img.shields.io/github/stars/notweuz/FNF-OSEngine) ![](https://img.shields.io/github/license/notweuz/FNF-OSEngine) ![GitHub all releases](https://img.shields.io/github/downloads/notweuz/FNF-OSEngine/total) ![GitHub repo size](https://img.shields.io/github/repo-size/notweuz/FNF-OSEngine) ![](https://img.shields.io/github/contributors/notweuz/FNF-OSEngine) ![GitHub release (latest by date)](https://img.shields.io/github/downloads/notweuz/FNF-OSEngine/latest/total)

## Installation:
You must have [the most up-to-date version of Haxe](https://haxe.org/download/), seriously, stop using 4.1.5, it misses some stuff.

Follow a Friday Night Funkin' source code compilation tutorial, after this you will need to install LuaJIT.

To install LuaJIT do this: `haxelib git linc_luajit https://github.com/nebulazorua/linc_luajit` on a Command prompt/PowerShell

...Or if you don't want your mod to be able to run .lua scripts, delete the "LUA_ALLOWED" line on Project.xml

If you get an error about StatePointer when using Lua, run `haxelib remove linc_luajit` into Command Prompt/PowerShell, then re-install linc_luajit.

If you want video support on your mod, simply do `haxelib install hxCodec` on a Command prompt/PowerShell

## OS Engine Credits:
* [weuz_](https://github.com/notweuz) - Coding
* [nelifs](https://github.com/nelifs) - Coding and Design
* [Cooljer](https://github.com/cooljer) - Arts

### OS Engine Special Thanks
* [jonnycat](https://github.com/McJonnycat) - Fixing bugs in Engine <3.
* [Kade Engine](https://gamebanana.com/mods/44291) - Circle Note Skin

## Psych Engine Credits:
* Shadow Mario - Programmer
* RiverOaken - Artist
* Yoshubs - Assistant Programmer

### Psych Engine Special Thanks
* bbpanzu - Ex-Programmer
* shubs - New Input System
* SqirraRNG - Crash Handler and Base code for Chart Editor's Waveform
* KadeDev - Fixed some cool stuff on Chart Editor and other PRs
* iFlicky - Composer of Psync and Tea Time, also made the Dialogue Sounds
* PolybiusProxy - .MP4 Video Loader Library (hxCodec)
* Keoiki - Note Splash Animations
* Smokey - Sprite Atlas Support
* Nebula the Zorua - LUA JIT Fork and some Lua reworks & VCR Shader code
_____________________________________

# Features

## Psych Engine Features

OS Engine is a fork of Psych Engine, so you can use almost every feature from Psych Engine in OS Engine!

## OS Engine Features

### Psych Engine mods compability
Yes, almost every mod for Psych Engine runs on OS Engine.

### Note Skins
OS Engine adds a note skins system! There's only Default and Circle skins by default.

![](https://media.discordapp.net/attachments/969211146412363828/969211181728399420/unknown.png)

### Showcase Mode
This feature hides HUD and enables botplay. So you can showcase any mod without any problems.

![](https://media.discordapp.net/attachments/969211146412363828/969211657307951104/unknown.png)

### Hide Score Text
This feature hides score text under health bar. Idk why you need to use it.

![](https://media.discordapp.net/attachments/969211146412363828/969211797993299979/unknown.png)

### Perfect!! Judgement
Adds Perfect!! Judgement. It's better than sick. Btw you can disable it in settings if you want.

![](https://media.discordapp.net/attachments/969211146412363828/969213039230455838/unknown.png)
![](https://media.discordapp.net/attachments/969211146412363828/969212313410351134/unknown.png?width=1440&height=190)

### Lane Underlay
You can set lane underlay transparency under arrows by using that functions.

![](https://media.discordapp.net/attachments/969211146412363828/969212761605296198/unknown.png?width=465&height=676)
![](https://media.discordapp.net/attachments/969211146412363828/969212421887635546/unknown.png?width=1440&height=326)

### Custom Settings in Chart Editor.
There's multiple new functions in chart editor. Like player/opponent trail, camera move and etc.

![](https://media.discordapp.net/attachments/969211146412363828/969213936924774430/unknown.png)

### Literally Useless Exit Game State
Now you can press ESC at title state. And game will ask you do you want to close game or no

![](https://media.discordapp.net/attachments/969211146412363828/969214715702177812/unknown.png?width=1202&height=676)

### Bit Changed Main Menu State

![](https://media.discordapp.net/attachments/969211146412363828/969214974369099807/unknown.png)

### Winning icons 
Instead of 2 icons, there'll be three icons (losing, normal, winning). And yes, you can use double icons (without winning).

![](https://github.com/weuz-github/FNF-OSEngine/blob/main/assets/preload/images/icons/icon-bf.png?raw=true)

*thanks Cooljer for remaking original fnf icons*

### Shaders
Returned shaders from old psych engine versions. Now you can make your bambi mods.

### Custom Title State
Bit changed Title State. Now it looks way more better.

![](https://media.discordapp.net/attachments/969211146412363828/969215626126196797/unknown.png?width=1202&height=676)

### Striped Health Bar
Cassette Girl vibes?

![](https://media.discordapp.net/attachments/969211146412363828/969218236950397038/unknown.png)
