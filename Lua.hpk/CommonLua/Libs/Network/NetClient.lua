function NetRecord(label, ...)
  if not config.SwarmConnect then
    return
  end
  local _, context = ...
  local rec = Serialize(LuaRevision, os.time(), label, ...)
  CreateRealTimeThread(function(rec, context)
    local err = NetCall("rfnRec", Unserialize(rec))
    if err and rawget(_G, "AccountStorage") and context ~= "account save" then
      AccountStorage.NetRecord = AccountStorage.NetRecord or {}
      AccountStorage.NetRecord[#AccountStorage.NetRecord + 1] = rec
      if #AccountStorage.NetRecord > 100 then
        table.remove(AccountStorage.NetRecord, 1)
      end
      SaveAccountStorage(30000)
    end
  end, rec, context)
end
function LogLatestCrash()
  if not (Platform.pc or Platform.osx or Platform.linux) or g_bCrashReported then
    return
  end
  g_bCrashReported = true
  local crash_files, latest_crash_file, latest_crash_date = GetCrashFiles("*.crash")
  if not latest_crash_file then
    return
  end
  local err, crash_log = AsyncFileToString(latest_crash_file)
  if err then
    return
  end
  local filename = tostring(latest_crash_date or os.date("!%d %b %Y %H:%M:%S"))
  NetLogFile("crash", filename, "crash", crash_log)
  if Platform.osx then
    local reports_dir = "/Users/" .. GetUsername() .. "/Library/Logs/DiagnosticReports"
    local reports_pattern = GetExecName() .. "_*.crash"
    local _, reports = AsyncListFiles(reports_dir, reports_pattern, "recursive,modified")
    reports = reports or {}
    for i = 1, #(reports.modified or "") do
      reports.modified[i] = reports.modified[i] - latest_crash_date
    end
    local _, report_index = table.min(reports.modified or "")
    local report = reports[report_index] or ""
    local _, report_dump = AsyncFileToString(report)
    NetLogFile("crash", filename, "xdmp", report_dump)
    AsyncFileDelete(reports)
  else
    local dump_ext = Platform.linux and "ldmp" or "dmp"
    local dump_file = string.gsub(latest_crash_file, "%.crash$", "." .. dump_ext)
    local _, crash_dump = AsyncFileToString(dump_file)
    NetLogFile("crash", filename, dump_ext, crash_dump)
  end
  EmptyCrashFolder()
end
function OnMsg.NetConnect()
  CreateRealTimeThread(function()
    local display = GetMainWindowDisplayIndex()
    NetGossip("Hardware", GetHardwareInfo(EngineOptions.GraphicsApi, EngineOptions.GraphicsAdapterIndex), EngineOptions)
    LogLatestCrash()
    if rawget(_G, "AccountStorage") and AccountStorage.NetRecord and AccountStorage.NetRecord[1] then
      while AccountStorage.NetRecord[1] do
        local err = NetCall("rfnRec", Unserialize(AccountStorage.NetRecord[1]))
        if err == "disconnected" then
          break
        end
        table.remove(AccountStorage.NetRecord, 1)
      end
      SaveAccountStorage(30000)
    end
  end)
end
if FirstLoad then
  g_TryConnectToServerThread = false
end
function TryConnectToServer()
  if Platform.cmdline then
    return
  end
  g_TryConnectToServerThread = g_TryConnectToServerThread or CreateRealTimeThread(function()
    WaitInitialDlcLoad()
    while not AccountStorage do
      WaitMsg("AccountStorageChanged")
    end
    if Platform.xbox then
      WaitMsg("XboxUserSignedIn")
    end
    local wait = 60000
    while config.SwarmConnect do
      if not NetIsConnected() then
        local err, auth_provider, auth_provider_data, display_name = NetGetProviderLogin(false)
        if err then
          err, auth_provider, auth_provider_data, display_name = NetGetAutoLogin()
        end
        err = err or NetConnect(config.SwarmHost, config.SwarmPort, auth_provider, auth_provider_data, display_name, config.NetCheckUpdates, "netClient")
        if err == "failed" or err == "version" then
          return
        end
        if not err and config.SwarmConnect == "ping" or err == "bye" then
          NetDisconnect("netClient")
          return
        end
        wait = wait * 2
        if err == "maintenance" or err == "not ready" then
          wait = 300000
        end
      end
      if NetIsConnected() then
        wait = 60000
        if config.SwarmConnect == "ping" then
          NetDisconnect("netClient")
          return
        end
        WaitMsg("NetDisconnect")
      end
      Sleep(wait)
    end
  end)
end
