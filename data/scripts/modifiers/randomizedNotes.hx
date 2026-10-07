if (!FlxG.save.data.modifiers_randomizedNotes)
{
    disableScript();
}

var lastChordTime:Float = -1;
var lastChordStrum:Dynamic = null;
var usedCols:Array<Int> = [];

var occupied = new haxe.ds.ObjectMap();

function getOccupiedCols(strumLine:Dynamic):Array<Dynamic>
{
    if (!occupied.exists(strumLine))
    {
        var cols = [];
        for (i in 0...strumLine.members.length)
        {
            cols.push([]); 
        }
        occupied.set(strumLine, cols);
    }
    return occupied.get(strumLine);
}

function isFree(intervals:Array<Dynamic>, start:Float, end:Float, buf:Float):Bool
{
    for (iv in intervals)
    {
        if (start - buf < iv.end && end + buf > iv.start)
        {
            return false;
        }
    }
    return true;
}

function onNoteCreation(e)
{
    var note = e.note;
    var cols = getOccupiedCols(note.strumLine);

    if (note.isSustainNote)
    {
        var col:Int = note.sustainParent.noteData;
        note.noteData = col;
        e.strumID = col;

        var list = cols[col];
        if (list.length > 0)
        {
            var lastInterval = list[list.length - 1];
            var pieceEnd:Float = note.strumTime + (note.sustainLength > 0 ? note.sustainLength : 0);

            if (pieceEnd > lastInterval.end)
            {
                lastInterval.end = pieceEnd;
            }
        }
        return;
    }

    if (note.strumTime != lastChordTime || note.strumLine != lastChordStrum)
    {
        lastChordTime = note.strumTime;
        lastChordStrum = note.strumLine;
        usedCols = [];
    }

    var keyCount:Int = note.strumLine.members.length;
    var start:Float = note.strumTime;
    var end:Float = start + (note.sustainLength > 0 ? note.sustainLength : 0);
    var buf:Float = Conductor.stepCrochet;

    var validCols:Array<Int> = [];
    var passes = [
        {buf: buf, checkUsed: true},
        {buf: 0.0, checkUsed: true},
        {buf: 0.0, checkUsed: false}
    ];

    // gotta be certain they won't overlap in any sustains!
    for (p in passes)
    {
        for (i in 0...keyCount)
        {
            if ((!p.checkUsed || usedCols.indexOf(i) == -1) && isFree(cols[i], start, end, p.buf))
            {
                validCols.push(i);
            }
        }
        if (validCols.length > 0) break;
    }
    if (validCols.length == 0)
    {
        for (i in 0...keyCount)
        {
            validCols.push(i);
        }
    }

    var finalCol = validCols[FlxG.random.int(0, validCols.length - 1)];

    note.noteData = finalCol;
    e.strumID = finalCol;
    usedCols.push(finalCol);

    cols[finalCol].push({start: start, end: end});
}

function onScoreMultiply(e)
{
    e.data.bonus = 0.1;
}