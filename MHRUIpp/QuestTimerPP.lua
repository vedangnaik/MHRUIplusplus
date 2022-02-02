require("MHRUIpp/helpers")
require("MHRUIpp/ElementPPBase")

-- This is a superclass of the ElementPPBase class
QuestTimerPP = ElementPPBase:new():new("QuestTimer++.json", {
    x = 5,
    y = 5,
    w = 100,
    h = 20,
    borderThickness = 2,
    borderColor = "0xAA000000",
    color = "0xAAFFC5EE"
})

function QuestTimerPP:draw()
    local timeLimit = 0
    local elapsedTimeSeconds = 0

    local questManager = sdk.get_managed_singleton("snow.QuestManager")
	local activeQuestData = questManager:call("getActiveQuestData")
	if activeQuestData then
		timeLimit = activeQuestData:call("getTimeLimit")
		elapsedTimeSeconds = questManager:call("getQuestElapsedTimeSec");
	end

    local b = self.cfg.borderThickness
    local b_offset = b << 1 -- Fast multiply by 2
    local textVerticalOffset = (self.cfg.h - 14) >> 1 -- Fast div by 2, font size is 14
    
    local text = ""
    if timeLimit == 0 then
        text = "No Time Limit"
    else
        text = string.format("%02d:%02.0f / %02d:00", elapsedTimeSeconds // 60, elapsedTimeSeconds % 60, timeLimit)
    end

	draw.filled_rect(self.cfg.x - b, self.cfg.y - b, self.cfg.w + b_offset, self.cfg.h + b_offset, self.cfg.borderColor)
	draw.filled_rect(self.cfg.x, self.cfg.y, self.cfg.w, self.cfg.h, self.cfg.color)
	draw.text(text, self.cfg.x + 5, self.cfg.y + textVerticalOffset, 0xFFFFFFFF)
end

function QuestTimerPP:drawConfigWindow()
    self.cfgWinVisible = imgui.begin_window("Configure Quest Timer++", true, 0x10120)
	if not self.cfgWinVisible then
        if self.cfgChanged then
            if not json.dump_file(self.cfgFilepath, self.cfg) then
                self.cfg = self.defaults
                json.dump_file(self.cfgFilepath, self.cfg)
            end
        end
        self.cfgChanged = false
		return
	end
    
    local changed = false;
    changed, self.cfg.visible = imgui.checkbox("Show?", self.cfg.visible)
    self.cfgChanged = self.cfgChanged or changed
    imgui.new_line()

    changed, self.cfg.x = imgui.drag_int("X coord", self.cfg.x, 2, 0, 10000)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.y = imgui.drag_int("Y coord", self.cfg.y, 2, 0, 10000)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.w = imgui.drag_int("Width", self.cfg.w, 2, 0, 10000)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.h = imgui.drag_int("Height", self.cfg.h, 2, 0, 10000)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.borderThickness = imgui.drag_int("Border", self.cfg.borderThickness, 1, 0, 50)
    self.cfgChanged = self.cfgChanged or changed
    -- TODO: Add color picker
    imgui.text("Color pickers coming soon!")
    imgui.new_line()
    
    if imgui.button("Reset Defaults") then
        self.cfg = self.defaults
        self.cfgChanged = true
    end

	imgui.end_window()
end