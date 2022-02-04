-- Get static enums
local function getStaticEnum(typename)
    local enum = {}
    for i, field in ipairs(sdk.find_type_definition(typename):get_fields()) do
        if field:is_static() then
            enum[field:get_name()] = field:get_data(nil)
        end
    end
    return enum
end

-- Useful globals
StageManager_typedef = sdk.find_type_definition("snow.stage.StageManager")
VillageAreaManager_typedef = sdk.find_type_definition("snow.VillageAreaManager")
StageManager_typedef = sdk.find_type_definition("snow.stage.StageManager")
QuestManager_typedef = sdk.find_type_definition("snow.QuestManager")
PlayerBase_typedef = sdk.find_type_definition("snow.player.PlayerBase")
-- Font file path and aspect ratio (width to height). Change on per font basis
fontFilepath = "Cascadia.ttf"
fontAspectRatio = 0.5
Debuffs = getStaticEnum("snow.player.PlayerCondition.Debuff")
-- Global offset for text inside widgets. Might be made customizable later.
textHorizOffset = 5
textVertOffset = 3
-- Stamina isn't reported in seconds for some reason :|
staminaUnitsToSeconds = 360 / 21600

-- Helper functions
function getPlayer()
  return sdk.get_managed_singleton("snow.player.PlayerManager"):call("findMasterPlayer")
end

function isInTrainingArea()
  return sdk.get_managed_singleton("snow.VillageAreaManager"):call("get__CurrentAreaNo") == 5
end

function closeUI()
    local guiManager = sdk.get_managed_singleton("snow.gui.GuiManager")
    guiManager:call("closeHud") -- Disable Health bar, stamina bar, quest timer, etc.
    guiManager:call("closePartHud") -- Disable Palico and Palamute health
    guiManager:call("closeHudSharpness") -- Disable Palico and Palamute health
end

-- log_str = ""
-- re.on_draw_ui(function() 
--     imgui.text(tostring(log_str))
-- end)