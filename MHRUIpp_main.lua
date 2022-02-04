require("MHRUIpp/helpers")
require("MHRUIpp/StaminaBarPP")
require("MHRUIpp/HealthBarPP")
require("MHRUIpp/QuestTimerPP")
require("MHRUIpp/DebuffIndicatorPP")
require("MHRUIpp/SharpnessGaugePP")
require("MHRUIpp/StockUIHandler")

-- Put all elements in array and set them up.
local elementPPs = { StaminaBarPP, HealthBarPP, QuestTimerPP, DebuffIndicatorPP, SharpnessGaugePP, StockUIHandler }
for _, elementPP in ipairs(elementPPs) do elementPP:setup() end

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
    for _, elementPP in ipairs(elementPPs) do
        if showUI and elementPP:isVisible() then elementPP:draw() end
        if elementPP:isConfigWindowVisible() then 
            if not elementPP:drawConfigWindow() then
                elementPP:save()
            end
        end
    end
end)