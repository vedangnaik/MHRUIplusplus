require("MHRUIpp/helpers")

-- Put all elements in array and set them up.
StockUIHandler = require("MHRUIpp/StockUIHandler"):new()
StaminaBarPP = require("MHRUIpp/StaminaBarPP"):new()
HealthBarPP = require("MHRUIpp/HealthBarPP"):new()
QuestTimerPP = require("MHRUIpp/QuestTimerPP"):new()
DebuffIndicatorPP = require("MHRUIpp/DebuffIndicatorPP"):new()
BuffIndicatorPP = require("MHRUIpp/BuffIndicatorPP"):new()
SharpnessGaugePP = require("MHRUIpp/SharpnessGaugePP"):new()
MonsterHPBar = require("MHRUIpp/MonsterHPBar"):new()
-- Group widgets based on what interfaces they implement.
local viewableWidgets = { StaminaBarPP, HealthBarPP, QuestTimerPP, DebuffIndicatorPP, BuffIndicatorPP, SharpnessGaugePP, MonsterHPBar } -- Those with a Show button
local persistantConfigurableWidgets = { StaminaBarPP, HealthBarPP, QuestTimerPP, DebuffIndicatorPP, BuffIndicatorPP, SharpnessGaugePP, StockUIHandler, MonsterHPBar } -- Those with profiles that need to be saved
local nonViewableWidgets = { StockUIHandler } -- Those without a Show button

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
	showUI = true
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
        if imgui.button("Configure Buff Indicator++") then
			BuffIndicatorPP:toggleConfigWindowVisibility()
		end
        if imgui.button("Configure Sharpness Gauge++") then
			SharpnessGaugePP:toggleConfigWindowVisibility()
		end
        if imgui.button("Configure Monster HP Bar") then
			MonsterHPBar:toggleConfigWindowVisibility()
		end
        imgui.new_line()
        if imgui.button("Configure Stock UI") then
			StockUIHandler:toggleConfigWindowVisibility()
		end
	end
end)

re.on_frame(function()
    for _, widget in ipairs(viewableWidgets) do
        if showUI and widget:isVisible() then widget:draw() end
    end

    for _, widget in ipairs(nonViewableWidgets) do
        if showUI then widget:draw() end
    end

    for _, widget in ipairs(persistantConfigurableWidgets) do
        if widget:isConfigWindowVisible() then 
            if not widget:drawConfigWindow() then
                widget:saveCfg()
                widget:loadFont()
            end
        end
    end
end)