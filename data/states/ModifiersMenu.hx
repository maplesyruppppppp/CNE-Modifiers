import funkin.backend.utils.TranslationUtil as TU;
import funkin.menus.ui.Alphabet;
import ModifiersUtil;

var fromPause:Bool = false;

var startValues:String = "";
var changed:Bool = false;

var items:Array<Dynamic> = [
    {id: "botplay",         type: "bool"},
    {id: "practice",        type: "bool"},
    {id: "scrollSpeedMult", type: "float", min: 0.5, max: 3.0, step: 0.05, suffix: "x"},
    {id: "playbackRate",    type: "float", min: 0.5, max: 3.0, step: 0.05, suffix: "x"},
    {id: "healthGainMult",  type: "float", min: 0.0, max: 2.0, step: 0.05, suffix: "x"},
    {id: "healthLossMult",  type: "float", min: 0.5, max: 3.0, step: 0.05, suffix: "x"},
    {id: "maxHealthMult",   type: "float", min: 0.5, max: 2.0, step: 0.05, suffix: "x"},
    {id: "hitWindowsMult",  type: "float", min: 0.5, max: 3.0, step: 0.05, suffix: "x"},
    {id: "fadingNotes",     type: "array", options: ["off", "away", "in"]},
    {id: "cameraFlip",      type: "array", options: ["off", "vertical", "horizontal", "both"]},
    {id: "randomizedNotes", type: "bool"},
    {id: "perfectionist",   type: "array", options: ["off", "noMisses", "sicksOnly"]},
];
var itemTexts:Array<Alphabet> = [];
var curSelected:Int = 0;

var descText:FunkinText;
var descBG:FlxSprite;

var bonusText:FunkinText;
var pctTexts:Array<FunkinText> = [];

var checkboxes:Array<FunkinSprite> = [];

var menuCam:FlxCamera;

var HOLD_DELAY:Float = 0.35;
var HOLD_INTERVAL:Float = 0.06;
var holdTime:Float = 0;
var holdTimer:Float = 0;
var holdBlocked:Bool = false;

var loaded:Bool = false;

function formatPercent(b:Float):String
{
    var n = Math.round(b * 100);
    return (n > 0 ? "+" : "") + n + "%";
}

function create()
{
    fromPause = data != null && data.fromPause == true;

    menuBG = new FlxSprite().loadGraphic(Paths.image('menus/menuTransparent'));
    menuBG.scrollFactor.set();
    menuBG.alpha = 0;
    menuBG.antialiasing = true;
    add(menuBG);

    for (i in 0...items.length)
    {
        var a = new Alphabet(80, 200 + i * 90, "", true);
        a.isMenuItem = true;
        a.targetY = i;
        itemTexts.push(a);
        add(a);

        var p = new FunkinText(0, 0, 400, "", 20);
        p.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, "left");
        p.borderSize = 2;
        add(p);
        pctTexts.push(p);

        if (items[i].type == "bool")
        {
            var cb = new FunkinSprite();
            cb.frames = Paths.getSparrowAtlas("menus/options/checkboxThingie");
            cb.animation.addByPrefix("off", "Check Box unselected", 24, false);
            cb.animation.addByPrefix("on", "Check Box selected", 24, false);
            cb.animation.addByPrefix("turnOn", "Check Box selecting animation", 24, false);
            cb.animation.addByPrefix("turnOff", "Check Box deselect animation", 24, false);
            cb.addOffset("off", 0, -30);
            cb.addOffset("on", 17, 0);
            cb.addOffset("turnOn", 34, 70);
            cb.addOffset("turnOff", 24, 30);
            cb.scale.set(0.7, 0.7);
            cb.updateHitbox();
            add(cb);
            checkboxes.push(cb);
        }
        else
            checkboxes.push(null);
    }

    var titleBG = new FlxSprite(0, 30).makeSolid(500, 125, 0x52000000);
    titleBG.screenCenter(FlxAxes.X);
    titleBG.scrollFactor.set();
    add(titleBG);

    var title = new Alphabet(0, 40, TU.translate("modifiers.menu.title"), true);
    title.screenCenter(FlxAxes.X);
    add(title);

    bonusText = new FunkinText(0, 120, FlxG.width, "", 24);
    bonusText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, "center");
    bonusText.borderSize = 2;
    add(bonusText);

    descBG = new FlxSprite().makeGraphic(FlxG.width, 1, 0xAB000000);
    add(descBG);

    descText = new FunkinText(0, 0, FlxG.width - 40, "", 16);
    descText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, "center");
    descText.borderSize = 2;
    add(descText);

    menuCam = new FlxCamera();
    menuCam.bgColor = 0xC0000000;
    FlxG.cameras.add(menuCam, false);
    cameras = [menuCam];

    refresh();

    startValues = ModifiersUtil.snapshot();

    new FlxTimer().start(0.001, function()
    {
        loaded = true;
    });
}

private var TEXT_MODIFIERS_SCORE_BONUS = TU.getRaw("modifiers.menu.scoreBonus");

function refresh()
{
    for (i in 0...items.length)
    {
        var it = items[i];
        var label = TU.translate("modifiers.menu." + it.id);
        var a = itemTexts[i];
        var sel = (i == curSelected);

        a.targetY = i - curSelected;
        a.alpha = sel ? 1 : 0.6;

        if (it.type == "bool")
        {
            a.text = label;

            var cb = checkboxes[i];
            cb.playAnim(ModifiersUtil.get(it.id) ? "on" : "off", true);
            cb.alpha = sel ? 1 : 0.6;
        }
        else if (it.type == "array")
            a.text = label + ": " + TU.translate("modifiers.menu." + it.id + "." + ModifiersUtil.get(it.id));
        else
            a.text = label + ": " + ModifiersUtil.get(it.id) + (it.suffix != null ? it.suffix : "");

        var bonus = ModifiersUtil.getBonus(it.id);
        var p = pctTexts[i];
        p.visible = bonus != 0;
        p.text = formatPercent(bonus) + " score";
        p.alpha = sel ? 1 : 0.6;
    }

    if (!ModifiersUtil.isScoreEligible())
        bonusText.text = TU.translate("modifiers.menu.noScore");
    else
        bonusText.text = TEXT_MODIFIERS_SCORE_BONUS.format([formatPercent(ModifiersUtil.getMultiplier() - 1)]);

    descText.text = TU.translate("modifiers.menu." + items[curSelected].id + ".description");
    descText.x = (FlxG.width - descText.width) / 2;
    if (fromPause)
    {
        descText.text += "\n" + TU.translate('modifiers.menu.changes');
    }

    descBG.setGraphicSize(FlxG.width, descText.height + 8);
    descBG.updateHitbox();
    descBG.y = FlxG.height - descBG.height;
    descText.y = descBG.y + 4;
}

function changeSelection(change:Int)
{
    holdTime = 0;
    holdBlocked = true;

    curSelected = FlxMath.wrap(curSelected + change, 0, items.length - 1);
    FlxG.sound.play(Paths.sound("menu/scroll"));
    refresh();
}

function changeValue(dir:Int, mult:Int)
{
    var it = items[curSelected];
    var moved:Bool = true;

    if (it.type == "bool")
    {
        ModifiersUtil.set(it.id, !ModifiersUtil.get(it.id));
        refresh();

        checkboxes[curSelected].playAnim(ModifiersUtil.get(it.id) ? "turnOn" : "turnOff", true);
    }
    else if (it.type == "float")
    {
        var old = ModifiersUtil.get(it.id);

        var v = old + dir * it.step * mult;
        v = Math.round(v * 100) / 100;
        v = FlxMath.bound(v, it.min, it.max);

        moved = v != old;
        if (moved)
        {
            ModifiersUtil.set(it.id, v);
            refresh();
        }
    }
    else if (it.type == "array")
    {
        var idx = it.options.indexOf(ModifiersUtil.get(it.id));
        if (idx < 0) idx = 0;

        idx = FlxMath.wrap(idx + dir, 0, it.options.length - 1);
        ModifiersUtil.set(it.id, it.options[idx]);
        refresh();
    }

    if (moved)
        FlxG.sound.play(Paths.sound("menu/scroll"));
}

function update(elapsed:Float)
{
    if (!loaded) return;

    menuBG.alpha = lerp(menuBG.alpha, 0.1, 0.125);

    for (i in 0...items.length)
    {
        var a = itemTexts[i];

        pctTexts[i].x = a.x + 6;
        pctTexts[i].y = a.y + 74;

        var cb = checkboxes[i];
        if (cb != null)
        {
            cb.x = a.x + a.width + 20;
            cb.y = a.y - 20;
        }
    }

    for (cb in checkboxes)
    {
        if (cb == null || cb.animation.curAnim == null || !cb.animation.curAnim.finished)
            continue;

        switch (cb.animation.curAnim.name)
        {
            case "turnOn": cb.playAnim("on", true);
            case "turnOff": cb.playAnim("off", true);
        }
    }

    var upP = controls.UP_P;
    var downP = controls.DOWN_P;
    var scroll = FlxG.mouse.wheel;

    if (upP || downP || scroll != 0)
        changeSelection((upP ? -1 : 0) + (downP ? 1 : 0) - scroll);

    var it = items[curSelected];
    var dir = (controls.RIGHT ? 1 : 0) - (controls.LEFT ? 1 : 0);

    if (dir == 0)
    {
        holdTime = 0;
        holdTimer = 0;
        holdBlocked = false;
    }
    else if (controls.LEFT_P || controls.RIGHT_P)
    {
        holdTime = 0;
        holdTimer = HOLD_DELAY;
        holdBlocked = false;

        // booleans only change with accept
        if (it.type != "bool") changeValue(dir, 1);
    }
    else if (it.type == "float" && !holdBlocked)
    {
        holdTime += elapsed;
        holdTimer -= elapsed;

        if (holdTimer <= 0)
        {
            holdTimer += HOLD_INTERVAL;

            // the longer you hold, the bigger the jumps
            var mult = holdTime > 1.6 ? 10 : (holdTime > 0.8 ? 4 : 1);
            changeValue(dir, mult);
        }
    }

    if (controls.ACCEPT && (it.type == "bool")) changeValue(1, 1);

    if (controls.BACK)
    {
        changed = ModifiersUtil.snapshot() != startValues;
        FlxG.save.flush();
        FlxG.sound.play(Paths.sound("menu/cancel"));
        FlxG.cameras.remove(menuCam);

        close();
    }
}

function onClosePost()
{
    if (data != null && data.onClose != null)
        data.onClose(changed);
}