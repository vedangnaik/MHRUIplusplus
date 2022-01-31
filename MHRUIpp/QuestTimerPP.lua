require("MHRUIpp/helpers")

-- Global
showQuestTimerPPConfigWindow = false

-- Default values for Health Bar++
local function initDefaults()
    local c = {}
    c["x"] = 5
    c["y"] = 5
    c["w"] = 40
    c["h"] = 45
    c["borderThickness"] = 2
    c["gaugeColor"] = "0xAA000000"
    c["barColor"] = "0xAAFFC5EE"
    return c
end

-- Load local profile
local config_file_name = "MHRUIpp_Profiles\\QuestTimerPP.json"
local config = {}
local config_changed = false
(function()
    loaded_config = json.load_file(config_file_name)
    if loaded_config == nil then
        log.error("[MHRUIpp] Quest Timer config not found, using default values.")
        config = initDefaults()
        json.dump_file(config_file_name, config)
    else
        config = loaded_config
    end
end)()

function drawQuestTimerPP()
    local timeLimit = 0
    local elapsedTimeSeconds = 0

    local questManager = sdk.get_managed_singleton("snow.QuestManager")
	local activeQuestData = questManager:call("getActiveQuestData")
	if activeQuestData then
		timeLimit = activeQuestData:call("getTimeLimit")
		elapsedTimeSeconds = questManager:call("getQuestElapsedTimeSec");

		-- log_str = string.format("Time: %02d:%02.0f/%02d m", elapsedTimeSeconds // 60, elapsedTimeSeconds % 60, timeLimit)
	end

    local b = config["borderThickness"]
    local b_offset = b << 1 -- Fast multiply by 2
    local textVerticalOffset = (config["h"] - 39) >> 1 -- Fast div by 2, font size is 14

	draw.filled_rect(config["x"] - b, config["y"] - b, config["w"] + b_offset, config["h"] + b_offset, config["gaugeColor"])
	draw.filled_rect(config["x"], config["y"], config["w"], config["h"], config["barColor"])
	draw.text(
        string.format("%02d:%02.0f\n   of\n%02d:00", elapsedTimeSeconds // 60, elapsedTimeSeconds % 60, timeLimit), 
        config["x"] + 5, config["y"] + textVerticalOffset, 0xFFFFFFFF
    )
end

local function drawQuestTimerPPConfigWindow()
    showQuestTimerPPConfigWindow = imgui.begin_window("Configure MHRUI++ Stamina Bar", true, 0x10120)
	if not showQuestTimerPPConfigWindow then
        if config_changed then
            if not json.dump_file(config_file_name, config) then
                log.error("[MHRUIpp] Quest Timer config failed, saving default values.")
                config = initDefaults()
                json.dump_file(config_file_name, config)
            end
        end
        config_changed = false
		return
	end
    
    local changed = false;
    changed, config["x"] = imgui.drag_int("X coord", config["x"], 2, 0, 10000)
    config_changed = config_changed or changed
    changed, config["y"] = imgui.drag_int("Y coord", config["y"], 2, 0, 10000)
    config_changed = config_changed or changed
    changed, config["w"] = imgui.drag_int("Width", config["w"], 2, 0, 10000)
    config_changed = config_changed or changed
    changed, config["h"] = imgui.drag_int("Height", config["h"], 2, 0, 10000)
    config_changed = config_changed or changed
    changed, config["borderThickness"] = imgui.drag_int("Border", config["borderThickness"], 1, 0, 50)
    config_changed = config_changed or changed
    -- TODO: Add color picker
    imgui.text("Color pickers coming soon!")
    imgui.new_line()
    
    if imgui.button("Reset Defaults") then
        config = initDefaults()
        config_changed = true
    end

	imgui.end_window()
end

re.on_frame(function()
	if showMHRUIpp then
		drawQuestTimerPP()
	end

    if showQuestTimerPPConfigWindow then
        drawQuestTimerPPConfigWindow()
    end
end)