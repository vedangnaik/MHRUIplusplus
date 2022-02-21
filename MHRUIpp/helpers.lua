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

-- Singletons
PlayerManager     = nil
QuestManager      = nil
GUIManager        = nil
HWKeyboardManager = nil
SceneManager      = sdk.get_native_singleton("via.SceneManager")
MessageManager    = nil
EnemyManager      = nil
InputManager      = nil
-- Typedefs
StageManager_typedef       = sdk.find_type_definition("snow.stage.StageManager")
VillageAreaManager_typedef = sdk.find_type_definition("snow.VillageAreaManager")
StageManager_typedef       = sdk.find_type_definition("snow.stage.StageManager")
QuestManager_typedef       = sdk.find_type_definition("snow.QuestManager")
PlayerBase_typedef         = sdk.find_type_definition("snow.player.PlayerBase")
SceneManager_typedef       = sdk.find_type_definition("via.SceneManager")
EnemyCharacterBase_typedef = sdk.find_type_definition("snow.enemy.EnemyCharacterBase")
-- Font file path and aspect ratio (width to height). Change on per font basis
fontFilepath    = "Cascadia.ttf"
fontAspectRatio = 0.5
-- Static enums required for strings in some widgets.
Debuffs     = getStaticEnum("snow.player.PlayerCondition.Debuff")
CommonBuffs = getStaticEnum("snow.player.PlayerCondition.Common")
HornBuffs   = getStaticEnum("snow.player.PlayerCondition.HornMusicUp")
-- Global offset for text inside widgets. Might be made customizable later.
textHorizOffset = 5
textVertOffset  = 3
-- Stamina isn't reported in seconds for some reason :|
staminaUnitsToSeconds = 360 / 21600
-- Temporary globals
tempToggleKey       = "Delete"
tempToggleKeyNumber = 46
-- Screen width
screenWidth = sdk.call_native_func(SceneManager, SceneManager_typedef, "get_MainView"):call("get_Size"):get_field("w")

function getPlayer()
    if not PlayerManager then PlayerManager = sdk.get_managed_singleton("snow.player.PlayerManager") end
    return PlayerManager:call("findMasterPlayer")
end

function isInTrainingArea()
    -- We need to keep getting this singleton for this to work properly :|
    return sdk.get_managed_singleton("snow.VillageAreaManager"):call("get__CurrentAreaNo") == 5
end

function getCurrentWeaponInstanceAndName()
    if not InputManager then InputManager = sdk.get_managed_singleton("snow.StmInputManager") end
    local weapon = InputManager:get_field("_InGameInputDevice"):get_field("_pl_input"):get_field("RefPlayer")
    local weaponName = weapon:get_type_definition():get_name()
    return weapon, weaponName
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
    if log_str == "" then return end
    imgui.text(tostring(log_str))
end)