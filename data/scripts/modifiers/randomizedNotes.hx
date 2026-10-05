if (!FlxG.save.data.modifiers_randomizedNotes)
{
    disableScript();
}

var lastChordTime:Float = -1;
var lastChordStrum:Dynamic = null;
var usedCols:Array<Int> = [];

function onNoteCreation(e)
{
    var note = e.note;

    if (note.isSustainNote)
    {
        note.noteData = note.sustainParent.noteData;
        e.strumID = note.noteData;
        return;
    }

    if (note.strumTime != lastChordTime || note.strumLine != lastChordStrum)
    {
        lastChordTime = note.strumTime;
        lastChordStrum = note.strumLine;
        usedCols = [];
    }

    var keyCount = note.strumLine.members.length;
    var choices = [for (i in 0...keyCount) if (usedCols.indexOf(i) == -1) i];
    var col = choices.length > 0 ? choices[FlxG.random.int(0, choices.length - 1)] : FlxG.random.int(0, keyCount - 1);

    note.noteData = col;
    e.strumID = col;
    usedCols.push(col);
}

function onScoreMultiply(e)
{
    e.data.bonus = 0.1;
}