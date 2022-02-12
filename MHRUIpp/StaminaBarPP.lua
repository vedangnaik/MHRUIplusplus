require("MHRUIpp/interfaces")

return {
    new = function(self)
        o = {}
        setmetatable(self, {__index = IPersistantConfigurableViewableWidget})
        self.__index = self
        setmetatable(o, self)
        o.cfgFilepath = o.cfgFilepath .. "StaminaBar++.json"
        o.defaults = mergeTables({o.defaults, {
            x           = 5,
            y           = 55,
            w           = 350,
            borderWidth = 2,
            borderColor = "0xAA000000",
            gaugeColor  = "0xAA23C5EE",
            textColor   = "0xFFFFFFFF"
        }})
        o:loadCfg()
        o:loadFont()
        return o
    end,

    draw = function(self)
        local playerData = getPlayer():call("get_PlayerData")
        local currentStamina = playerData:get_field("_stamina")
        local maxStamina = playerData:get_field("_staminaMax")
        local secondsUntilStaminaDown = math.floor(playerData:get_field("_staminaMaxDownIntervalTimer") * staminaUnitsToSeconds)

        local h = self.cfg.fontSize + (textVertOffset << 1)
        local borderOffset = self.cfg.borderWidth << 1
        local scaled_width = self.cfg.w * (maxStamina / 3000)

        imgui.push_font(self.font)
        draw.filled_rect(self.cfg.x - self.cfg.borderWidth, self.cfg.y - self.cfg.borderWidth, scaled_width + borderOffset, h + borderOffset, self.cfg.borderColor)
        draw.filled_rect(self.cfg.x, self.cfg.y, scaled_width * currentStamina / maxStamina, h, self.cfg.gaugeColor)
        draw.text(
            string.format("Stamina: %.0f/%.0f for %02d:%02d", currentStamina, maxStamina, secondsUntilStaminaDown // 60, secondsUntilStaminaDown % 60),
            self.cfg.x + textHorizOffset, self.cfg.y + textVertOffset, 0xFFFFFFFF
        )
        imgui.pop_font()
    end,

    drawConfigWindow = function(self)
        self.cfgWinVisible = imgui.begin_window("Configure Stamina Bar++", true, 0x10120)
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