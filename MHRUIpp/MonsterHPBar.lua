require("MHRUIpp/interfaces")

return {
    new = function(self)
        o = {}
        setmetatable(self, {__index = IPersistantConfigurableViewableWidget})
        self.__index = self
        setmetatable(o, self)
        o.cfgFilepath = o.cfgFilepath .. "MonsterHPBar.json"
        o.defaults = mergeTables({o.defaults, {
            x           = screenWidth - 320,
            y           = 160,
            w           = 280,
            borderWidth = 2,
            borderColor = "0xAA000000",
            bgColor     = "0xAA534BD5",
            textColor   = "0xFFFFFFFF",
        }})
        o:loadCfg()
        o:loadFont()
        return o
    end,

    draw = function(self)
        local text = "Test"
        local h = self.cfg.fontSize + (textVertOffset << 1)
        local borderOffset = self.cfg.borderWidth << 1

        imgui.push_font(self.font)
        draw.filled_rect(self.cfg.x - self.cfg.borderWidth, self.cfg.y - self.cfg.borderWidth, self.cfg.w + borderOffset, h + borderOffset, self.cfg.borderColor)
        draw.filled_rect(self.cfg.x, self.cfg.y, self.cfg.w, h, self.cfg.bgColor)
        draw.text(text, self.cfg.x + textHorizOffset, self.cfg.y + textVertOffset, self.cfg.textColor)
        imgui.pop_font()
    end,

    drawConfigWindow = function(self)
        self.cfgWinVisible = imgui.begin_window("Configure Monster HP Bar", true, 0x10120)
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