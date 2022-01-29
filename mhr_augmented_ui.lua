local log_str = ""

-- Temporary logging function
re.on_draw_ui(function() 
    imgui.text(log_str)
end)

re.on_frame(function()
    -- Get GUI Manager
    local guiManager = sdk.get_managed_singleton("snow.gui.GuiManager")
    -- guiManager:call("openHud") -- Health bar, stamina bar, quest timer
    -- guiManager:call("openPartHud") -- Palico and Palamute health
    -- guiManager:call("openSharpnessHud") -- Sharpness gauge
    -- guiManager:call("openWeaponUI") -- Weapon-specific UI e.g. Charge Blade phials
    -- guiManager:call("setInvisibleAllGUI", false) -- Turn off 'all' GUI, too powerful i.e. removes map, pause window, everything

    local questUIManager = sdk.get_managed_singleton("snow.gui.QuestUIManager")
    -- questUIManager:call("closeQuestMapUI") -- Bottom-left minimap

    -- Get current player
    local playerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
    local player = playerManager:call("findMasterPlayer")

    -- TODO: 
    -- Get current/max health and stamina for player
    -- Get quest timer and elapsed time (can look at existing mods for this)
    -- Get monster health and place in convenient location (existing mods)
    -- If possible, get monster-specific part values/statuses, etc.
    -- If possible, reorganize Charge Blade weapon UI
    -- Get current/max sharpness value for weapon

    log_str = type(questUIManager)
end)