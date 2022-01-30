require('MHRUIpp/helpers')

log.info("Loading MHR UI++ main.lua...")

-- TODO: 
-- Get current/max health and stamina for player
-- Get quest timer and elapsed time (can look at existing mods for this)
-- Get monster health and place in convenient location (existing mods)
-- If possible, get monster-specific part values/statuses, etc.
-- If possible, reorganize Charge Blade weapon UI
-- Get current/max sharpness value for weapon
-- Find way to remove top-right monster tracker thing


local function displaySharpnessOnFrame()
  -- Get current player
  local playerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
  local player = playerManager:call("findMasterPlayer")

  -- Display sharpness
  local current_sharpness = player:get_field("<SharpnessGauge>k__BackingField")
  local max_sharpness = player:get_field("<SharpnessGaugeMax>k__BackingField")

  draw.filled_rect(500, 500, max_sharpness, 20, 0xFF000000)
end

-- closeUI
local function hideUI()
  local guiManager = sdk.get_managed_singleton("snow.gui.GuiManager")
  guiManager:call("closeHud") -- Disable Health bar, stamina bar, quest timer, etc.
  guiManager:call("closePartHud") -- Disable Palico and Palamute health
  guiManager:call("closeSharpnessHud") -- Disable sharpness gauge
  -- guiManager:call("openWeaponUI") -- Weapon-specific UI e.g. Charge Blade phials
  -- guiManager:call("setInvisibleAllGUI", false) -- Turn off 'all' GUI, too powerful i.e. removes map, pause window, everything
  -- guiManager:call("closeAllQuestHudUI") -- Potentially useful, turns of all HUD i.e. items, everything
end

local function restoreUI()
  local guiManager = sdk.get_managed_singleton("snow.gui.GuiManager")
  guiManager:call("openHud") -- Enable Health bar, stamina bar, quest timer, etc.
  guiManager:call("openPartHud") -- Enable Palico and Palamute health
  guiManager:call("openSharpnessHud") -- Enable sharpness gauge
end
restoreUI()


-- Works for detecting quest end/return
-- local QuestManager_typedef = sdk.find_type_definition("snow.QuestManager")
-- sdk.hook(QuestManager_typedef:get_method("onQuestEnd"), function(args)
--     log.info("A quest was ended")
-- end, function(retval) end)
-- sdk.hook(QuestManager_typedef:get_method("onQuestReturn"), function(args)
--     log.info("A quest was returned from")
-- end, function(retval) end)

-- -- Works for detecting quest start/clear
-- local StageManager_typedef = sdk.find_type_definition("snow.stage.StageManager")
-- sdk.hook(StageManager_typedef:get_method("onQuestStart"), function(args)
--     log.info("A quest was started")
-- end, function(retval) end)
-- sdk.hook(StageManager_typedef:get_method("onQuestClear"), function(args)
--     log.info("A quest was cleared")
-- end, function(retval) end)

-- -- Hook to QuestStart
-- sdk.hook(StageManager_typedef:get_method("onQuestStart"),
-- function(args)
-- end,
-- function(retval)
-- end)

-- Hook to change in Kamura Area
sdk.hook(VillageAreaManager_typedef:get_method("callAfterAreaActivation"),
function(args)
  if getCurrentAreaNoInKamura() == 5 then
    log_str = enteredTrainingArea
    hideUICountdown = 100
  else
    log_str = leftTrainingArea
    restoreUICountdown = 100
  end
end, function(retval) end)


-- Temporary Logging function
re.on_draw_ui(function() 
  imgui.text(tostring(log_str))
end)

-- Game loop function
re.on_frame(function()
  if hideUICountdown > 0 then
    -- log.info("here")
    hideUI()
    hideUICountdown = hideUICountdown - 1
  end

  if restoreUICountdown > 0 then
    restoreUI()
    restoreUICountdown = restoreUICountdown - 1
  end

  -- log.info(hideUICountdown .. " " .. restoreUICountdown)
end)