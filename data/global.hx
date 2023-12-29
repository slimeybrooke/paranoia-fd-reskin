import funkin.backend.MusicBeatState;
import funkin.editors.ui.UIState;
import lime.graphics.Image;

// separate them just in case
FlxG.width = FlxG.initialWidth = 400;
FlxG.height = FlxG.initialHeight = 400;
window.resize(FlxG.width*2, FlxG.height*2);

function new() {
	if (FlxG.save.data.freeFLASH == null) FlxG.save.data.freeFLASH = true;
	if (FlxG.save.data.freeSHAKE == null) FlxG.save.data.freeSHAKE = true;
}

function preStateSwitch() {
	var res = [
		!(FlxG.game._requestedState is PlayState) ? 1280 : 400,
		!(FlxG.game._requestedState is PlayState) ? 720 : 400
	];
	var windowRes = [
		!(FlxG.game._requestedState is PlayState) ? 1280 : 800,
		!(FlxG.game._requestedState is PlayState) ? 720 : 800
	];
	
	if (FlxG.width == res[0] || FlxG.height == res[1]) return;

	FlxG.width = FlxG.initialWidth = res[0];
	FlxG.height = FlxG.initialHeight = res[1];
	window.resize(windowRes[0], windowRes[1]);

	for (camera in FlxG.cameras.list) camera.setSize(FlxG.width, FlxG.height);
}

function onDestroy() {
	FlxG.width = FlxG.initialWidth = 1280;
	FlxG.height = FlxG.initialHeight = 720;
	window.resize(FlxG.width, FlxG.height);
}