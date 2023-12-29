import flixel.effects.particles.FlxTypedEmitter;
import flixel.effects.particles.FlxParticle;

var contrast:CustomShader = new CustomShader('brightness-contrast');
var chromatic:CustomShader = new CustomShader('chromatic-aberration');
var staticShader:CustomShader = new CustomShader('static');

var chromBeat:Bool = false;
var thunder:Bool = false;

var rainEmitter:FlxTypedEmitter;

var vignette:FunkinSprite;

function postCreate() {
	contrast.brightness = 0.;
	contrast.contrast = 1.;
	camGame.addShader(contrast);

	chromatic.strength = 0.;
	chromatic.effectTime = 0.1;
	camGame.addShader(chromatic);

	staticShader.strength = 0.05;
	staticShader.speed = 1;
	if (FlxG.save.data.freeFLASH)
		camGame.addShader(staticShader);

	rainEmitter = new FlxTypedEmitter(0, 0);
	for (i in 0...5000) {
		var particle = new FlxParticle().makeGraphic(2, 25, 0xC9D2DCEB);
		var scroll = FlxG.random.float(2, 1);
		particle.scrollFactor.set(scroll, scroll);
		particle.alpha = FlxG.random.float(0.25, 0.75);
		particle.angle = 25;
		particle.exists = false;
		rainEmitter.add(particle);
	}

	rainEmitter.launchMode = 'square';
	rainEmitter.velocity.set(-100, 1600, -50, 1600, -180, 800, -90, 1600);
	rainEmitter.width = FlxG.width*2;
	rainEmitter.lifespan.set(0.25, 0.75);
	rainEmitter.alpha.set(0.75, 0);
	rainEmitter.start(false, 0.01, 1000000);
	rainEmitter.blend = 0;
	add(rainEmitter);

	vignette = new FunkinSprite().loadGraphic(Paths.image('effects/vignette'));
	vignette.zoomFactor = 0;
	vignette.scrollFactor.set();
	vignette.alpha = 0.5;
	add(vignette);
}

var shaderTime:Float = 0;
function update(elapsed:Float) {
	shaderTime += elapsed;
	staticShader.time = shaderTime;
}

function flash(time:Float, color:FlxColor)
	if (FlxG.save.data.freeFLASH)
		camHUD.flash(color, time, null, true);

function shakeItUp(cam:FlxCamera, power:Float, time:Float)
	if (FlxG.save.data.freeSHAKE)
		cam.shake(power, time, null, true);

function onCameraMove() {
	if (curStep == 192)
		camGame.snapToTarget();
}

function beatHit() {
	if (chromBeat && (curBeat % camera.bumpInterval == 0)) {
		FlxTween.num(0.03*camera.bumpStrength, 0., (((Conductor.stepCrochet/1000)*4)*Std.int(camera.bumpInterval/2))-0.01, {ease: FlxEase.cubeOut}, (value) -> {chromatic.strength = value;});
	}

	if (thunder && (curBeat % 16 == 0)) {
		FlxTween.num(-0.5, -0.2, 1.25, {ease: FlxEase.cubeIn}, (value) -> {contrast.brightness = value;});
		FlxTween.num(1.5, 1.1, 1.25, {ease: FlxEase.cubeIn}, (value) -> {contrast.contrast = value;});
	}
}

function stepHit()
	switch(curStep) {
		case 48:
			camera.bumpInterval = 1;
			camera.bumpStrength = 1;
		case 64:
			camera.bumpStrength = 1.25;
		case 176:
			camera.data[0].zoom = camera.data[1].zoom = 1.3;
		case 192:
			flash(0.25, 0xFFFFFFFF);
			camGame.zoom += 0.1;
			camera.bumpInterval = 4;
			camera.bumpStrength = 4.5;
			camera.data[0].zoom = 1.1;
			camera.data[1].zoom = 1.2;

			contrast.brightness = -0.2;
			contrast.contrast = 1.1;
			staticShader.strength = 0.15;

			chromBeat = thunder = true;

			shakeItUp(camGame, 0.0075, 0.15);
			shakeItUp(camHUD, 0.005, 0.15);

			for (sl in strumLines.members) {
				for (strum in sl.members) {
					strum.setPosition(FlxG.width*0.3 + (44 * sl.members.indexOf(strum)), 24);
					if (sl.cpu)
						strum.alpha = 0.001;
				}

				if (sl.cpu)
					for (note in sl.notes)
						note.alpha = 0.001;
			}
		case 208, 228, 232, 236, 244:
			shakeItUp(camGame, 0.005, 0.15);
			shakeItUp(camHUD, 0.005, 0.15);
		case 224:
			camera.bumpInterval = 1;
			shakeItUp(camGame, 0.005, 0.15);
			shakeItUp(camHUD, 0.005, 0.15);
		case 240:
			camera.data[0].zoom = 1.3;
			shakeItUp(camGame, 0.005, 0.15);
			shakeItUp(camHUD, 0.005, 0.15);
		case 248:
			camera.bumpInterval = 2;
			shakeItUp(camGame, 0.005, 0.15);
			shakeItUp(camHUD, 0.005, 0.15);
		case 256:
			camera.bumpInterval = 1;
			camera.bumpStrength = 3.75;
			shakeItUp(camGame, 0.005, 0.15);
			shakeItUp(camHUD, 0.005, 0.15);
	}