if not Platform.ged then
  return
end
function OnMsg.Autorun()
  local cmd_line = GetAppCmdLine()
  if cmd_line == "" then
    return
  end
  local ged_param = string.match(cmd_line, "-ged=(%w+)")
  if not ged_param then
    return
  end
  local ged_id = tonumber(ged_param)
  if ged_id then
    config.ged_id = ged_id
  else
    config.ged_template = ged_param
  end
  local default_port = 44000
  local game_address = string.match(cmd_line, "-address=(%S+)")
  if game_address then
    local ip, port = string.match(game_address, "(%S+):(%d+)")
    ip = ip or game_address
    game_address = ip .. ":" .. (port or default_port)
  else
    game_address = "localhost:" .. default_port
  end
  config.game_address = game_address
  local cmd_params = GetAppCmdParams()
  local src = ""
  for _, item in ipairs(cmd_params) do
    if not item:match("^-") then
      src = src .. " " .. item
    end
  end
  local func, err = load(src)
  if not func then
    print("Error:", err)
  else
    CreateRealTimeThread(function()
      local err = func()
      if err then
        print("Error:", err)
      end
    end)
  end
end
if FirstLoad then
  g_GameSocket = false
end
function OnMsg.Start()
  MountPack("memoryfs", "", "compress,create", 33554432)
  if config.ged_id then
    CreateRealTimeThread(function()
      g_GameSocket = GedSocket:new()
      local host, port = string.match(config.game_address, "^([^:]+):?(.*)$")
      local err = g_GameSocket:WaitConnect(30000, host or "localhost", tonumber(port))
      if err then
        g_GameSocket:delete()
      else
        g_GameSocket:Send("rfnGedId", config.ged_id)
      end
    end)
  elseif config.ged_template then
    local app = XTemplateSpawn(config.ged_template, nil, {})
    if not app then
      print("Invalid ged app")
      return nil
    end
    if IsKindOf(app, "GedApp") then
      if app.AppId == "" then
        app:SetAppId(config.ged_template)
      end
      if app:GetTitle() == "" then
        app:SetTitle(config.ged_template)
      end
    end
    app:Open()
  end
end
