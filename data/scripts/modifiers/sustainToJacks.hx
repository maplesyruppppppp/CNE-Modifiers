if (!FlxG.save.data.modifiers_sustainToJacks)
{
    disableScript();
}

function create()
{
    var interval:Float = Conductor.stepCrochet;

    for (strumLine in strumLines)
    {
        var added = [];

        for (n in strumLine.notes)
        {
            if (n.sLen <= 0) continue;

            var t = interval;
            while (t < n.sLen)
            {
                added.push({time: n.time + t, id: n.id, type: n.type, sLen: 0});
                t += interval;
            }

            n.sLen = 0;
        }

        for (a in added) strumLine.notes.push(a);
        strumLine.notes.sort((a, b) -> Std.int(a.time - b.time));
    }
}