if (!FlxG.save.data.modifiers_practice)
{
    disableScript();
}

import funkin.backend.utils.TranslationUtil as TU;

function postCreate()
{
    validScore = false;
    canDie = canDadDie = false;

    if (!FlxG.save.data.modifiers_botplay)
    {
        practiceTxt = new FunkinText(missesTxt.x, missesTxt.y - 70, Std.int(healthBarBG.width - 100), TU.translate("modifiers.game.practice"), missesTxt.size);
        practiceTxt.cameras = missesTxt.cameras;
        practiceTxt.alignment = missesTxt.alignment;
        add(practiceTxt);
    }
}