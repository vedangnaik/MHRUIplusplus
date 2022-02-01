require("MHRUIpp/helpers")

-- Global
showHealthBarPPConfigWindow = false

-- Default values for Health Bar++
local function initDefaults()
    local c = {}
    c["x"] = 50
    c["y"] = 5
    c["w"] = 300
    c["h"] = 20
    c["borderThickness"] = 2
    c["gaugeColor"] = "0xAA000000"
    c["barColor"] = "0xAA228B22"
    c["show"] = true
    return c
end

-- Load local profile
local config_file_name = "MHRUIpp_Profiles\\HealthBar++.json"
local config = {}
local config_changed = false
(function()
    loaded_config = json.load_file(config_file_name)
    if loaded_config == nil then
        log.error("[MHRUIpp] Health Bar++ config not found, using default values.")
        config = initDefaults()
        json.dump_file(config_file_name, config)
    else
        config = loaded_config
    end
end)()

function drawHealthBarPP()
    local playerData = getPlayer():call("get_PlayerData")
    local currentHP = playerData:get_field("_r_Vital")
    local maxHP = playerData:get_field("_vitalMax")

    local b = config["borderThickness"]
    local b_offset = b << 1 -- Fast multiply by 2
    local textVerticalOffset = (config["h"] - 14) >> 1 -- Fast div by 2, font size is 14
    local scaled_width = config["w"] * (maxHP / 100)

	draw.filled_rect(config["x"] - b, config["y"] - b, scaled_width + b_offset, config["h"] + b_offset, config["gaugeColor"])
	draw.filled_rect(config["x"], config["y"], scaled_width * currentHP / maxHP, config["h"], config["barColor"])
	draw.text(
        string.format("Health: %d/%d", currentHP, maxHP), 
        config["x"] + 5, config["y"] + textVerticalOffset, 0xFFFFFFFF
    )
end

local function drawHealthBarPPConfigWindow()
    showHealthBarPPConfigWindow = imgui.begin_window("Configure Health Bar++", true, 0x10120)
	if not showHealthBarPPConfigWindow then
        if config_changed then
            if not json.dump_file(config_file_name, config) then
                log.error("[MHRUIpp] Health Bar++ config failed, saving default values.")
                config = initDefaults()
                json.dump_file(config_file_name, config)
            end
        end
        config_changed = false
		return
	end
    
    local changed = false;
    changed, config["show"] = imgui.checkbox("Show?", config["show"])
    config_changed = config_changed or changed
    imgui.new_line()
    
    changed, config["x"] = imgui.drag_int("X position", config["x"], 2, 0, 10000)
    config_changed = config_changed or changed
    changed, config["y"] = imgui.drag_int("Y position", config["y"], 2, 0, 10000)
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
	if showMHRUIpp and config["show"] then
		drawHealthBarPP()
	end

    if showHealthBarPPConfigWindow then
        drawHealthBarPPConfigWindow()
    end
end)