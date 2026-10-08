if (FlxG.save.modifiers_poison == 0)
{
    disableScript();
}

function postUpdate(elapsed:Float)
{
    if (startingSong) return;
    var poison:Float = FlxG.save.data.modifiers_poison;
    if (poison == null) poison = 0;

    if (poison > 0 && health > 0.1)
        health -= (0.1 * elapsed) * poison;
}

function onScoreMultiply(e)
{
    e.data.bonus = FlxG.save.data.modifiers_poison * 0.15;
}