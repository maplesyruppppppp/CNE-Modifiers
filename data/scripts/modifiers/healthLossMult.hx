if (FlxG.save.data.modifiers_healthLossMult == 1)
{
    disableScript();
}

function onPlayerMiss(e)
{
    e.healthGain *= FlxG.save.data.modifiers_healthLossMult;
}

function onScoreMultiply(e)
{
    e.data.bonus = (FlxG.save.data.modifiers_healthLossMult - 1) * 0.25;
}