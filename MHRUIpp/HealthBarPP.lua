require("MHRUIpp/helpers")

showHealthBarPPConfigWindow = false

function drawHealthBarPP()
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