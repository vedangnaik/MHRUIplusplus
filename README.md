# MHR User Interface++

Have you ever wished that Monster Hunter Rise's UI was customizable? I mean, do I really need to know my Buddies' health all the time? Why is the quest timer so intrusive? And why can't I increase/decrease the font?? If so, then MHR User Interface++ is the mod for you!

MHR User Interface++ (abbreviated MHRUIpp) replaces MHR's default un-resizable, fixed UI with a set of highly customizable widgets that you can tune to your heart's content. Currently, the mod comes with:
- Health Bar++, a HP gauge with resizable text,
- Stamina Bar++, a stamina gauge with an added max down timer readout,
- Quest Timer++, a less intrusive and resizable quest timer,
- Debuff Indicator++, a stockalike, more informative indicator for debuffs like Fireblight, Poison, etc.,
- Buff Indicator++, similar to the previous but for buffs and Hunting Horn Bonuses like Attack Up, HH: Tremors Negated, etc., 
- Sharpness Gauge++, a more compact sharpness meter with added readout for the current level, and
- Monster HP Bar, a new addition to the UI that displays the nearest monster's HP.

![Screenshot (27)](https://user-images.githubusercontent.com/25436568/152444778-a085a53c-a98b-460e-a607-2177786a2864.png)

<p align="center"><em>An expedition showcasing unlimited quest time, Magma debuff, and recoverable health</em></p>

And this list is only growing! Planned widgets include:

- [x] A revamped sharpness indicator
- [x] A less-intrusive monster tracker
- [ ] Integrated monster stamina/status gauges a la [Monster Has HP Bar](https://www.nexusmods.com/monsterhunterrise/mods/43) and [Status Bars](https://www.nexusmods.com/monsterhunterrise/mods/113)
- [ ] [If possible] A more detailed minimap
- [ ] [If possible] Weapon-specific UI e.g. custom Charge Blade phials, Longsword gauge, etc.

Feel free to make suggestions for more widgets!

## Setup

### Installation

1. Install REFramework from [NexusMods](https://www.nexusmods.com/monsterhunterrise/mods/26) or [GitHub Releases](https://github.com/praydog/REFramework/releases).
2. Download MHRUIpp from either:
    - NexusMods: https://www.nexusmods.com/monsterhunterrise/mods/197
    - GitHub Releases: https://github.com/vedangnaik/MHRUIplusplus/releases
3. Extract the `reframework` folder into your MHRise installation folder. This is usually `<your Steam Library path>/steam/steamapps/common/MonsterHunterRise`. You can overwrite it if it already exists; your existing mods will be presevered.
4. Start the game, and enjoy!

### Customization and Saved Profiles
Every widget in MHRUIpp can be customized, and your options will be remembered across game sessions. MHRUIpp automatically creates and maintains persistant profiles in `reframework/data/MHRUIpp_Profiles`. To access the customization screen in-game, first open the REFramework menu with `Insert`. Then, access the various sub-menus under `Script Generated UI`.

### Uninstallation
Simply remove `reframework/auto/MHRUIpp`, `reframework/autorun/MHRUIpp_main.lua`, `reframework/data/MHRUIpp_Profiles`, and `reframework/fonts/Cascadia.ttf`.

## Thanks 💖
A huge thanks to
- [praydog](https://github.com/praydog) and [cursey](https://github.com/cursey) for helping me with REFramework,
- [cursecat](https://www.nexusmods.com/monsterhunterrise/users/27010739) for [Monster Has HP Bar](https://www.nexusmods.com/monsterhunterrise/mods/43), which helped me with the Monster HP Bar widget,
- [godoakos](https://www.nexusmods.com/monsterhunterrise/users/453968) for [Better Than Hanging](https://www.nexusmods.com/monsterhunterrise/mods/62), which helped me with keyboard input,
- the community of [Monster Hunter Modding Discord](https://discord.gg/gJwMdhK) for helping with other general stuff,

and many more too numerous to name here! 