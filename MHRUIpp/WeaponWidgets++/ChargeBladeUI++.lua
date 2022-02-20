require("MHRUIpp/interfaces")

return {
    new = function(self)
        o = {}
        setmetatable(self, {__index = IPersistantConfigurableViewableWidget})
        self.__index = self
        setmetatable(o, self)
        o.cfgFilepath = o.cfgFilepath .. "ChargeBladeUI++.json"
        o.defaults = mergeTables({o.defaults, {
            vialX       = 500,
            vialY       = 500,
            borderWidth = 2,
            textColor   = "0xFFFFFFFF"
        }})
        o:loadCfg()
        o:loadFont()
        return o
    end,

    draw = function(self)
        local CBData = getCurrentWeaponInstanceIfIs("ChargeAxe");
        if not CBData then return end
        -- Gather all required CB stats.
        local numVials        = CBData:call("getBottleNumMax")
        local numFilledVials  = CBData:call("get_ChargedBottleNum")
        local gaugeState      = CBData:call("get_ChargeGaugeState") -- 0 = empty, 1 = half, 2 = full, 3 = overheat
        local ShieldBuffTimer = CBData:get_field("_ShieldBuffTimer")
        local SwordBuffTimer  = CBData:get_field("_SwordBuffTimer")
        local isSwordBuffed   = CBData:call("isSwordBuff")
        local isShieldBuffed  = CBData:call("isShieldBuff")

        log_str = "here"

        -- Draw vials and sword state gauge.
        local text = string.format("%d/%d", numFilledVials, numVials)
        local w = (string.len(text) * self.cfg.fontSize * fontAspectRatio) + (textHorizOffset << 1)
        local h = self.cfg.fontSize + (textVertOffset << 1)

        imgui.push_font(self.font)
        draw.filled_rect(self.cfg.vialX - self.cfg.borderWidth, self.cfg.vialY - self.cfg.borderWidth, w + borderOffset, h + borderOffset, self.gaugeStateColors[gaugeState])
        -- draw.filled_rect(self.cfg.x, self.cfg.y, w, h, self.cfg.bgColor)
        -- draw.text(text, self.cfg.x + textHorizOffset, self.cfg.y + textVertOffset, self.cfg.textColor)
        imgui.pop_font()
    end,

    drawConfigWindow = function(self)
        -- self.cfgWinVisible = imgui.begin_window("Configure Buff Indicator++", true, 0x10120)
        -- if not self.cfgWinVisible then return false end

        -- local changed = false;
        -- changed, self.cfg.visible = imgui.checkbox("Show?", self.cfg.visible)
        -- self.cfgChanged = self.cfgChanged or changed
        -- changed, self.cfg.visibleNotDebuffed = imgui.checkbox("Show when not debuffed?", self.cfg.visibleNotDebuffed)
        -- self.cfgChanged = self.cfgChanged or changed
        -- imgui.new_line()

        -- changed, self.cfg.fontSize = imgui.drag_int("Font Size", self.cfg.fontSize, 1, 2, 50)
        -- self.cfgChanged = self.cfgChanged or changed
        -- changed, self.cfg.x = imgui.drag_int("X position", self.cfg.x, 2, 0, 10000)
        -- self.cfgChanged = self.cfgChanged or changed
        -- changed, self.cfg.y = imgui.drag_int("Y position", self.cfg.y, 2, 0, 10000)
        -- self.cfgChanged = self.cfgChanged or changed
        -- changed, self.cfg.borderWidth = imgui.drag_int("Border", self.cfg.borderWidth, 1, 0, 50)
        -- self.cfgChanged = self.cfgChanged or changed
        -- imgui.text("Color pickers coming soon!")
        -- imgui.new_line()

        -- if imgui.button("Reset Defaults") then
        --     self:restoreDefaults()
        --     self.cfgChanged = true
        -- end

        -- imgui.end_window()

        return true
    end,

    gaugeStateColors = {
        [0] = "0xAA000000",
        [1] = "0xAA04B3D0",
        [2] = "0xAA4545D0",
        [3] = "0xAA6060FF"
    }
}