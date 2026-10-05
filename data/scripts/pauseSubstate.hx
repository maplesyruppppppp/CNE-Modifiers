var waitingForModifiers:Bool = false;
var modifiersSnapshot:String = "";

function create()
{
    menuItems.insert(menuItems.length - 1, "Modifiers");
}

function onSelectOption(event)
{
    if (event.name == "Modifiers")
    {
        event.cancel();
        openSubState(new ModSubState("ModifiersMenu",
        {
            fromPause: true,
            onClose: function(changed:Bool)
            {
                if (!changed) return;

                parentDisabler.reset();
			    game.registerSmoothTransition();
                FlxG.resetState();
            }
        }));
    }
}