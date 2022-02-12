-- Helper functions
local function getStaticEnum(typename)
    local enum = {}
    for i, field in ipairs(sdk.find_type_definition(typename):get_fields()) do
        if field:is_static() then
            enum[field:get_name()] = field:get_data(nil)
        end
    end
    return enum
end

-- Typedefs
StageManager_typedef = sdk.find_type_definition("snow.stage.StageManager")
VillageAreaManager_typedef = sdk.find_type_definition("snow.VillageAreaManager")
StageManager_typedef = sdk.find_type_definition("snow.stage.StageManager")
QuestManager_typedef = sdk.find_type_definition("snow.QuestManager")
PlayerBase_typedef = sdk.find_type_definition("snow.player.PlayerBase")
SceneManager_typedef = sdk.find_type_definition("via.SceneManager")
EnemyCharacterBase_typedef = sdk.find_type_definition("snow.enemy.EnemyCharacterBase")
-- Font file path and aspect ratio (width to height). Change on per font basis
fontFilepath = "Cascadia.ttf"
fontAspectRatio = 0.5
Debuffs = getStaticEnum("snow.player.PlayerCondition.Debuff")
CommonBuffs = getStaticEnum("snow.player.PlayerCondition.Common")
HornBuffs = getStaticEnum("snow.player.PlayerCondition.HornMusicUp")
-- Global offset for text inside widgets. Might be made customizable later.
textHorizOffset = 5
textVertOffset = 3
-- Stamina isn't reported in seconds for some reason :|
staminaUnitsToSeconds = 360 / 21600
-- Singletons
PlayerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
QuestManager = sdk.get_managed_singleton("snow.QuestManager")
GUIManager = sdk.get_managed_singleton("snow.gui.GuiManager")
HWKeyboardManager = sdk.get_managed_singleton("snow.GameKeyboard")
SceneManager = sdk.get_native_singleton("via.SceneManager")
MessageManager = sdk.get_managed_singleton("snow.gui.MessageManager")
EnemyManager = sdk.get_managed_singleton("snow.enemy.EnemyManager")
-- Temporary globals
tempToggleKey = "Delete"
tempToggleKeyNumber = 46
-- Screen width and height
screenWidth = sdk.call_native_func(sceneman, SceneManager_typedef, "get_MainView"):call("get_Size"):get_field("w")

-- Helpers functions
function getPlayer()
    return PlayerManager:call("findMasterPlayer")
end

-- We need to keep getting this singleton for this to work properly :|
function isInTrainingArea()
    return sdk.get_managed_singleton("snow.VillageAreaManager"):call("get__CurrentAreaNo") == 5
end

function mergeTables(tables)
    local t = {}
    for _, table in ipairs(tables) do
        for k, v in pairs(table) do
            if t[k] and type(t[k]) == 'table' and type(v) == 'table' then
                t[k] = mergeTables({t[k], v})
            else
                t[k] = v
            end
        end
    end
    return t
end

log_str = ""
re.on_draw_ui(function() 
    imgui.text(tostring(log_str))
end)