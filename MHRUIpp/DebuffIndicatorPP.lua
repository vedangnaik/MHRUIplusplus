require("MHRUIpp/ElementPPBase")

-- This is a superclass of the ElementPPBase class
DebuffIndicatorPP = ElementPPBase:new():new("DebuffIndicator++.json", {
    x                  = 115,
    y                  = 5,
    borderWidth        = 2,
    borderColor        = "0xAA000000",
    bgColor            = "0xAA621EE8",
    textColor          = "0xFFFFFFFF",
    visibleNotDebuffed = false,
})

DebuffIndicatorPP.debuffMsgs = {
    [0]                     = "No Debuff!",
    [Debuffs.FireL]         = "FireBlight!",
    [Debuffs.WaterL]        = "Waterblight!",
    [Debuffs.ThunderL]      = "Thunderblight!",
    [Debuffs.IceL]          = "Iceblight!",
    [Debuffs.DragonL]       = "Dragonblight!",
    [Debuffs.MagmaSlip]     = "Magma!",
    [Debuffs.Poison]        = "Poisoned!",
    [Debuffs.NoxiousPoison] = "Poisoned!",
    [Debuffs.DeadlyPoison]  = "Poisoned!",
    [Debuffs.Sleep]         = "Sleepy!",
    [Debuffs.Paralyze]      = "Paralyzed!",
    [Debuffs.Stun]          = "Stunned!",
    [Debuffs.AllResDownS]   = "Resistance Down!",
    [Debuffs.AllResDownL]   = "Resistance Down!",
    [Debuffs.DefenceDownS]  = "Defence Down!",
    [Debuffs.DefenceDownL]  = "Defence Down!",
}

function DebuffIndicatorPP:draw()
    local debuff = getPlayer():call("get_PlayerData"):get_field("_condition"):call("get_DebuffCondition")
    if debuff ~= 0 or self.cfg.visibleNotDebuffed then
        local text = self.debuffMsgs[debuff] or "Unknown"
        local w = (string.len(text) * self.cfg.fontSize >> 1) + (textHorizOffset << 1)
        local h = self.cfg.fontSize + (textVertOffset << 1)
        local borderOffset = self.cfg.borderWidth << 1

        imgui.push_font(self.font)
        draw.filled_rect(self.cfg.x - self.cfg.borderWidth, self.cfg.y - self.cfg.borderWidth, w + borderOffset, h + borderOffset, self.cfg.borderColor)
        draw.filled_rect(self.cfg.x, self.cfg.y, w, h, self.cfg.bgColor)
        draw.text(text, self.cfg.x + textHorizOffset, self.cfg.y + textVertOffset, self.cfg.textColor)
        imgui.pop_font()
    end
end

function DebuffIndicatorPP:drawConfigWindow()
    self.cfgWinVisible = imgui.begin_window("Configure Debuff Indicator++", true, 0x10120)
	if not self.cfgWinVisible then return false end
    
    local changed = false;
    changed, self.cfg.visible = imgui.checkbox("Show?", self.cfg.visible)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.visibleNotDebuffed = imgui.checkbox("Show when not debuffed?", self.cfg.visibleNotDebuffed)
    self.cfgChanged = self.cfgChanged or changed
    imgui.new_line()

    changed, self.cfg.fontSize = imgui.drag_int("Font Size", self.cfg.fontSize, 1, 2, 50)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.x = imgui.drag_int("X position", self.cfg.x, 2, 0, 10000)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.y = imgui.drag_int("Y position", self.cfg.y, 2, 0, 10000)
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