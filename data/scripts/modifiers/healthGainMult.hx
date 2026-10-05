if (FlxG.save.data.modifiers_healthGainMult == 1)
{
    disableScript();
}

function onPlayerHit(e)
{
    e.healthGain *= FlxG.save.data.modifiers_healthGainMult;
}

function onScoreMultiply(e)
{
    e.data.bonus = (FlxG.save.data.modifiers_healthGainMult - 1) * -0.25;
}