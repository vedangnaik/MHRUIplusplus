require("MHRUIpp/interfaces")

return {
    new = function(self)
        o = {}
        setmetatable(self, {__index = IPersistantConfigurableViewableWidget})
        self.__index = self
        setmetatable(o, self)
        o.cfgFilepath = o.cfgFilepath .. "BuffIndicator++.json"
        o.defaults = mergeTables({o.defaults, {
            x                  = 170,
            y                  = 5,
            borderWidth        = 2,
            borderColor        = "0xAA000000",
            bgColor            = "0xAA00FF48",
            textColor          = "0xFFFFFFFF",
            visibleNotDebuffed = false,
        }})
        o:loadCfg()
        o:loadFont()
        return o
    end,

    draw = function(self)
        local playerCondition = getPlayer():call("get_PlayerData"):get_field("_condition")
        -- Both of these are 32 bit integers. Each bit encodes whether a buff is active or not.
        local common = playerCondition:call("get_CommonCondition")
        local horn = playerCondition:call("get_HornMusicUpCondition")
        local activeBuffs = {}

        for k, v in pairs(self.commonBuffMsgs) do
            if common & k > 0 then table.insert(activeBuffs, v) end
        end
        for k, v in pairs(self.hornBuffMsgs) do
            if horn & k > 0 then table.insert(activeBuffs, v) end
        end
        local text = table.concat(activeBuffs, " + ")
        if text == "" then text = "No Buff :(" end

        if common ~= 0 or horn ~= 0 or self.cfg.visibleNotDebuffed then
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
        self.cfgWinVisible = imgui.begin_window("Configure Buff Indicator++", true, 0x10120)
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

    commonBuffMsgs = {
        [CommonBuffs.AttackUp]           = "Attack Up!",
        [CommonBuffs.DefenceUp]          = "Defence Up!",
        [CommonBuffs.StaminaUp]          = "Stamina Recovery Up!",
        [CommonBuffs.DebuffPrevention]   = "Debuffs Negated!",
        [CommonBuffs.CriticalUp]         = "Critical Up!",
        [CommonBuffs.SuperArmor]         = "Super Armor!",
        [CommonBuffs.ElementAttackUp]    = "Element Attack Up!",
        [CommonBuffs.Stamina]            = "Stamina Use Down!",    -- Might need to be swapped with Stamina Up
        [CommonBuffs.HpRegene]           = "Health Regen!",
        [CommonBuffs.HpFish]             = "Gourmet Fish!",
        [CommonBuffs.HyperArmor]         = "Hyper Armor!",
        [CommonBuffs.DamageDown]         = "Divine Protection!",   -- This is what this sounds like
        [CommonBuffs.EarS]               = "Earplugs (S)!",
        [CommonBuffs.EscapeUp]           = "Escape Up!",           -- No idea what this is
        [CommonBuffs.HpHealRegene]       = "HP Recovery Up!",
        [CommonBuffs.AttackUpEffectOnly] = "Attack Up Effect!",    -- No idea what this is
    },

    hornBuffMsgs = {
        [HornBuffs.HornAttackUp]        = "HH: Attack Up!",
        [HornBuffs.HornDefenceUp]       = "HH: Defence Up!",
        [HornBuffs.HornMyUp]            = "HH: Self Improvement!",    -- Think this is what this is
        [HornBuffs.HornCriticalUp]      = "HH: Critical Up!",
        [HornBuffs.HornElementAttackUp] = "HH: Element Attack Up!",
        [HornBuffs.HornSuperArmor]      = "HH: Super Armor!",
        [HornBuffs.HornEarS]            = "HH: Earplugs (S)!",
        [HornBuffs.HornEarL]            = "HH: Earplugs (L)!",
        [HornBuffs.HornQuake]           = "HH: Tremors Negated!",
        [HornBuffs.HornWind]            = "HH: Wind Negated!",
        [HornBuffs.HornStun]            = "HH: Stun Negated!",
        [HornBuffs.HornElementDamage]   = "HH: Element Attack Up!",
        [HornBuffs.HornKago]            = "HH: Kago!",                -- No idea what this is
        [HornBuffs.HornHpRegene]        = "HH: HP Regen!",
        [HornBuffs.HornStamina]         = "HH: Stamina Use Down!",
        [HornBuffs.HornStaminaRegene]   = "HH: Stamina Recovery Up!",
        [HornBuffs.HornSlash]           = "HH: Slash!",               -- No idea what the next three are
        [HornBuffs.HornGroundDamage]    = "HH: Ground Damage!",
        [HornBuffs.HornRevolt]          = "HH: Revolt!",
        [HornBuffs.HornHyperArmor]      = "HH: Hyper Armor!",
    }
}