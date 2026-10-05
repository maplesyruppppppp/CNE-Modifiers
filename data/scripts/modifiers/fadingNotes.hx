var mode:String = "off";

var AWAY_NEAR:Float = 0.12;
var AWAY_FAR:Float = 0.35;

var IN_NEAR:Float = 0.35;
var IN_FAR:Float = 0.65;

var SUSTAIN_ALPHA:Float = 0.6;

var SKIP_CPU_LANES:Bool = false;

var THROTTLE:Bool = true;

var isAway:Bool = false;
var awayNear:Float = 0;
var awayInv:Float = 0;
var inFar:Float = 0;
var inInv:Float = 0;

var strumY:Array<Float> = [];
var tick:Int = 0;

function postCreate()
{
    mode = FlxG.save.data.modifiers_fadingNotes;
    isAway = mode == "away";

    var h = FlxG.height;
    awayNear = AWAY_NEAR * h;
    awayInv = 1 / ((AWAY_FAR - AWAY_NEAR) * h);
    inFar = IN_FAR * h;
    inInv = 1 / ((IN_FAR - IN_NEAR) * h);
}

function postUpdate(elapsed:Float)
{
    if (mode == "off") return;

    tick++;

    var lanes = strumLines.members;
    for (k in 0...lanes.length)
    {
        if (THROTTLE && ((tick + k) & 1) == 1) continue;

        var sl = lanes[k];
        if (SKIP_CPU_LANES && sl.cpu) continue;

        for (i in 0...sl.members.length)
            strumY[i] = sl.members[i].y;

        var notes = sl.notes.members;
        var len = notes.length;
        var j = 0;
        while (j < len)
        {
            var n = notes[j];
            j++;

            if (n == null || !n.alive) continue;

            var d = n.y - strumY[n.strumID];
            if (d < 0) d = -d;

            var t = isAway ? (d - awayNear) * awayInv : (inFar - d) * inInv;
            if (t < 0) t = 0;
            else if (t > 1) t = 1;

            n.alpha = n.isSustainNote ? t * SUSTAIN_ALPHA : t;
        }
    }
}

function onScoreMultiply(e)
{
    e.data.bonus = (FlxG.save.data.modifiers_fadingNotes == 'off') ? 0 : 0.25;
}
