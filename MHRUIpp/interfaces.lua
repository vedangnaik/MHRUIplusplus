require("MHRUIpp/helpers")

-- Most basic widget.
IWidget = {
    defaults = {
        fontSize = 14
    },
    cfg = {},
    font = nil,

    -- Virtual/abstract function - should be overridden
    draw = function(self) end,

    restoreDefaults = function(self)
        self.cfg = {}
        for k, v in pairs(self.defaults) do self.cfg[k] = v end
    end,

    loadFont = function(self)
        self.font = imgui.load_font(fontFilepath, self.cfg.fontSize)
    end
}

-- Widget with a config window.
IConfigurableWidget = mergeTables({IWidget, {
    cfgWinVisible = false,

    toggleConfigWindowVisibility = function(self)
        self.cfgWinVisible = not self.cfgWinVisible
    end,

    isConfigWindowVisible = function(self)
        return self.cfgWinVisible
    end,

    -- Abstract function, to be overridden
    drawConfigWindow = function(self) end
}})

-- Widget with persistant profiles.
IPersistantWidget = mergeTables({IWidget, {
    cfgChanged = false,
    cfgFilepath = "MHRUIpp_Profiles\\",

    loadCfg = function(self)
        self.cfg = json.load_file(self.cfgFilepath)
        if next(self.cfg) == nil then
            self:restoreDefaults()
            json.dump_file(self.cfgFilepath, self.cfg)
        end
    end,

    saveCfg = function(self)
        if self.cfgChanged then
            if not json.dump_file(self.cfgFilepath, self.cfg) then
                self:restoreDefaults()
                json.dump_file(self.cfgFilepath, self.cfg)
            end
        end
        -- Reset the flag
        self.cfgChanged = false
    end,
}})

IViewableWidget = mergeTables({IWidget, {
    defaults = {
        visible = true,
        holdDownKey = tempToggleKeyNumber,
    },

    isVisible = function(self)
        if not HWKeyboardManager then HWKeyboardManager = sdk.get_managed_singleton("snow.GameKeyboard") end
        return self.cfg.visible or HWKeyboardManager:call("getDown", math.floor(self.cfg.holdDownKey))
    end,
}})


IPersistantConfigurableWidget = mergeTables({IPersistantWidget, IConfigurableWidget})
IPersistantConfigurableViewableWidget = mergeTables({IPersistantConfigurableWidget, IViewableWidget})