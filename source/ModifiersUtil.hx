import haxe.ds.StringMap;
import haxe.xml.Access;

class ModifiersUtil
{
    public static var PREFIX:String = "modifiers_";

    public static var list:Array<Dynamic> = [];
    public static var byId:StringMap<Dynamic> = new StringMap();
    public static var defaults:StringMap<Dynamic> = new StringMap();

    static function num(x:Xml, name:String):Float
        return x.exists(name) ? Std.parseFloat(x.get(name)) : 0;

    public static function load():Void
    {
        if (list.length > 0) return;

        var root = Xml.parse(Assets.getText(Paths.xml("config/modifiers"))).firstElement();

        for (m in root.elementsNamed("modifier"))
        {
            var type = m.get("type");
            var defStr = m.get("default");
            var def:Dynamic = switch (type)
            {
                case "bool": defStr == "true";
                case "float": Std.parseFloat(defStr);
                default: defStr;
            }

            var info:Dynamic = {
                id: m.get("id"),
                type: type,
                def: def,
                disablesScore: m.exists("disablesScore") && m.get("disablesScore") == "true",
                bonus: num(m, "bonus"),
                min: num(m, "min"),
                max: num(m, "max"),
                step: num(m, "step"),
                suffix: m.exists("suffix") ? m.get("suffix") : null,
                base: num(m, "base"),
                scale: num(m, "scale"),
                options: [],
                optionBonus: new StringMap()
            };

            for (o in m.elementsNamed("option"))
            {
                info.options.push(o.get("id"));
                info.optionBonus.set(o.get("id"), Std.parseFloat(o.get("bonus")));
            }

            list.push(info);
            byId.set(info.id, info);
            defaults.set(info.id, def);
        }
    }

    public static function register(name:String, def:Dynamic):Void
    {
        defaults.set(name, def);
        if (Reflect.field(FlxG.save.data, PREFIX + name) == null)
            Reflect.setField(FlxG.save.data, PREFIX + name, def);

        getScores();
    }

    public static function init():Void
    {
        load();
        for (name in defaults.keys())
        {
            var def = defaults.get(name);
            if (Reflect.field(FlxG.save.data, PREFIX + name) == null)
                Reflect.setField(FlxG.save.data, PREFIX + name, def);
        }
    }

    public static function resetToDefaults(flush:Bool = true):Void
    {
        for (name in defaults.keys())
        {
            var def = defaults.get(name);
            Reflect.setField(FlxG.save.data, PREFIX + name, def);
        }

        if (flush) FlxG.save.flush();
    }
    

    public static function get(name:String):Dynamic
    {
        load();
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
        load();
        var m = byId.get(name);
        if (m == null) return 0;

        var v = get(name);
        return switch (m.type)
        {
            case "bool": v ? m.bonus : 0;
            case "array": m.optionBonus.exists(v) ? m.optionBonus.get(v) : 0;
            default: (v - m.base) * m.scale;
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
    {
        load();
        for (m in list)
            if (m.disablesScore && get(m.id) == true) return false;
        return true;
    }
}
