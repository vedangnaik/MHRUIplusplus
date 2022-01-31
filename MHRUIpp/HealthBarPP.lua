require("MHRUIpp/helpers")

-- Global
showHealthBarPPConfigWindow = false

-- Load local profile
local config = {}
(function()
    config = json.load_file(fs.glob([[MHRUIpp_Profiles\\health_bar_pp.json]])[1])
    if config ~= nil then
        log.info("[MHRUIpp] Health Bar config loaded.")
    else
        log.error("[MHRUIpp] Health Bar config not found, using default values.")
        -- TODO
    end
end)()

function drawHealthBarPP()
    local playerData = getPlayer():call("get_PlayerData")
    local currentHP = playerData:get_field("_r_Vital")
    local maxHP = playerData:get_field("_vitalMax")
    drawGauge(
        config["x"], config["y"], config["w"], config["h"],
        config["borderThickness"],
        config["gaugeColor"], config["barColor"],
        currentHP / maxHP,
        string.format("Health: %d/%d", currentHP, maxHP)
    )
end

function drawHealthBarPPConfigWindow()
    showHealthBarPPConfigWindow = imgui.begin_window("Configure MHRUI++ Health Bar", true, 0x10120)
	if not showHealthBarPPConfigWindow then
		return
	end



	imgui.end_window()
end

re.on_frame(function()
	if showMHRUIpp then
		drawHealthBarPP()
	end

    if showHealthBarPPConfigWindow then
        drawHealthBarPPConfigWindow()
    end
end)