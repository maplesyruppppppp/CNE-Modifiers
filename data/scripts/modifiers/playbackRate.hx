function postCreate()
{
    inst.pitch = vocals.pitch = FlxG.save.data.modifiers_playbackRate;
    for (i in 0...strumLines.length)
    {
        var strumLine = strumLines.members[i];
        if (strumLine.vocals != null)
        {
            strumLine.vocals.pitch = FlxG.save.data.modifiers_playbackRate;
        }
    }
}

function onScoreMultiply(e)
{
    e.data.bonus += FlxG.save.data.modifiers_playbackRate - 1;
}

function destroy()
{
    inst.pitch = 1;
}