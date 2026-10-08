if (FlxG.save.data.modifiers_dadHealthDrain == 0)
{
    disableScript();
}

function onDadHit(e)
{
    if (health <= 0.1) return;
    e.healthGain += 0.016 * FlxG.save.data.modifiers_dadHealthDrain;
}
function onScoreMultiply(e)
{
    e.data.bonus = 0.25 * FlxG.save.data.modifiers_dadHealthDrain;
}