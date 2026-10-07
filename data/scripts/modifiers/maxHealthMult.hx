if (FlxG.save.data.modifiers_maxHealthMult == 1)
{
    disableScript();
}

function postCreate()
{
    maxHealth *= FlxG.save.data.modifiers_maxHealthMult;
    health *= FlxG.save.data.modifiers_maxHealthMult;
}
function onScoreMultiply(e)
{
    e.data.bonus = (FlxG.save.data.modifiers_maxHealth - 1) * -0.2;
}