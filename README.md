# QETweaks

A collection of "tweaks" (small mods) for Quake Enhanced multiplayer servers.

Several of these are not my own mods, see Credits/Acknowledgements below!

## Enabling tweaks

Set `saved1` console variable to desired value before starting a server.
If you want to change the value, restart the map.

## Tweak values

You can activate multiple tweaks by adding the values together (eg 1 + 2 = 3).

### 1: GGMod weapon adjustments enabled

* Axe does 125 damage
* Nail travel speed is increased 2.75x (damage and rate of fire are unchanged)
* Super shotgun fires ~3x pellets but has ~2x reload time (think Doom 2 SSG)

### 2: Map `start` (Introduction) floor open

The floor/stairs that would normally open after collecting all 4 runes
(before the boss level) will be open on `start`.

### 4: Map `dm1` (Place of Two Deaths) weapons upgraded

The nailguns are replaced with rocket launchers and the super shotgun is
replaced with a lightning on `dm1`. Appropriate ammo is also replaced.

### 8: Double-jump enabled

You can double-jump.

### 16: Grappling hook enabled

The beloved grappling hook (aka morning star) from Threewave CTF.
Press '1' to cycle between axe and grapple, or bind a key to "impulse 22" to
switch straight to grapple.

### 32: Player HUD enabled

Print a game timer, current score, and weapon+ammo info to the screen to
compliment the minimal HUD. Set `scr_usekfont 0` for best-looking version.
Note that this conflicts with drawing speedometer.

### 64: Speedometer enabled

Print a speedometer. Set `scr_usekfont 0` for best-looking version.
Note that this conflicts with drawing Player HUD.

## Credits/Acknowledgements

Thanks to:

* [JPiolho](https://github.com/jpiolho) for all the advice, help, and code.
* Dan The Man for the `start` map door code.
* teamred for the double-jump mod.
* Dave "Zoid" Kirsch and "Mike" for grappling hook/morning star.
* Kilomile for the inspired GGmod weapon adjustments.
* All the great folks in the
  [QE community Discord](https://discord.qethings.xyz/)

Be sure to check out the
[QE Things Multiplayer mods page](https://mpmods.qethings.xyz/)!
