log.info("Loading MHR UI++ helpers.lua...")

-- Useful globals
StageManager_typedef = sdk.find_type_definition("snow.stage.StageManager")
VillageAreaManager_typedef = sdk.find_type_definition("snow.VillageAreaManager")
StageManager_typedef = sdk.find_type_definition("snow.stage.StageManager")
QuestManager_typedef = sdk.find_type_definition("snow.QuestManager")

-- Helper functions
function getPlayer()
  local playerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
  local player = playerManager:call("findMasterPlayer")
  return player
end

function isInTrainingArea()
  return sdk.get_managed_singleton("snow.VillageAreaManager"):call("get__CurrentAreaNo") == 5
end

function isDefaultUIOpen()
  return sdk.get_managed_singleton("snow.gui.GuiManager"):call("isOpenHudSharpness")
end

-- Temporary Logging function
-- log_str = ""
-- re.on_draw_ui(function() 
--     imgui.text(tostring(log_str))
-- end)