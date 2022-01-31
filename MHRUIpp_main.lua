-- TODO: 
-- Get current/max health and stamina for player
-- Get quest timer and elapsed time (can look at existing mods for this)
-- Get monster health and place in convenient location (existing mods)
-- If possible, get monster-specific part values/statuses, etc.
-- If possible, reorganize Charge Blade weapon UI
-- Get current/max sharpness value for weapon
-- Find way to remove top-right monster tracker thing

require("MHRUIpp/helpers")
require("MHRUIpp/HealthBarPP")
require("MHRUIpp/CloseUI")

log.info("Loading MHR UI++ main.lua...")

-- Global variable that indicates whether MHRUIpp is being displayed or not.
showMHRUIpp = true

-- Hook to change in Kamura Area
sdk.hook(VillageAreaManager_typedef:get_method("callAfterAreaActivation"),
function(args)
	if isInTrainingArea() then
		showMHRUIpp = true
	else
		showMHRUIpp = false
	end
end, function(retval) end)

-- Hook into quest start
sdk.hook(StageManager_typedef:get_method("onQuestStart"), function(args)
	log_str = "Started quest..."
	showMHRUIpp = true
end, function(retval) end)

-- Hook into quest end/return/clear/etc
sdk.hook(QuestManager_typedef:get_method("onQuestEnd"), function(args)
	log_str = "Ended quest..."
	showMHRUIpp = false
end, function(retval) end)
sdk.hook(QuestManager_typedef:get_method("onQuestReturn"), function(args)
	log_str = "Returned from quest..."
	showMHRUIpp = false
end, function(retval) end)
sdk.hook(StageManager_typedef:get_method("onQuestClear"), function(args)
	log_str = "Cleared quest..."
	showMHRUIpp = false
end, function(retval) end)

-- Main config window handler
local function drawMHRUIppConfigDropdown()
	if imgui.tree_node("Configure MHRUI++") then
		if imgui.button("Configure Health Bar++") then
			showHealthBarPPConfigWindow = not showHealthBarPPConfigWindow
		end
	end
end

-- Draw config drop down
re.on_draw_ui(function()
	drawMHRUIppConfigDropdown()
end)