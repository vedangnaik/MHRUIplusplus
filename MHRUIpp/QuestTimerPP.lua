require("MHRUIpp/ElementPPBase")

-- This is a superclass of the ElementPPBase class
QuestTimerPP = ElementPPBase:new():new("QuestTimer++.json", {
    x           = 5,
    y           = 5,
    borderWidth = 2,
    borderColor = "0xAA000000",
    bgColor     = "0xAAFFC5EE",
    textColor   = "0xFFFFFFFF",
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

    local w = (13 * self.cfg.fontSize * fontAspectRatio) + (textHorizOffset << 1) -- Hardcoded string length
    local h = self.cfg.fontSize + (textVertOffset << 1)
    local borderOffset = self.cfg.borderWidth << 1
    local text = ""
    
    if timeLimit == 0 then
        text = "No Time Limit"
    else
        text = string.format("%02d:%02.0f / %02d:00", elapsedTimeSeconds // 60, elapsedTimeSeconds % 60, timeLimit)
    end

    imgui.push_font(self.font)
	draw.filled_rect(self.cfg.x - self.cfg.borderWidth, self.cfg.y - self.cfg.borderWidth, w + borderOffset, h + borderOffset, self.cfg.borderColor)
	draw.filled_rect(self.cfg.x, self.cfg.y, w, h, self.cfg.bgColor)
	draw.text(text, self.cfg.x + textHorizOffset, self.cfg.y + textVertOffset, self.cfg.textColor)
    imgui.pop_font()
end

function QuestTimerPP:drawConfigWindow()
    self.cfgWinVisible = imgui.begin_window("Configure Quest Timer++", true, 0x10120)
	if not self.cfgWinVisible then return false end
    
    local changed = false;
    changed, self.cfg.visible = imgui.checkbox("Show?", self.cfg.visible)
    self.cfgChanged = self.cfgChanged or changed
    imgui.new_line()

    changed, self.cfg.fontSize = imgui.drag_int("Font Size", self.cfg.fontSize, 1, 2, 50)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.x = imgui.drag_int("X coord", self.cfg.x, 2, 0, 10000)
    self.cfgChanged = self.cfgChanged or changed
    changed, self.cfg.y = imgui.drag_int("Y coord", self.cfg.y, 2, 0, 10000)
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