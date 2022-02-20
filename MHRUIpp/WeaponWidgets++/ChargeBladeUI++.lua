-- re.on_frame(function()
--     local InputManager      = sdk.get_managed_singleton("snow.StmInputManager")
--     -- local inputManagerType  = sdk.find_type_definition("snow.StmInputManager")
--     local inGameInputDevice = InputManager:get_field("_InGameInputDevice")
--     -- local inGameDeviceType  = sdk.find_type_definition("snow.StmInputManager.InGameInputDevice")
--     local playerInput       = inGameInputDevice:get_field("_pl_input")
--     local player = playerInput:get_field("RefPlayer")
--     -- local player            = sdk.get_native_field(playerInput, getType("snow.StmPlayerInput"),"RefPlayer") -- Will be a weapon class or PlayerLobbyBase if you're not in a quest


--     log_str = player:call("get_ChargedBottleNum")
-- end)