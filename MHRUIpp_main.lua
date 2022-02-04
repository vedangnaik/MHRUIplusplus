require("MHRUIpp/helpers")
require("MHRUIpp/StaminaBarPP")
require("MHRUIpp/HealthBarPP")
require("MHRUIpp/QuestTimerPP")
require("MHRUIpp/DebuffIndicatorPP")
require("MHRUIpp/SharpnessGaugePP")

-- Put all elements in array and set them up.
local elementPPs = { StaminaBarPP, HealthBarPP, QuestTimerPP, DebuffIndicatorPP, SharpnessGaugePP }
for _, elementPP in ipairs(elementPPs) do elementPP:setup() end

-- Global variable that indicates whether MHRUIpp is being displayed or not.
local showMHRUIpp = false

-- Hook to change in Kamura Area.
sdk.hook(VillageAreaManager_typedef:get_method("callAfterAreaActivation"),
function(args)
	if isInTrainingArea() then
		showMHRUIpp = true
	else
		showMHRUIpp = false
	end
end, function(retval) end)

-- Hook into quest start.
sdk.hook(StageManager_typedef:get_method("onQuestStart"), function(args)
	showMHRUIpp = true
end, function(retval) end)

-- Hook into quest end/return/clear/etc.
sdk.hook(QuestManager_typedef:get_method("onQuestEnd"), function(args)
	showMHRUIpp = false
end, function(retval) end)
sdk.hook(QuestManager_typedef:get_method("onQuestReturn"), function(args)
	showMHRUIpp = false
end, function(retval) end)
sdk.hook(StageManager_typedef:get_method("onQuestClear"), function(args)
	showMHRUIpp = false
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
	end
end)

-- Draw each element on each frame.
re.on_frame(function()
    if showMHRUIpp then closeUI() end
    for _, elementPP in ipairs(elementPPs) do
        if showMHRUIpp and elementPP:isVisible() then elementPP:draw() end
        if elementPP:isConfigWindowVisible() then 
            if not elementPP:drawConfigWindow() then
                elementPP:save()
            end
        end
    end
end)