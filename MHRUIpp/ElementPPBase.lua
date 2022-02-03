require("MHRUIpp/helpers")

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