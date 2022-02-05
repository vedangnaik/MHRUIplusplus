require("MHRUIpp/ElementPPBase")

StockUIHandler = ElementPPBase:new():new("StockUIHandler.json", {
    showHUD = false,
    showBuddyHUD = false,
    showSharpnessHUD = false,
})

function StockUIHandler:draw()
    if not GUIManager then GUIManager = sdk.get_managed_singleton("snow.gui.GuiManager") end
    if self.cfg.showHUD then GUIManager:call("openHud") else GUIManager:call("closeHud") end
    if self.cfg.showBuddyHUD then GUIManager:call("openPartHud") else GUIManager:call("closePartHud") end
    if self.cfg.showSharpnessHUD then GUIManager:call("openHudSharpness") else GUIManager:call("closeHudSharpness") end
end

function StockUIHandler:drawConfigWindow()
    self.cfgWinVisible = imgui.begin_window("Configure Stock UI", true, 0x10120)
	if not self.cfgWinVisible then return false end
    
    local changed = false;
    changed, self.cfg.showHUD = imgui.checkbox("Show Health/Stamina Bars?", self.cfg.showHUD)
    self.cfgChanged = self.cfgChanged or changed

    imgui.text("Note: Buddy Health cannot be displayed")
    imgui.text("without Player Health/Stamina.")
    changed, self.cfg.showBuddyHUD = imgui.checkbox("Show Buddy Health?", self.cfg.showBuddyHUD)
    self.cfgChanged = self.cfgChanged or changed
    -- Force the full HUD on if the Buddy HUD is displayed.
    if self.cfg.showBuddyHUD then self.cfg.showHUD = true end
    
    changed, self.cfg.showSharpnessHUD = imgui.checkbox("Show Sharpness Gauge?", self.cfg.showSharpnessHUD)
    self.cfgChanged = self.cfgChanged or changed
    imgui.new_line()
    
    if imgui.button("Reset Defaults") then
        self:restoreDefaults()
        self.cfgChanged = true
    end

	imgui.end_window()

    return true
end