//
import funkin.backend.utils.TranslationUtil as TU;
import funkin.options.TreeMenu;
import ModifiersUtil;

using StringTools;

var modScoreText:FunkinText;
var lastShownModScore:Int = -1;

function postCreate()
{
    modScoreText = new FunkinText(scoreText.x, scoreText.y, 0, "", 32);
    modScoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "right");
    modScoreText.visible = false;
    add(modScoreText);

    bottomBG = new FunkinSprite(null, null);
    add(bottomBG);

    bottomText = new FunkinText(bottomBG.x, null, FlxG.width, TU.translate("modifiers.freeplay.info"), 16);
    bottomText.y = FlxG.height - bottomText.height;
    bottomText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, 'center', null);
	bottomText.borderSize = 2;
    add(bottomText);

    bottomBG.makeSolid(FlxG.width, bottomText.height + 4, 0xAB000000);
    bottomBG.y = FlxG.height - bottomBG.height;
}

var lerpModScore:Float = 0;

function getModScore():Int
{
    var scores = FlxG.save.data.modifiers_songScores;
    if (scores == null || curSong == null || curDifficulties.length == 0) return 0;

    var v = Reflect.field(scores, curSong.name + ":" + curDifficulties[curDifficulty]);
    return v != null ? Std.int(v) : 0;
}

private var TEXT_FREEPLAY_SCORE_MODIFIERS = TU.getRaw("modifiers.freeplay.scoreModifiers");

function postUpdate()
{
    if (FlxG.keys.justPressed.M)
    {
        persistentUpdate = false;
        openSubState(new ModSubState("ModifiersMenu", {fromPause: false}));
    }

    scoreText.visible = !ModifiersUtil.hasActive();
    modScoreText.visible = ModifiersUtil.hasActive();

    if (!ModifiersUtil.hasActive()) return;

    var modScore = getModScore();
    lerpModScore = lerp(lerpModScore, modScore, 0.4);
    if (Math.abs(lerpModScore - modScore) <= 10) lerpModScore = modScore;

    var shown = Math.round(lerpModScore);
    if (shown != lastShownModScore)
    {
        lastShownModScore = shown;
        modScoreText.text = TEXT_FREEPLAY_SCORE_MODIFIERS.format([shown]);
    }

    scoreBG.scale.set(
        Math.max(Math.max(diffText.width, modScoreText.width), coopText.width) + 8,
        coopText.visible ? coopText.y + coopText.height : 66
    );
    scoreBG.updateHitbox();
    scoreBG.x = FlxG.width - scoreBG.width;

    scoreText.x = coopText.x = modScoreText.x = scoreBG.x + 4;
    modScoreText.y = scoreText.y;
    diffText.x = Std.int(scoreBG.x + ((scoreBG.width - diffText.width) / 2));
}