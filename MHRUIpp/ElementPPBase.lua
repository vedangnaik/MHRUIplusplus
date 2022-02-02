ElementPPBase = {
    -- Holds the default config for "Reset Defaults"
    defaults = {},
    cfg = {},
    -- Flag to save config file
    cfgChanged = false,
    cfgFilepath = "MHRUIpp_Profiles\\",

    -- Flag to show/hide config window
    configWindowVisible = false,

    new = function(self, cfgFilename, defaults)
        o = {}
        setmetatable(o, self)
        self.__index = self
        o.cfgFilename = o.cfgFilepath .. (cfgFilename or "")
        o.defaults = defaults or {}
        -- Add the visible key to defaults if it isn't already there.
        o.defaults.visible = o.defaults.visible or true
        return o
    end,

    loadConfig = function(self)
        loadedConfig = json.load_file(self.cfgFilepath)
        if loadedConfig == nil then
            self.cfg = self.defaults
            json.dump_file(self.cfgFilepath, self.cfg)
        else
            self.cfg = loadedConfig
            -- Add the visible key to the loaded config in case it doesn't have it.
            self.cfg.visible = self.cfg.visible or true
        end
    end,

    isVisible = function(self)
        return self.cfg.visible
    end,

    toggleConfigWindowVisibility = function(self)
        self.cfgWinVisible = not self.cfgWinVisible
    end,

    isConfigWindowVisible = function(self)
        return self.cfgWinVisible
    end
}