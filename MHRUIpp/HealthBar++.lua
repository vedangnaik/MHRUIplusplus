require("MHRUIpp/interfaces")

return {
    new = function(self)
        -- Usual constructor stuff
        o = {}
        setmetatable(self, {__index = IPersistantConfigurableViewableWidget})
        self.__index = self
        setmetatable(o, self)
        o.cfgFilepath = o.cfgFilepath .. "HealthBar++.json"
        o.defaults = mergeTables({o.defaults, {
            x                  = 5,
            y                  = 30,
            w                  = 350,
            borderWidth        = 2,
            borderColor        = "0xAA000000",
            currentHPColor     = "0xAA228B22",
            recoverableHPColor = "0xAA534BD5",
            textColor          = "0xFFFFFFFF",
        }})
        o:loadCfg()
        o:loadFont()
        -- Set up fields for HP. Init to default max.
        self.maxHP = 100
        self.currentHP = 100
        self.recoverableHP = 100
        -- Then set up our hook into PlayerBase to get all unencrypted HP values.
        sdk.hook(PlayerBase_typedef:get_method("update"),
            function(args)
                local playerData = getPlayer():call("get_PlayerData")
                self.maxHP = playerData:get_field("_vitalMax")
                self.recoverableHP = playerData:get_field("_r_Vital")
                self.currentHP = playerData:call("get__vital")
            end,
            function(retval) end
        )
        return o
    end,

    draw = function(self)
        local h = self.cfg.fontSize + (textVertOffset << 1)
        local borderOffset = self.cfg.borderWidth << 1
        -- Scaled width of entire gauge.
        local gaugeWidth = self.cfg.w * (self.maxHP / 100)
        local recoverableHPWidth = gaugeWidth * (self.recoverableHP / self.maxHP)
        local currentHPWidth = gaugeWidth * (self.currentHP / self.maxHP)

        imgui.push_font(self.font)
        draw.filled_rect(self.cfg.x - self.cfg.borderWidth, self.cfg.y - self.cfg.borderWidth, gaugeWidth + borderOffset, h + borderOffset, self.cfg.borderColor)
        draw.filled_rect(self.cfg.x, self.cfg.y, recoverableHPWidth, h, self.cfg.recoverableHPColor)
        draw.filled_rect(self.cfg.x, self.cfg.y, currentHPWidth, h, self.cfg.currentHPColor)
        draw.text(
            string.format("Health: %d/%d", self.currentHP, self.maxHP),
            self.cfg.x + textHorizOffset, self.cfg.y + textVertOffset, self.cfg.textColor
        )
        imgui.pop_font()
    end,

    drawConfigWindow = function(self)
        self.cfgWinVisible = imgui.begin_window("Configure Health Bar++", true, 0x10120)
        if not self.cfgWinVisible then return false end

        local changed = false;
        changed, self.cfg.visible = imgui.checkbox("Show?", self.cfg.visible)
        self.cfgChanged = self.cfgChanged or changed
        imgui.text("Toggle Key: " .. tempToggleKey)
        imgui.text("Configurable toggle keys coming soon!")
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
}