//
if (PlayState.isStoryMode)
{
    disableScript();
}

import funkin.backend.scripting.events.CancellableEvent;
import ModifiersUtil;

function collectScripts(folder:String):Array<String>
{
    var found:Array<String> = [];

    for (file in Paths.getFolderContent(folder))
    {
        if (StringTools.endsWith(file, '.hx'))
            found.push(folder + file.substr(0, file.length - 3));
    }

    for (dir in Paths.getFolderDirectories(folder))
        found = found.concat(collectScripts(folder + dir + '/'));

    return found;
}

function create()
{
    for (path in collectScripts('data/scripts/modifiers/'))
    {
        importScript(path);
    }

    validScore = false;
    PauseSubState.script = 'data/scripts/pauseSubstate';
}

function onPlayerHit(e)
{
    if (!ModifiersUtil.isScoreEligible())
    {
        return;
    }

    e.score *= ModifiersUtil.getMultiplier();
}

function getMultiplier():Float
{
    var bonus:Float = 0;

    var event:CancellableEvent = new CancellableEvent();
    event.data = {
        bonus: 0
    };
    scripts.event('onScoreMultiply', event);

    bonus += event.data.bonus;

    return Math.max(1 + bonus, 0);
}

function saveModifierScore()
{
    if (!ModifiersUtil.isScoreEligible()) return;

    var scores = ModifiersUtil.get("songScores");
    var key = PlayState.SONG.meta.name + ":" + PlayState.difficulty;
    var newScore = Math.round(Math.max(songScore, 0));

    var old = Reflect.field(scores, key);
    if (old == null || newScore > old)
        Reflect.setField(scores, key, newScore);

    FlxG.save.flush();
}

function onSongEnd()
{
    saveModifierScore();
}