require("MHRUIpp/helpers")

-- Put all elements in array and set them up.
StockUIHandler = require("MHRUIpp/StockUIHandler"):new()
StaminaBarPP = require("MHRUIpp/StaminaBarPP"):new()
HealthBarPP = require("MHRUIpp/HealthBarPP"):new()
QuestTimerPP = require("MHRUIpp/QuestTimerPP"):new()
DebuffIndicatorPP = require("MHRUIpp/DebuffIndicatorPP"):new()
SharpnessGaugePP = require("MHRUIpp/SharpnessGaugePP"):new()
local widgets = { StaminaBarPP, HealthBarPP, QuestTimerPP, DebuffIndicatorPP, SharpnessGaugePP }

-- Variable that indicates whether a UI is being displayed or not.
local showUI = true

-- Hook to change in Kamura Area.
sdk.hook(VillageAreaManager_typedef:get_method("callAfterAreaActivation"),
function(args)
	if isInTrainingArea() then
		showUI = true
	else
		showUI = false
	end
end, function(retval) end)

-- Hook into quest start.
sdk.hook(StageManager_typedef:get_method("onQuestStart"), function(args)
	showUI = false
end, function(retval) end)

-- Hook into quest end/return/clear/etc.
sdk.hook(QuestManager_typedef:get_method("onQuestEnd"), function(args)
	showUI = false
end, function(retval) end)
sdk.hook(QuestManager_typedef:get_method("onQuestReturn"), function(args)
	showUI = false
end, function(retval) end)
sdk.hook(StageManager_typedef:get_method("onQuestClear"), function(args)
	showUI = false
end, function(retval) end)

-- Main config window handler.
re.on_draw_ui(function()
	if imgui.tree_node("Configure MHRUI++") then
		if imgui.button("Configure Health Bar++") then
			HealthBarPP:toggleConfigWindowVisibility()
		end
        if imgui.button("Configure Stamina Bar++") then
			StaminaBarPP:toggleConfigWindowVisibility()
		end
        if imgui.button("Configure Quest Timer++") then
			QuestTimerPP:toggleConfigWindowVisibility()
		end
        if imgui.button("Configure Debuff Indicator++") then
			DebuffIndicatorPP:toggleConfigWindowVisibility()
		end
        if imgui.button("Configure Sharpness Gauge++") then
			SharpnessGaugePP:toggleConfigWindowVisibility()
		end
        imgui.new_line()
        if imgui.button("Configure Stock UI") then
			StockUIHandler:toggleConfigWindowVisibility()
		end
	end
end)

re.on_frame(function()
    for _, widget in ipairs(widgets) do
        if showUI and widget:isVisible() then widget:draw() end
        if widget:isConfigWindowVisible() then 
            if not widget:drawConfigWindow() then
                widget:saveCfg()
                widget:loadFont()
            end
        end
    end
end)