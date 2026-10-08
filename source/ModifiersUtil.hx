class ModifiersUtil
{
    public static var PREFIX:String = "modifiers_";

    public static var defaults:Map<String, Dynamic> = [
        "botplay" => false,
        "practice" => false,
        "scrollSpeedMult" => 1.0,
        "playbackRate" => 1.0,
        "healthGainMult" => 1.0,
        "healthLossMult" => 1.0,
        "maxHealthMult" => 1.0,
        "hitWindowsMult" => 1.0,
        "fadingNotes" => "off",
        "cameraFlip" => "off",
        "randomizedNotes" => false,
        "perfectionist" => "off",
        "dadHealthDrain" => 0.0,
        "poison" => 0.0,
    ];

    public static function register(name:String, def:Dynamic):Void
    {
        defaults.set(name, def);
        if (Reflect.field(FlxG.save.data, PREFIX + name) == null)
            Reflect.setField(FlxG.save.data, PREFIX + name, def);

        getScores();
    }

    public static function init():Void
    {
        for (name => def in defaults)
            if (Reflect.field(FlxG.save.data, PREFIX + name) == null)
                Reflect.setField(FlxG.save.data, PREFIX + name, def);
    }

    public static function resetToDefaults(flush:Bool = true):Void
    {
        for (name => def in defaults)
            Reflect.setField(FlxG.save.data, PREFIX + name, def);

        if (flush) FlxG.save.flush();
    }
    

    public static function get(name:String):Dynamic
    {
        var v = Reflect.field(FlxG.save.data, PREFIX + name);
        return v != null ? v : defaults.get(name);
    }

    public static function set(name:String, value:Dynamic):Void
    {
        Reflect.setField(FlxG.save.data, PREFIX + name, value);
    }

    public static function isDefault(name:String):Bool
    {
        return get(name) == defaults.get(name);
    }

    public static function hasActive():Bool
    {
        for (name in defaults.keys())
            if (!isDefault(name))
                return true;
        return false;
    }

    public static function getActive():Array<String>
    {
        return [for (name in defaults.keys()) if (!isDefault(name)) name];
    }

    public static function snapshot():String
    {
        var names = [for (name in defaults.keys()) name];
        names.sort(function(a, b) return Reflect.compare(a, b));
        return [for (name in names) Std.string(get(name))].join(",");
    }

    public static function getScores():Dynamic
    {
        FlxG.save.data.modifiers_songScores ??= {};
        return FlxG.save.data.modifiers_songScores;
    }

    public static function getBonus(name:String):Float
    {
        var v = get(name);
        return switch (name)
        {
            case "playbackRate": v - 1;
            case "scrollSpeedMult": (v - 1) * 0.5;
            case "healthGainMult": (v - 1) * -0.25;
            case "healthLossMult": (v - 1) * 0.25;
            case "maxHealthMult": (v - 1) * -0.2;
            case "hitWindowsMult": (v - 1) * -0.35;
            case "fadingNotes": (v != 'off') ? 0.25 : 0;
            case "cameraFlip":
                if (v == 'off') 0;
                else if (v == 'horizontal' || v == 'vertical') 0.25;
                else if (v == 'both') 0.5;
            case "randomizedNotes": v ? 0.1 : 0;
            case "perfectionist":
                if (v == 'off') 0;
                else (v == 'noMisses') ? 0.15 : 0.4;
            case "dadHealthDrain": v * 0.25;
            case "poison": v * 0.15;
            default: 0;
        }
    }

    public static function getMultiplier():Float
    {
        var total:Float = 0;
        for (name in defaults.keys())
            total += getBonus(name);
        return Math.max(1 + total, 0);
    }

    public static function isScoreEligible():Bool
        return !get("botplay") && !get("practice");
}
