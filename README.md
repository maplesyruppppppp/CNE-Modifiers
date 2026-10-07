# Codename Engine Modifiers

> [!NOTE]
> This was made using a v1.1.0 rc-3+ build, it's recommended to use that version for this addon!

An addon for Codename Engine that adds modifiers to spice up gameplay!<br>
Using modifiers in songs will multiply the amount of score you get and gets saved as separate save data.

Current modifiers:
- Botplay (Disables score multiplication)
- Practice mode (Disables score multiplication)
- Scroll Speed Multiplication
- Playback Rate
- Health Gain Multiplication
- Health Loss Multiplication
- Hit Windows Multiplication
- Fading Notes (both fade in and away)
- Camera Flipping (both horizontal and vertical)
- Randomized Notes
- Perfectionist (note misses or sick ratings only) 

## Modding
This addon includes a preprocessor that can be used to detect if the addon is enabled in your mods, meaning you can add modifiers support to your mod if you want to!
```hx
#if CNE_MODIFIERS
// code for when the addon is active
#end
```
