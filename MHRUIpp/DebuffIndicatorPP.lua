require("MHRUIpp/interfaces")

return {
    new = function(self)
        o = {}
        setmetatable(self, {__index = IPersistantConfigurableViewableWidget})
        self.__index = self
        setmetatable(o, self)
        o.cfgFilepath = o.cfgFilepath .. "DebuffIndicator++.json"
        o.defaults = mergeTables({o.defaults, {
            x                  = 80,
            y                  = 80,
            borderWidth        = 2,
            borderColor        = "0xAA000000",
            bgColor            = "0xAA621EE8",
            textColor          = "0xFFFFFFFF",
            visibleNotDebuffed = false,
        }})
        o:loadCfg()
        o:loadFont()
        return o
    end,

    draw = function(self)
        local debuff = getPlayer():call("get_PlayerData"):get_field("_condition"):call("get_DebuffCondition")
        local activeBuffs = {}

        for k, v in pairs(self.debuffMsgs) do
            if debuff & k > 0 then table.insert(activeBuffs, v) end
        end
        local text = table.concat(activeBuffs, " + ")
        if text == "" then text = "No Debuff :)" end

        if debuff ~= 0 or self.cfg.visibleNotDebuffed then
            local w = (string.len(text) * self.cfg.fontSize * fontAspectRatio) + (textHorizOffset << 1)
            local h = self.cfg.fontSize + (textVertOffset << 1)
            local borderOffset = self.cfg.borderWidth << 1

            imgui.push_font(self.font)
            draw.filled_rect(self.cfg.x - self.cfg.borderWidth, self.cfg.y - self.cfg.borderWidth, w + borderOffset, h + borderOffset, self.cfg.borderColor)
            draw.filled_rect(self.cfg.x, self.cfg.y, w, h, self.cfg.bgColor)
            draw.text(text, self.cfg.x + textHorizOffset, self.cfg.y + textVertOffset, self.cfg.textColor)
            imgui.pop_font()
        end
    end,

    drawConfigWindow = function(self)
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
    end,

    debuffMsgs = {
        [0]                         = "No Debuff!",
        [Debuffs.FireL]             = "FireBlight!",
        [Debuffs.WaterL]            = "Waterblight!",
        [Debuffs.ThunderL]          = "Thunderblight!",
        [Debuffs.IceL]              = "Iceblight!",
        [Debuffs.DragonL]           = "Dragonblight!",
        [Debuffs.AllResDownS]       = "Resistance Down!",
        [Debuffs.AllResDownL]       = "Resistance Down!",
        [Debuffs.Bubble]            = "Bubble!",
        [Debuffs.RedBubble]         = "Bubble!",
        [Debuffs.GreenBubble]       = "Bubble!",
        [Debuffs.MagmaSlip]         = "Magma!",
        [Debuffs.Poison]            = "Poisoned!",
        [Debuffs.NoxiousPoison]     = "Poisoned!",
        [Debuffs.DeadlyPoison]      = "Poisoned!",
        [Debuffs.Sleep]             = "Sleepy!",
        [Debuffs.Paralyze]          = "Paralyzed!",
        [Debuffs.Stun]              = "Stunned!",
        [Debuffs.Stink]             = "Stinky!",
        [Debuffs.BubbleDaruma]      = "Bubble!",
        [Debuffs.RedBubbleDaruma]   = "Bubble!",
        [Debuffs.GreenBubbleDaruma] = "Bubble!",
        [Debuffs.Blooding]          = "Bleeding!",
        [Debuffs.Bleeding]          = "Bleeding!",
        [Debuffs.Confusion]         = "Confused!",
        [Debuffs.DefenceDownS]      = "Defence Down!",
        [Debuffs.DefenceDownL]      = "Defence Down!",
    }
}