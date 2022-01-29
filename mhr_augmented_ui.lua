-- TODO: 
-- Get current/max health and stamina for player
-- Get quest timer and elapsed time (can look at existing mods for this)
-- Get monster health and place in convenient location (existing mods)
-- If possible, get monster-specific part values/statuses, etc.
-- If possible, reorganize Charge Blade weapon UI
-- Get current/max sharpness value for weapon
-- Find way to remove top-right monster tracker thing


-- Temporary logging function
local log_str = ""
re.on_draw_ui(function() 
    imgui.text(tostring(log_str))
end)

local function closeUI()
    -- Get GUI Manager
    local guiManager = sdk.get_managed_singleton("snow.gui.GuiManager")
    -- guiManager:call("openHud") -- Health bar, stamina bar, quest timer
    -- guiManager:call("openPartHud") -- Palico and Palamute health
    guiManager:call("openSharpnessHud") -- Sharpness gauge
    -- guiManager:call("openWeaponUI") -- Weapon-specific UI e.g. Charge Blade phials
    -- guiManager:call("setInvisibleAllGUI", false) -- Turn off 'all' GUI, too powerful i.e. removes map, pause window, everything

    -- Get QuestUIManager
    local questUIManager = sdk.get_managed_singleton("snow.gui.QuestUIManager")
    -- questUIManager:call("closeQuestMapUI") -- Bottom-left minimap
end

local function displaySharpnessOnFrame()
    -- Get current player
    local playerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
    local player = playerManager:call("findMasterPlayer")

    -- Display sharpness
    local current_sharpness = player:get_field("<SharpnessGauge>k__BackingField")
    local max_sharpness = player:get_field("<SharpnessGaugeMax>k__BackingField")

    draw.filled_rect(500, 500, max_sharpness, 20, 0xFF000000)
end

local function displayCurrentScene()
    -- local sceneManager = sdk.get_native_singleton("via.SceneManager")
    -- local scenes = sdk.call_native_func(sceneManager, sdk.find_type_definition("via.SceneManager"), "get_Scenes")
    -- log_str = scenes[0]:call("get_Name")

    -- Get current player
    local playerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
    local player = playerManager:call("findMasterPlayer")

    -- get Area Numbers inside Kamura e.g. Buddy Plaza = 2, Training Area = 5, etc. Sandy Plains, etc. are all zero.
    local area = player:call("get_AreaNo")
    local maxField = player:call("get_MaxFieldBlockNo")
    local currentField = player:call("get_CurrentFieldBlockNo")

    local blockSectionAttr = player:call("get_FieldBlockSectionAttr")

    log_str = string.format("Area: %02d | MaxField: %02d | CurrentField: %02d | attr: %02d", area, maxField, currentField, blockSectionAttr)
end


-- local typedef = sdk.find_type_definition("snow.enemy.EnemyCharacterBase")
-- local update_method = typedef:get_method("onDestroy")
-- sdk.hook(update_method, function(args)
--     log.info("Here")
-- end, function(retval) end)

-- Works for detecting quest end/return
local QuestManager_typedef = sdk.find_type_definition("snow.QuestManager")
sdk.hook(QuestManager_typedef:get_method("onQuestEnd"), function(args)
    log.info("A quest was ended")
end, function(retval) end)
sdk.hook(QuestManager_typedef:get_method("onQuestReturn"), function(args)
    log.info("A quest was returned from")
end, function(retval) end)

-- Works for detecting quest start/clear
local StageManager_typedef = sdk.find_type_definition("snow.stage.StageManager")
sdk.hook(StageManager_typedef:get_method("onQuestStart"), function(args)
    log.info("A quest was started")
end, function(retval) end)
sdk.hook(StageManager_typedef:get_method("onQuestClear"), function(args)
    log.info("A quest was cleared")
end, function(retval) end)

-- Called when a change to village area occurs. Can use to detect training room via area numbers
local VillageAreaManager_typedef = sdk.find_type_definition("snow.VillageAreaManager")
sdk.hook(VillageAreaManager_typedef:get_method("callAfterAreaActivation"), function(args)
    local VillageAreaManager = sdk.to_managed_object(args[2])
    log.info(string.format("Moved to area %02d", VillageAreaManager:call("get__CurrentAreaNo")))
end, function(retval) end)


re.on_frame(function() 
    
end)