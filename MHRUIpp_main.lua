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


-- local function displaySharpnessOnFrame()
--   -- Get current player
--   local playerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
--   local player = playerManager:call("findMasterPlayer")

--   -- Display sharpness
--   local current_sharpness = player:get_field("<SharpnessGauge>k__BackingField")
--   local max_sharpness = player:get_field("<SharpnessGaugeMax>k__BackingField")

--   draw.filled_rect(500, 500, max_sharpness, 20, 0xFF000000)
-- end

local function drawHPBar()
  -- Get all HP stuff
	local playerData = getPlayer():call("get_PlayerData")
	local currentHP = playerData:get_field("_r_Vital")
	local maxHP = playerData:get_field("_vitalMax")
	drawGauge(
		5, 5, 
		500, 20, 
		currentHP / maxHP, 0xAA228B22, 
		string.format("Health: %d/%d", currentHP, maxHP)
	)
end

local function drawStaminaBar()
	-- Get all stamina stuff
	local playerData = getPlayer():call("get_PlayerData")
	local currentStamina = playerData:get_field("_stamina")
	local maxStamina = playerData:get_field("_staminaMax")
	local timeUntilStaminaMaxReduces = playerData:get_field("_staminaMaxDownIntervalTimer")
	drawGauge(
		5, 30, 
		500, 20,
		currentStamina / maxStamina, 0xAA23C5EE, 
		string.format("Stamina: %.2f/%.2f \t Max reduction in %.0f ms", currentStamina, maxStamina, timeUntilStaminaMaxReduces)
	)
end

local function drawQuestTimer()
	local questManager = sdk.get_managed_singleton("snow.QuestManager")
	local activeQuestData = questManager:call("getActiveQuestData")
	if activeQuestData then
		local timeLimit = activeQuestData:call("getTimeLimit")
		local elapsedTimeSeconds = questManager:call("getQuestElapsedTimeSec");

		log_str = string.format("Time: %02d:%02.0f/%02d m", elapsedTimeSeconds // 60, elapsedTimeSeconds % 60, timeLimit)
	end
end

-- closeUI
local function hideUI()
  local guiManager = sdk.get_managed_singleton("snow.gui.GuiManager")
  guiManager:call("closeHud") -- Disable Health bar, stamina bar, quest timer, etc.
  guiManager:call("closePartHud") -- Disable Palico and Palamute health
  guiManager:call("closeHudSharpness") -- Disable sharpness gauge
  -- guiManager:call("openWeaponUI") -- Weapon-specific UI e.g. Charge Blade phials
  -- guiManager:call("setInvisibleAllGUI", false) -- Turn off 'all' GUI, too powerful i.e. removes map, pause window, everything
  -- guiManager:call("closeAllQuestHudUI") -- Potentially useful, turns of all HUD i.e. items, everything
end
local function restoreUI()
  local guiManager = sdk.get_managed_singleton("snow.gui.GuiManager")
  guiManager:call("openHud") -- Enable Health bar, stamina bar, quest timer, etc.
  guiManager:call("openPartHud") -- Enable Palico and Palamute health
  guiManager:call("openHudSharpness") -- Enable sharpness gauge
end



-- Hook to change in Kamura Area
sdk.hook(VillageAreaManager_typedef:get_method("callAfterAreaActivation"),
function(args)
  if getCurrentAreaNoInKamura() == 5 then
		showCustomUI = true
  else
		showCustomUI = false
  end
end, function(retval) end)

-- Hook into quest start
sdk.hook(StageManager_typedef:get_method("onQuestStart"), function(args)
	log_str = "Started quest..."
	showCustomUI = true
end, function(retval) end)

-- Hook into quest end/return/clear/etc
sdk.hook(QuestManager_typedef:get_method("onQuestEnd"), function(args)
	log_str = "Ended quest..."
	showCustomUI = false
end, function(retval) end)
sdk.hook(QuestManager_typedef:get_method("onQuestReturn"), function(args)
	log_str = "Returned from quest..."
	showCustomUI = false
end, function(retval) end)
sdk.hook(StageManager_typedef:get_method("onQuestClear"), function(args)
	log_str = "Cleared quest..."
	showCustomUI = false
end, function(retval) end)

-- Temporary Logging function
re.on_draw_ui(function() 
  imgui.text(tostring(log_str))
end)

-- Game loop function
re.on_frame(function()
	if showCustomUI then
		-- log_str = "[MHRUIpp] Custom UI enabled"
		hideUI()
		drawHPBar()
		drawStaminaBar()
		drawQuestTimer()
	else
		-- log_str = "[MHRUIpp] Custom UI disbled"
	end
end)