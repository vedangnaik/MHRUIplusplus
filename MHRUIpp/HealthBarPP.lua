require("MHRUIpp/helpers")
require("MHRUIpp/ElementPPBase")

-- This is a superclass of the ElementPPBase class
HealthBarPP = ElementPPBase:new():new("HealthBar++.json", {
    x               = 5,
    y               = 30,
    w               = 300,
    h               = 20,
    borderThickness = 2,
    gaugeColor      = "0xAA000000",
    barColor        = "0xAA228B22"
})

function HealthBarPP:draw()
    local playerData = getPlayer():call("get_PlayerData")
    local currentHP = playerData:get_field("_r_Vital")
    local maxHP = playerData:get_field("_vitalMax")

    local b = self.cfg.borderThickness
    local b_offset = b << 1 -- Fast multiply by 2
    local textVerticalOffset = (self.cfg.h - 14) >> 1 -- Fast div by 2, font size is 14
    local scaled_width = self.cfg.w * (maxHP / 100)

	draw.filled_rect(self.cfg.x - b, self.cfg.y - b, scaled_width + b_offset, self.cfg.h + b_offset, self.cfg.gaugeColor)
	draw.filled_rect(self.cfg.x, self.cfg.y, scaled_width * currentHP / maxHP, self.cfg.h, self.cfg.barColor)
	draw.text(
        string.format("Health: %d/%d", currentHP, maxHP), 
        self.cfg.x + 5, self.cfg.y + textVerticalOffset, 0xFFFFFFFF
    )
end

function HealthBarPP:drawConfigWindow()
    self.cfgWinVisible = imgui.begin_window("Configure Health Bar++", true, 0x10120)
	if not self.cfgWinVisible then
        if self.cfgChanged then
            if not json.dump_file(self.cfgFilename, self.cfg) then
                self.cfg = self.defaults
                json.dump_file(self.cfgFilename, self.config)
            end
        end
        self.cfgChanged = false
		return
	end
    
    local changed = false;
    changed, self.cfg.visible = imgui.checkbox("Show?", self.cfg.visible)
    self.cfgChanged = self.cfgChanged or changed
    imgui.new_line()
    
    changed, self.cfg.x = imgui.drag_int("X position", self.cfg.x, 2, 0, 10000)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.y = imgui.drag_int("Y position", self.cfg.y, 2, 0, 10000)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.w = imgui.drag_int("Width", self.cfg.w, 2, 0, 10000)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.h = imgui.drag_int("Height", self.cfg.h, 2, 0, 10000)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.borderThickness = imgui.drag_int("Border", self.cfg.borderThickness, 1, 0, 50)
    self.cfgChanged = self.cfgChanged or changed
    -- TODO: Add color picker
    imgui.text("Color pickers coming soon!")
    imgui.new_line()
    
    if imgui.button("Reset Defaults") then
        self.cfg = self.defaults
        self.cfgChanged = true
    end

	imgui.end_window()
end