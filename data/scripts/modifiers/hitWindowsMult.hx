if (FlxG.save.data.modifiers_hitWindowsMult == 1)
{
    disableScript();
}

import funkin.game.scoring.HitWindowData;
import haxe.ds.StringMap;

function postCreate()
{
    var scaled = HitWindowData.scaleWindows(ratingManager.hitWindows, FlxG.save.data.modifiers_hitWindowsMult);
    ratingManager.hitWindows = scaled;
}

function onScoreMultiply(e)
{
    e.data.bonus = (FlxG.save.data.modifiers_hitWindowsMult - 1) * -0.35;
}