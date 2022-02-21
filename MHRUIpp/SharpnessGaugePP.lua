require("MHRUIpp/interfaces")

return {
    new = function(self)
        o = {}
        setmetatable(self, {__index = IPersistantConfigurableViewableWidget})
        self.__index = self
        setmetatable(o, self)
        o.cfgFilepath = o.cfgFilepath .. "SharpnessGauge++.json"
        o.defaults = mergeTables({o.defaults, {
            x           = 5,
            y           = 80,
            w           = 70,
            borderWidth = 2,
            borderColor = "0xAA000000",
            textColor   = "0xFFFFFFFF",
        }})
        o:loadCfg()
        o:loadFont()
        return o
    end,

    draw = function(self)
        local _, weaponName = getCurrentWeaponInstanceAndName()
        if weaponName == "Bow" or weaponName == "LightBowgun" or weaponName == "HeavyBowgun" then return end
        local playerBase = getPlayer()

        -- Get raw values.
        local currentSharpness = playerBase:call("get_SharpnessGauge")
        local maxSharpness = playerBase:call("get_SharpnessGaugeMax")
        -- Compensate for handicraft.
        local handicraftLevel = 0
        for level = 3, 1, -1 do
            if playerBase:call("get_PlayerSkillList"):call("hasSkill", self.handicraftId, level) then
                handicraftLevel = level
                break
            end
        end
        -- If max sharpness is 400, then handicraft doesn't add any more. Compensate for that.
        -- TODO: see how max sharpness in the 371-399 range behave with handicraft: e.g. does lv 1 add +5 sharpness to 395?
        local handicraftSharpness = math.min(handicraftLevel * 10, 400 - maxSharpness)
        -- Get levels for color.
        local currentLv = playerBase:call("get_SharpnessLv")
        local currentLvGaugeLength = playerBase:call("getSharpnessLvLength", currentLv) + handicraftSharpness
        local maxLv = playerBase:call("getSharpnessLvToGauge", maxSharpness)
        -- Get lower bound for current level.
        for level = maxLv, currentLv, -1 do
            maxSharpness = maxSharpness - playerBase:call("getSharpnessLvLength", level) - handicraftSharpness
        end
        -- Get current and max sharpness w.r.t. this level.
        currentSharpness = currentSharpness - maxSharpness
        maxSharpness = currentLvGaugeLength

        local h = self.cfg.fontSize + (textVertOffset << 1)
        local borderOffset = self.cfg.borderWidth << 1

        imgui.push_font(self.font)
        draw.filled_rect(self.cfg.x - self.cfg.borderWidth, self.cfg.y - self.cfg.borderWidth, self.cfg.w + borderOffset, h + borderOffset, self.cfg.borderColor)
        draw.filled_rect(self.cfg.x, self.cfg.y, self.cfg.w * (currentSharpness / maxSharpness), h, self.sharpnessColors[currentLv])
        draw.text(
            string.format("%d/%d", currentSharpness, maxSharpness),
            self.cfg.x + textHorizOffset, self.cfg.y + textVertOffset, 0xFFFFFFFF
        )
        imgui.pop_font()
    end,

    drawConfigWindow = function(self)
        self.cfgWinVisible = imgui.begin_window("Configure Sharpness Gauge++", true, 0x10120)
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
    end,

    sharpnessColors = {
        [0] = "0xAA2C2CC9",
        [1] = "0xAA2C66C9",
        [2] = "0xAA2CD1C9",
        [3] = "0xAA2CD970",
        [4] = "0xAAD9862C",
        [5] = "0xAAFFFFFF",
    },

    handicraftId = 22
}