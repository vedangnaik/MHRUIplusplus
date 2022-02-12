# MHR User Interface++

Have you ever wished that Monster Hunter Rise's UI was customizable? I mean, do I really need to know my Buddies' health all the time? Why is the quest timer so intrusive? And why can't I increase/decrease the font?? If so, then MHR User Interface++ is the mod for you!

MHR User Interface++ (abbreviated MHRUIpp) replaces MHR's default un-resizable, fixed UI with a set of highly customizable widgets that you can tune to your heart's content. Currently, the mod comes with replacements for the health gauge, the stamina gauge, the debuff indicator, and the quest timer:

![Screenshot (27)](https://user-images.githubusercontent.com/25436568/152444778-a085a53c-a98b-460e-a607-2177786a2864.png)

<p align="center"><em>An expedition showcasing unlimited quest time, Magma debuff, and recoverable health</em></p>

And this list is only growing! Planned widgets include:

- [x] A revamped sharpness indicator
- [ ] A less-intrusive monster tracker
- [ ] Integrated monster health/stamina/status gauges a la [Monster Has HP Bar](https://www.nexusmods.com/monsterhunterrise/mods/43) and [Status Bars](https://www.nexusmods.com/monsterhunterrise/mods/113)
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
