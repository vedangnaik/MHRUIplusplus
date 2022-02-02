require("MHRUIpp/helpers")
require("MHRUIpp/ElementPPBase")

-- This is a superclass of the ElementPPBase class
DebuffIndicatorPP = ElementPPBase:new():new("DebuffIndicator++.json", {
    x                  = 110,
    y                  = 5,
    h                  = 20,
    borderThickness    = 2,
    borderColor        = "0xAA000000",
    color              = "0xAA621EE8",
    visibleNotDebuffed = true,
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
    log_str = debuff
    if debuff ~= 0 or self.cfg.visibleNotDebuffed then
        local text = self.debuffMsgs[debuff] or "Unknown"

        local w = (string.len(text) * 7) + 10 -- TODO: Swap with monospaced font and recalculate width
        local b = self.cfg.borderThickness
        local b_offset = b << 1 -- Fast multiply by 2
        local textVerticalOffset = (self.cfg.h - 14) >> 1 -- Fast div by 2, font size is 14

        draw.filled_rect(self.cfg.x - b, self.cfg.y - b, w + b_offset, self.cfg.h + b_offset, self.cfg.borderColor)
        draw.filled_rect(self.cfg.x, self.cfg.y, w, self.cfg.h, self.cfg.color)
        draw.text(text, self.cfg.x + 5, self.cfg.y + textVerticalOffset, 0xFFFFFFFF)
    end
end

function DebuffIndicatorPP:drawConfigWindow()
    self.cfgWinVisible = imgui.begin_window("Configure Debuff Indicator++", true, 0x10120)
	if not self.cfgWinVisible then
        if self.cfgChanged then
            if not json.dump_file(self.cfgFilepath, self.cfg) then
                self.cfg = self.defaults
                json.dump_file(self.cfgFilepath, self.cfg)
            end
        end
        self.cfgChanged = false
		return
	end
    
    local changed = false;
    changed, self.cfg.visible = imgui.checkbox("Show?", self.cfg.visible)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.visibleNotDebuffed = imgui.checkbox("Show when not debuffed?", self.cfg.visibleNotDebuffed)
    self.cfgChanged = self.cfgChanged or changed
    imgui.new_line()

    changed, self.cfg.x = imgui.drag_int("X position", self.cfg.x, 2, 0, 10000)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.y = imgui.drag_int("Y position", self.cfg.y, 2, 0, 10000)
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