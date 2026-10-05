import funkin.backend.system.Logs;
import funkin.backend.system.console.ConsoleCommand.FuncCommand;
import ModifiersUtil;

var openModifiers = new FuncCommand("openModifiers", "[fromPause]", "(opens ModifiersMenu substate)", function(args)
{
    if (args[0] != null)
    {
        if (args[0] != "true")
        {
            if (args[0] != "false")
            {
                Logs.error('[fromPause] must either be "true", "false", or left blank.');
                return;
            }
        }
    }

    var comingFromPause:Bool = args[0] == "true";

    FlxG.state.persistentUpdate = false;
    FlxG.state.openSubState(new ModSubState("ModifiersMenu"), {fromPause: comingFromPause});
});

function new()
{
    ModifiersUtil.init();
}

/**
 * this is for incase any mod creators want to support the addon!
 * 
 * example:
 * #if CNE_MODIFIERS
 * // code for only when this addon is enabled
 * #end
 * 
 * can be useful for your freeplay/pause menus and such
 */
function onScriptCreated(script:Script, type:String)
{
    if (type != "hscript") return;

    script.parser.preprocessorValues.set("CNE_MODIFIERS", true);
}

function destroy()
{
    openModifiers = null;
}