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
        if not HWKeyboardManager then HWKeyboardManager = sdk.get_managed_singleton("snow.GameKeyboard"):get_field("hardKeyboard") end
        return self.cfg.visible or HWKeyboardManager:call("getDown", math.floor(self.cfg.holdDownKey))
    end,
}})


IPersistantConfigurableWidget = mergeTables({IPersistantWidget, IConfigurableWidget})
IPersistantConfigurableViewableWidget = mergeTables({IPersistantConfigurableWidget, IViewableWidget})






ElementPPBase = {
    -- Holds the default config for "Reset Defaults"
    defaults = {},
    cfg = {},
    -- Flag to save config file
    cfgChanged = false,
    cfgFilepath = "MHRUIpp_Profiles\\",

    -- Flag to show/hide config window
    configWindowVisible = false,

    -- Font this element uses
    font,

    new = function(self, cfgFilename, defaults)
        o = {}
        setmetatable(o, self)
        self.__index = self
        o.cfgFilepath = o.cfgFilepath .. (cfgFilename or "")
        o.defaults = defaults or {}
        -- Add visible and fontSize keys to defaults if they aren't already there.
        o.defaults.visible = o.defaults.visible or true
        o.defaults.fontSize = o.defaults.fontSize or 14
        return o
    end,

    setup = function(self)
        -- Load the config first
        self.cfg = json.load_file(self.cfgFilepath)
        if next(self.cfg) == nil then
            self:restoreDefaults()
            json.dump_file(self.cfgFilepath, self.cfg)
        end
        -- Add the visible key to the loaded config in case it doesn't have it.
        self.cfg.visible = self.cfg.visible or true
        -- Then load the font
        self.font = imgui.load_font(fontFilepath, self.defaults.fontSize)
    end,

    isVisible = function(self)
        return self.cfg.visible
    end,

    toggleConfigWindowVisibility = function(self)
        self.cfgWinVisible = not self.cfgWinVisible
    end,

    isConfigWindowVisible = function(self)
        return self.cfgWinVisible
    end,

    save = function(self)
        -- Save the config to disk
        if self.cfgChanged then
            if not json.dump_file(self.cfgFilepath, self.cfg) then
                self:restoreDefaults()
                json.dump_file(self.cfgFilepath, self.cfg)
            end
        end
        -- Reset the font field in case font size was changed
        self.font = imgui.load_font(fontFilepath, self.cfg.fontSize)
        -- Reset the flag
        self.cfgChanged = false
    end,

    restoreDefaults = function(self)
        self.cfg = {}
        for k, v in pairs(self.defaults) do self.cfg[k] = v end
    end
}