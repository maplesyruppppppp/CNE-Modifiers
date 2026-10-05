if (FlxG.save.data.modifiers_scrollSpeedMult == 1)
{
    disableScript();
}

function postCreate()
{
    scrollSpeed *= FlxG.save.data.modifiers_scrollSpeedMult;
}
function onEvent(e)
{
    if (e.event.name == 'Scroll Speed Change')
    {
        e.event.params[1] *= FlxG.save.data.modifiers_scrollSpeedMult;
    }
}

function onScoreMultiply(e)
{
    e.data.bonus = (FlxG.save.data.modifiers_scrollSpeedMult - 1) * 0.5;
}