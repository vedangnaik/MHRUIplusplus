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
fontFilepath = "Cascadia.ttf"
Debuffs = getStaticEnum("snow.player.PlayerCondition.Debuff")
textHorizOffset = 5
textVertOffset = 3

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
    guiManager:call("closeHudSharpness") -- Disable sharpness gauge
    -- guiManager:call("openWeaponUI") -- Weapon-specific UI e.g. Charge Blade phials
    -- guiManager:call("setInvisibleAllGUI", false) -- Turn off 'all' GUI, too powerful i.e. removes map, pause window, everything
    -- guiManager:call("closeAllQuestHudUI") -- Potentially useful, turns of all HUD i.e. items, everything
end

-- Temporary Logging function
-- log_str = ""
-- re.on_draw_ui(function() 
--     imgui.text(tostring(log_str))
-- end)