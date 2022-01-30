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