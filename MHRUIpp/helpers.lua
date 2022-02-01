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
Debuffs = getStaticEnum("snow.player.PlayerCondition.Debuff")

-- Helper functions
function getPlayer()
  return sdk.get_managed_singleton("snow.player.PlayerManager"):call("findMasterPlayer")
end

function isInTrainingArea()
  return sdk.get_managed_singleton("snow.VillageAreaManager"):call("get__CurrentAreaNo") == 5
end

-- Temporary Logging function
log_str = ""
re.on_draw_ui(function() 
    imgui.text(tostring(log_str))
end)