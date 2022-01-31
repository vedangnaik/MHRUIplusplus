function closeUI()
    local guiManager = sdk.get_managed_singleton("snow.gui.GuiManager")
    guiManager:call("closeHud") -- Disable Health bar, stamina bar, quest timer, etc.
    guiManager:call("closePartHud") -- Disable Palico and Palamute health
    guiManager:call("closeHudSharpness") -- Disable sharpness gauge
    -- guiManager:call("openWeaponUI") -- Weapon-specific UI e.g. Charge Blade phials
    -- guiManager:call("setInvisibleAllGUI", false) -- Turn off 'all' GUI, too powerful i.e. removes map, pause window, everything
    -- guiManager:call("closeAllQuestHudUI") -- Potentially useful, turns of all HUD i.e. items, everything
end

re.on_frame(function()
	if showMHRUIpp then
		closeUI()
	end
end)