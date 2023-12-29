import Xml;

public var camera = {
	data: [-1 => {}],
	zoomMultiplier: 1,
	bumpInterval: 4,
	bumpStrength: 0
};

function postCreate() {
	for (sl in strumLines.members)
		createCamData(strumLines.members.indexOf(sl), getCamValues(sl));

	camZooming = true;
	camGame.followLerp = 0.0275;
	camGame.pixelPerfectRender = true;
}

public function createCamData(index:Int, data:{x:Float, y:Float, zoom:Float, noteOffset:Float})
	camera.data[index] = {
		x: data.x,
		y: data.y,
		zoom: data.zoom,
		set: function(x:Float, y:Float, zoom:Float) {
			camera.data[index].x = x;
			camera.data[index].y = y;
			camera.data[index].zoom = zoom;
		},

		noteOffset: data.noteOffset
	};

function getCamValues(sl:StrumLine):{x:Float, y:Float, zoom:Float} {
	var values = switch(sl.data.position) {
		default: {
			x: 0,
			y: 0,
			zoom: 1,
			noteOffset: 25
		};
		case 'dad': {
			x: 420.95,
			y: 513,
			zoom: 0.8,
			noteOffset: 25
		};
		case 'girlfriend': {
			x: 952.9,
			y: 200,
			zoom: 0.65,
			noteOffset: 25
		};
		case 'boyfriend': {
			x: 952.9,
			y: 550,
			zoom: 1,
			noteOffset: 25
		};
	};

	function doCheck(node:Xml, data:{x:Float, y:Float, zoom:Float, noteOffset:Float}) {
		if (node.exists('camx')) data.x = Std.parseFloat(node.get('camx'));
		if (node.exists('camy')) data.y = Std.parseFloat(node.get('camy'));
		if (node.exists('zoom')) data.zoom = Std.parseFloat(node.get('zoom'));
		if (node.exists('noteoffset')) data.noteOffset = Std.parseFloat(node.get('noteoffset'));

		return data;
	}

	for (node in Xml.parse(Assets.getText(stage.stagePath)).firstElement().elements()) {
		switch(node.nodeName) {
			case 'character':
				if (node.exists('name') && [for (i in sl.characters) i].contains(node.get('name')))
					values = doCheck(node, values);
				else continue;
			case 'dad' | 'opponent':
				if (sl.data.position != 'dad') continue;
				values = doCheck(node, values);
			case 'boyfriend' | 'bf' | 'player':
				if (sl.data.position != 'boyfriend') continue;
				values = doCheck(node, values);
			case 'girlfriend' | 'gf':
				if (sl.data.position != 'girlfriend') continue;
				values = doCheck(node, values);
		};
	}

	return values;
}

function onCameraMove(event) {
	var curTarget = camera.data[curCameraTarget];
	event.position.set(curTarget.x, curTarget.y);
	defaultCamZoom = curTarget.zoom;

	if (curTarget.noteOffset != 0 && StringTools.startsWith(strumLines.members[curCameraTarget].characters[0].getAnimName(), 'sing')) {
		var direction:String = StringTools.replace(strumLines.members[curCameraTarget].characters[0].getAnimName(), 'sing', '').toLowerCase();

		if (StringTools.contains(direction, 'left'))
			event.position.x -= curTarget.noteOffset;
		if (StringTools.contains(direction, 'down'))
			event.position.y += curTarget.noteOffset;
		if (StringTools.contains(direction, 'up'))
			event.position.y -= curTarget.noteOffset;
		if (StringTools.contains(direction, 'right'))
			event.position.x += curTarget.noteOffset;
	}
}

function beatHit()
	if (Options.camZoomOnBeat && camZooming && camGame.zoom < maxCamZoom && curBeat % camera.bumpInterval == 0)
		camGame.zoom += (0.03 * camera.zoomMultiplier) * camera.bumpStrength;