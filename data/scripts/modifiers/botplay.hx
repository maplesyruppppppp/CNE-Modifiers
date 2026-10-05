if (!FlxG.save.data.modifiers_botplay)
{
    disableScript();
}

function postCreate()
{
    for (i in 0...strumLines.length)
    {
        strumLines.members[i].cpu = true;
    }
}