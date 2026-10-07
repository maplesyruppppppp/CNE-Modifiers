if (FlxG.save.data.modifiers_perfectionist == 'off')
{
    disableScript();
}

import funkin.backend.utils.TranslationUtil as TU;

function postCreate()
{
    missesTxt.visible = FlxG.save.data.modifiers_perfectionist != 'sicksOnly';
}

function postUpdate()
{
    switch(FlxG.save.data.modifiers_perfectionist)
    {
        case 'noMisses':
            missesTxt.text = TU.translate('modifiers.game.noMisses');
        case 'sicksOnly':
            accFormat.format.color = FlxColor.WHITE;
            accuracyTxt.text = TU.translate('modifiers.game.sicksOnly');
    }
}

function onPlayerMiss(e)
{
    e.cancel();
    gameOver();
}
function onPlayerHit(e)
{
    if (FlxG.save.data.modifiers_perfectionist == 'sicksOnly')
    {
        if (e.rating == 'sick')
        {
            return;
        }

        e.cancel();
        gameOver();
    }
}

function onScoreMultiply(e)
{
    e.data.bonus = (FlxG.save.data.modifiers_perfectionist == 'noMisses') ? 0.15 : 0.4;
}