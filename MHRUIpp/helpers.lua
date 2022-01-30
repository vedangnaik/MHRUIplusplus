log.info("Loading MHR UI++ helpers.lua...")

-- Log strings
enteredTrainingArea = "[MHRUIpp] Entered Kamura Training Area, enabling custom UI..."
leftTrainingArea = "[MHRUIpp] Left Kamura Training Area, disabling custom UI..."


-- Useful globals
StageManager_typedef = sdk.find_type_definition("snow.stage.StageManager")
VillageAreaManager_typedef = sdk.find_type_definition("snow.VillageAreaManager")
log_str = ""

hideUICountdown = 0
restoreUICountdown = 0
showCustomUI = true

-- Helper functions
function getPlayer()
  local playerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
  local player = playerManager:call("findMasterPlayer")
  return player
end

function getCurrentAreaNoInKamura()
  return sdk.get_managed_singleton("snow.VillageAreaManager"):call("get__CurrentAreaNo")
end

function isDefaultUIOpen()
  return sdk.get_managed_singleton("snow.gui.GuiManager"):call("isOpenHud")
end

function drawGauge(x, y, w, h, percentage, gaugeColor, gaugeText)
	draw.filled_rect(x - 1, y - 1, w + 2, h + 2, 0xAA000000)
	draw.filled_rect(x, y, w * percentage, h, gaugeColor)
	draw.text(gaugeText, x + 5, y + 2, 0xFFFFFFFF)
end