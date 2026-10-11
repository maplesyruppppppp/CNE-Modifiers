if (!FlxG.save.data.modifiers_botplay)
{
    disableScript();
}

import funkin.backend.utils.TranslationUtil as TU;

function postCreate()
{
    for (i in 0...strumLines.length)
    {
        strumLines.members[i].cpu = true;
    }
}

function postUpdate()
{
    accuracyTxt.visible = scoreTxt.visible = false;
    missesTxt.text = TU.translate('modifiers.game.botplay');
}