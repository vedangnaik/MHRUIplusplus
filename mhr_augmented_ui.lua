local log_str = ""

re.on_draw_ui(function() 
    imgui.text(log_str)
end)

local print

re.on_frame(function()
    -- Get current player
    local playerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
    local player = playerManager:call("findMasterPlayer")
    local weaponType = player:get_field("_playerWeaponType")
    -- 11 = Charge Blade. Called Charge Axe in code
    log_str = weaponType

    -- Get GUI Manager
    local guiManager = sdk.get_managed_singleton("snow.gui.GuiManager")
    -- guiManager:call("openHud") -- Health bar, stamina bar, quest timer
    -- guiManager:call("openPartHud") -- Palico and Palamute health
    -- guiManager:call("openSharpnessHud") -- Sharpness gauge
    -- guiManager:call("openWeaponUI") -- Weapon-specific UI e.g. Charge Blade phials
    -- guiManager:call("setInvisibleAllGUI", false) -- Turn off 'all' GUI, too powerful i.e. removes map, pause window, everything

    local questUIManager = sdk.get_managed_singleton("snow.gui.QuestUIManager")
    -- questUIManager:call("closeQuestMapUI") -- Bottom-left minimap

    log_str = type(questUIManager)
end)