function postCreate() {
	for (sl in strumLines.members)
        for (note in sl.notes.members)
            note.alpha = 1;

	camZoomingStrength = 0;

	for (i in [iconP1, iconP2, healthBarBG, healthBar, scoreTxt, missesTxt, accuracyTxt])
		remove(i);
}

function postUpdate(elapsed:Float) {
	for (sl in strumLines.members) {
		for (note in sl.notes.members)
			if (note.isSustainNote)
				note.y -= 24;

		if (!sl.cpu)
			for (strum in sl.members)
				strum.alpha = strum.getAnim() == 'pressed' ? 0.5 : 1;
	}
}

function onNoteHit(event) {
	event.preventStrumGlow();
	event.showSplash = false;
}

function onNoteCreation(event) {
	event.cancel();
	
	var note = event.note;
	note.frames = Paths.getFrames('game/notes/free');
	if (!note.isSustainNote)
		note.animation.addByPrefix('scroll', ['purple', 'blue', 'green', 'red'][event.note.noteData], 0, true);
	else {
		note.animation.addByPrefix('hold', ['purple_hold', 'blue_hold', 'green_hold', 'red_hold'][event.note.noteData], 0, true);
		note.animation.addByPrefix('holdend', ['purple_cap', 'blue_cap', 'green_cap', 'red_cap'][event.note.noteData], 0, true);
	}

	note.updateHitbox();
}

function onStrumCreation(event) {
    event.cancelAnimation();
	event.strum.setPosition(FlxG.width*(switch(event.player) {
		default: 0.53;
		case 0: 0.025;
	}) + (44 * event.strumID), 24);
	event.strum.scrollSpeed = 1.15;
	
	event.cancel();
	
	var strum = event.strum;
	strum.frames = Paths.getFrames('game/notes/free');
	strum.animation.addByPrefix('static', event.animPrefix, 0, true);
	strum.animation.addByPrefix('pressed', event.animPrefix, 0, true); // so it'll stop tracing stupid shit

	strum.updateHitbox();
}