if (FlxG.save.data.modifiers_cameraFlip == 'off')
{
    disableScript();
}

function postCreate()
{
    switch (FlxG.save.data.modifiers_cameraFlip)
    {
        case 'vertical':
            camGame.flashSprite.scaleY = -1;
	        camHUD.flashSprite.scaleY = -1;
        case 'horizontal':
            camGame.flashSprite.scaleX = -1;
	        camHUD.flashSprite.scaleX = -1;
        case 'both':
            camGame.flashSprite.scaleX = -1;
	        camHUD.flashSprite.scaleX = -1;
            camGame.flashSprite.scaleY = -1;
	        camHUD.flashSprite.scaleY = -1;
    }
}

function onScoreMultiply(e)
{
    e.data.bonus = (FlxG.save.data.modifiers_cameraFlip == 'both') ? 0.5 : 0.25;
}