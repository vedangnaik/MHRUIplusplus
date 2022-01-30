log.info("Loading MHR UI++ helpers.lua...")

-- Useful globals
StageManager_typedef = sdk.find_type_definition("snow.stage.StageManager")
VillageAreaManager_typedef = sdk.find_type_definition("snow.VillageAreaManager")
StageManager_typedef = sdk.find_type_definition("snow.stage.StageManager")
QuestManager_typedef = sdk.find_type_definition("snow.QuestManager")
log_str = ""

showCustomUI = false

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
  return sdk.get_managed_singleton("snow.gui.GuiManager"):call("isOpenHudSharpness")
end

function drawGauge(x, y, w, h, percentage, gaugeColor, gaugeText)
	draw.filled_rect(x - 1, y - 1, w + 2, h + 2, 0xAA000000)
	draw.filled_rect(x, y, w * percentage, h, gaugeColor)
	draw.text(gaugeText, x + 5, y + 2, 0xFFFFFFFF)
end