require("MHRUIpp/helpers")
require("MHRUIpp/ElementPPBase")

-- This is a superclass of the ElementPPBase class
HealthBarPP = ElementPPBase:new():new("HealthBar++.json", {
    x           = 5,
    y           = 30,
    w           = 300,
    borderWidth = 2,
    borderColor = "0xAA000000",
    barColor    = "0xAA228B22",
    textColor   = "0xFFFFFFFF"
})

function HealthBarPP:draw()
    local playerData = getPlayer():call("get_PlayerData")
    local currentHP = playerData:get_field("_r_Vital")
    local maxHP = playerData:get_field("_vitalMax")

    local h = self.cfg.fontSize + (textVertOffset << 1) 
    local b_offset = self.cfg.borderWidth << 1
    local scaled_width = self.cfg.w * (maxHP / 100)

    imgui.push_font(self.font)
	draw.filled_rect(self.cfg.x - self.cfg.borderWidth, self.cfg.y - self.cfg.borderWidth, scaled_width + b_offset, h + b_offset, self.cfg.borderColor)
	draw.filled_rect(self.cfg.x, self.cfg.y, scaled_width * currentHP / maxHP, h, self.cfg.barColor)
	draw.text(
        string.format("Health: %d/%d", currentHP, maxHP), 
        self.cfg.x + textHorizOffset, self.cfg.y + textVertOffset, self.cfg.textColor
    )
    imgui.pop_font()
end

function HealthBarPP:drawConfigWindow()
    self.cfgWinVisible = imgui.begin_window("Configure Health Bar++", true, 0x10120)
	if not self.cfgWinVisible then return false end
    
    local changed = false;
    changed, self.cfg.visible = imgui.checkbox("Show?", self.cfg.visible)
    self.cfgChanged = self.cfgChanged or changed
    imgui.new_line()
    
    changed, self.cfg.fontSize = imgui.drag_int("Font Size", self.cfg.fontSize, 1, 2, 50)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.x = imgui.drag_int("X position", self.cfg.x, 2, 0, 10000)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.y = imgui.drag_int("Y position", self.cfg.y, 2, 0, 10000)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.w = imgui.drag_int("Width", self.cfg.w, 2, 0, 10000)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.borderWidth = imgui.drag_int("Border", self.cfg.borderWidth, 1, 0, 50)
    self.cfgChanged = self.cfgChanged or changed
    imgui.text("Color pickers coming soon!")
    imgui.new_line()
    
    if imgui.button("Reset Defaults") then
        self:restoreDefaults()
        self.cfgChanged = true
    end

	imgui.end_window()

    return true
end