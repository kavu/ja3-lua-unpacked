g_MantisUrl = "http://mantis.haemimontgames.com"
config.BugReporterXTemplateID = "BugReport"
local AutoReporter = "8o6myXi_5UcfoF4_qwl4hjAjFX95w8ws"
function OnMsg.ClassesBuilt()
  if not rawget(_G, "HGMembers") then
    rawset(_G, "HGMembers", {})
  end
end
local GetReporter = function(reporter_name)
  reporter_name = reporter_name or LocalStorage and LocalStorage.dlgBugReport.reporter
  reporter_name = reporter_name and reporter_name ~= "" and reporter_name or config.MantisUser or GetUsername()
  return HGMembers[reporter_name] and HGMembers[reporter_name].mantis_token or nil, reporter_name
end
function ReportBug(bug_data)
  local files = {}
  for _, ftype in ipairs({
    "image",
    "log",
    "save",
    "autosave"
  }) do
    local name = bug_data[ftype]
    if name then
      local content = bug_data[ftype .. "_pstr"]
      if not content then
        local err
        err, content = AsyncFileToString(name)
        if err then
          print("Failed to load file", name, ":", err)
        end
      end
      if content then
        local path, file, ext = SplitPath(name)
        files[#files + 1] = {
          name = file .. ext,
          content = Encode64(content)
        }
      end
    end
  end
  if bug_data.extra_info then
    files[#files + 1] = {
      name = "ExtraInfo.txt",
      content = Encode64(bug_data.extra_info)
    }
  end
  if bug_data.files then
    for _, filename in ipairs(bug_data.files) do
      local err, content = AsyncFileToString(filename)
      if err then
        print("Failed to load file", filename, ":", err)
      else
        table.insert(files, {
          name = filename,
          content = Encode64(content)
        })
      end
    end
  end
  local description = bug_data.reporter == AutoReporter and bug_data.description .. [[


]] .. bug_data.note or bug_data.description
  description = string.trim_spaces(description or "")
  print("Reporting...")
  local headers = {
    Authorization = bug_data.reporter,
    ["Content-Type"] = "application/json"
  }
  local err, info
  if bug_data.appendToBug then
    local note_text = bug_data.summary .. [[


]] .. description
    if bug_data.reporter ~= AutoReporter and (bug_data.note or "") ~= "" then
      note_text = note_text .. [[


]] .. bug_data.note
    end
    note_text = note_text .. "\n"
    local body = {
      text = note_text,
      view_state = {name = "public"},
      files = files
    }
    local json_err, json_body = LuaToJSON(body)
    err, info = AsyncWebRequest({
      method = "POST",
      url = g_MantisUrl .. "/api/rest/issues/" .. tostring(bug_data.appendToBug) .. "/notes",
      headers = headers,
      body = json_body,
      timeout = 60000
    })
  else
    local body = {
      project = {
        id = bug_data.project
      },
      category = {
        name = bug_data.category
      },
      summary = bug_data.summary,
      description = 0 < #description and description or ".",
      handler = {
        id = bug_data.handler
      },
      priority = {
        id = bug_data.priority
      },
      severity = {
        id = bug_data.severity
      },
      reproducibility = {
        id = bug_data.reproducibility
      },
      target_version = bug_data.target_version,
      files = files
    }
    local json_err, json_body = LuaToJSON(body)
    err, info = AsyncWebRequest({
      method = "POST",
      url = g_MantisUrl .. "/api/rest/issues/",
      headers = headers,
      body = json_body,
      timeout = 60000
    })
  end
  if not err and type(info) == "string" then
    local idx1, idx2 = string.find_lower(info, "error")
    if idx2 then
      local idx3 = string.find(info, ".", idx2 + 1, true)
      local err_str = string.sub(info, idx2 + 1, idx3 - 1)
      err = string.match(err_str, "[%w%s()_]+$")
    end
  end
  if err then
    local json_err, luaInfo = JSONToLua(info)
    if err == 403 then
      if luaInfo then
        return string.format([[
Invalid API Token: %d(%s)
%s]], luaInfo.code, luaInfo.localized, luaInfo.message)
      else
        return "Invalid API Token!"
      end
    elseif err == 401 then
      return "API Token is missing"
    elseif err == 404 then
      return string.format([[
Not Found
Code: %d
Message: %s]], luaInfo and luaInfo.code or "Missing code", luaInfo and luaInfo.message or "Missing message")
    elseif err ~= 201 then
      print([[
Failed to report the bug! 
URL:]], g_MantisUrl, [[

Error:]], err, [[

Info:]], ValueToLuaCode(info))
      if err == true then
        return "Couldn't receive information from the server. Please check your internet connection"
      end
      return tostring(err) .. " " .. ValueToLuaCode(json_err and luaInfo or info)
    end
  end
  local err, luaInfo = JSONToLua(info)
  local issueId = bug_data.appendToBug or luaInfo and luaInfo.issue and luaInfo.issue.id
  if not bug_data.appendToBug then
    if bug_data.reporter ~= AutoReporter and (bug_data.note or "") ~= "" then
      Sleep(1000)
      local body = {
        text = bug_data.note,
        view_state = {name = "public"}
      }
      local err, body = LuaToJSON(body)
      local err, info = AsyncWebRequest({
        method = "POST",
        url = g_MantisUrl .. "/api/rest/issues/" .. tostring(issueId) .. "/notes",
        headers = headers,
        body = body,
        timeout = 60000
      })
    end
    if bug_data.tags then
      Sleep(1000)
      local body = {
        tags = bug_data.tags
      }
      local err, body = LuaToJSON(body)
      local err, info = AsyncWebRequest({
        method = "POST",
        url = g_MantisUrl .. "/api/rest/issues/" .. tostring(issueId) .. "/tags",
        headers = headers,
        body = body,
        timeout = 60000
      })
    end
  end
  print("Report sent.")
  local url = issueId and g_MantisUrl .. "/view.php?id=" .. issueId
  return nil, url
end
function ShowLog()
  CreateRealTimeThread(function()
    FlushLogFile()
    OpenTextFileWithEditorOfChoice(GetLogFile())
  end)
end
if FirstLoad then
  const.BugPriorityNames = {
    "none",
    "low",
    "normal",
    "high",
    "urgent",
    "immediate"
  }
  const.BugPriorityValues = {
    none = 10,
    low = 20,
    normal = 30,
    high = 40,
    urgent = 50,
    immediate = 60
  }
  const.BugSeverityNames = {
    "feature",
    "trivial",
    "text",
    "tweak",
    "minor",
    "major",
    "crash",
    "block"
  }
  const.BugSeverityValues = {
    feature = 10,
    trivial = 20,
    text = 30,
    tweak = 40,
    minor = 50,
    major = 60,
    crash = 70,
    block = 80
  }
  const.BugReproducibilityNames = {
    "always",
    "sometimes",
    "random",
    "unable to reproduce",
    "have not tried",
    "N/A"
  }
  const.BugReproducibilityValues = {
    always = 10,
    sometimes = 30,
    random = 50,
    ["have not tried"] = 70,
    ["unable to reproduce"] = 90,
    ["N/A"] = 100
  }
end
BugReportPlatformTagsToName = {
  XB1 = "xbox_one",
  XSX = "xbox_series",
  PS4 = "ps4",
  PS5 = "ps5"
}
local tempdir = "TmpData/BugReport"
DefineClass.XBugReportDlg = {
  __parents = {"XDialog"},
  properties = {
    {
      category = "General",
      id = "FocusSummaryOnOpen",
      editor = "bool",
      default = true
    }
  },
  IdNode = true,
  Background = RGB(240, 240, 240),
  tempdir = "",
  game_specific_info = "",
  scribble = false,
  last_report_error_hash = false,
  file_attachments = false,
  init_summary = false,
  init_descr = false,
  report_params = false
}
function XBugReportDlg:Init()
  XPauseLayer:new({}, self)
  XCameraLockLayer:new({}, self)
end
function XBugReportDlg:Open(...)
  XDialog.Open(self, ...)
  self:SetZOrder(BaseLoadingScreen.ZOrder + 1)
  self:InitControls()
  self:ScreenshotDrawOn()
end
if Platform.ged and Platform.developer then
  function OnMsg.CreateXBugReportDlg()
    if next(HGMembers) then
      return
    end
    local default_path = HGMember:GetSavePath()
    if io.exists(default_path) then
      pdofile(default_path)
    end
  end
end
function GatherBugReportMetadata(filename)
  local metadata = GatherGameMetadata()
  metadata.displayname = filename
  metadata.savename = filename .. ".savegame.sav"
  metadata.timestamp = os.time()
  metadata.playtime = GetCurrentPlaytime()
  metadata.isDev = true
  return metadata
end
if FirstLoad then
  g_LastAutosaveFilename = false
end
function OnMsg.SaveGameDone(name, autosave, err)
  if autosave and not err then
    g_LastAutosaveFilename = name or false
  end
end
function OnMsg.ChangeMap()
  g_LastAutosaveFilename = false
end
function OnMsg.LoadGame()
  g_LastAutosaveFilename = false
end
function XBugReportDlg:GetSendButtonControl()
  local children = GetChildrenOfKind(self, "XTextButton")
  for _, child in ipairs(children) do
    if child.Id == "idOK" then
      return child
    end
  end
end
function XBugReportDlg:Report()
  local container = self.idScrollArea
  local reporter = container.idReporter and container.idReporter:GetValue()
  local handler = container.idAssignTo and container.idAssignTo:GetValue()
  local tags_presets = Platform.ged and g_GedApp.bug_report_tags or PresetArray("BugReportTag")
  local tags
  local params = self.report_params or empty_table
  local sendButton = self:GetSendButtonControl()
  sendButton:SetEnabled(false)
  for _, tag in ipairs(tags_presets) do
    local toggle_btn = container["id" .. tag.id]
    if toggle_btn and toggle_btn:GetToggled() or Platform.goldmaster and tag.Automatic then
      tags = tags or {}
      table.insert(tags, {
        name = tag.id
      })
    end
  end
  for _, tag in ipairs(params.tags) do
    if not table.find(tags, "name", tag) then
      tags = tags or {}
      table.insert(tags, {name = tag})
    end
  end
  local include_extra_info = not params.no_extra_info and (config.ForceIncludeExtraInfo or container.idExtraInfo and container.idExtraInfo:GetCheck())
  local include_screenshot = not params.no_screenshot and (config.ForceIncludeScreenshot or container.idScreenshotCheck and container.idScreenshotCheck:GetCheck())
  local category = not params.category and container.idCategory and container.idCategory:GetValue()
  local priority = not params.priority and container.idPriority and container.idPriority:GetValue()
  local severity = not params.severity and container.idSeverity and container.idSeverity:GetValue()
  local reproducibility = container.idReproducibility and container.idReproducibility:GetValue()
  local target_version = container.idTargetVersion and container.idTargetVersion:GetValue()
  local summary = container.idSummary:GetText()
  if Platform.ged then
    summary = "[Ged] " .. summary
  end
  if Platform.linux then
    summary = "[Linux] " .. summary
  end
  if Platform.osx then
    summary = "[OSX] " .. summary
  end
  if Platform.xbox then
    summary = "[Xbox] " .. summary
  end
  if Platform.playstation then
    summary = "[Playstation] " .. summary
  end
  CreateRealTimeThread(function()
    local remember_data = LocalStorage.dlgBugReport
    remember_data.reporter = reporter
    remember_data.category = category
    remember_data.handler = handler
    remember_data.target_version = target_version
    SaveLocalStorage()
    local description = container.idDescription:GetText() or ""
    if params.append_description then
      description = description .. "\n" .. params.append_description
    end
    local reporter_token, reporter_name
    if container.idAPIToken and container.idAPIToken:GetVisible() then
      reporter_token = container.idAPIToken:GetText()
    end
    if (reporter_token or "") == "" then
      reporter_token, reporter_name = GetReporter(reporter)
    elseif AccountStorage then
      AccountStorage.MantisToken = reporter_token
      SaveAccountStorage(5000)
    end
    local extra_info
    local note = ""
    if include_extra_info then
      note = {}
      if not reporter_token and Libs.Network then
        note[#note + 1] = print_format("AccountId:", netAccountId)
      end
      if insideHG() then
        note[#note + 1] = print_format("Host:", sockGetHostName(), ", Ip: (", table.concat({
          LocalIPs()
        }, ", "), ")\n")
      end
      if (BuildVersion or "") ~= "" then
        note[#note + 1] = print_format("Build version:", BuildVersion)
      end
      if (BuildBranch or "") ~= "" then
        note[#note + 1] = print_format("Build branch:", BuildBranch)
      end
      note[#note + 1] = print_format("Revision Lua/OrgLua/Assets: ", LuaRevision, OrgLuaRevision, AssetsRevision)
      note[#note + 1] = print_format("Platform/provider/variant:", Platform.developer and "Developer" or "", PlatformName(), ProviderName(), VariantName())
      note[#note + 1] = print_format("GPU:", config.GraphicsApi, GetGpuDescription(), GetGpuDriverVersion())
      note[#note + 1] = print_format("Language:", GetLanguage())
      note = table.concat(note, "\n")
      extra_info = self.game_specific_info
    end
    reporter_token = reporter_token or AutoReporter
    local dest_filename
    local ctrlScreenshot = container.idScreenshot
    local screenshot_image = include_screenshot and ctrlScreenshot and ctrlScreenshot:GetImage() or ""
    if screenshot_image ~= "" then
      local dest_dir, dest_name = SplitPath(screenshot_image)
      local width, height = ctrlScreenshot:Getcontent_box_size():xy()
      local game_width, game_height = UIL.GetScreenSize():xy()
      local width_multiplier = 1000 * game_width / width
      local height_multiplier = 1000 * game_height / height
      local pts = {}
      if self.scribble then
        for _, scribble in ipairs(self.scribble) do
          for i = 1, #scribble - 1 do
            local x = MulDivRound(scribble[i]:x(), width_multiplier, 1000)
            local y = MulDivRound(scribble[i]:y(), height_multiplier, 1000)
            pts[#pts + 1] = point(x, y)
            x = MulDivRound(scribble[i + 1]:x(), width_multiplier, 1000)
            y = MulDivRound(scribble[i + 1]:y(), height_multiplier, 1000)
            pts[#pts + 1] = point(x, y)
          end
        end
      end
      dest_filename = dest_dir .. dest_name .. "-scribbles.jpg"
      OverlayLines(screenshot_image, dest_filename, pts)
    end
    local appendToBug = container.idAppendToExistingBug:GetText()
    if appendToBug and appendToBug == "" then
      appendToBug = nil
    end
    if appendToBug and string.starts_with(appendToBug, "http") then
      local bug_id = string.match(appendToBug, "id=([0-9]+)")
      if bug_id then
        appendToBug = bug_id
      else
        appendToBug = nil
      end
    end
    l_bug_report_counter = l_bug_report_counter + 1
    DebugPrint(string.format([[


BUG REPORT %d
]], l_bug_report_counter))
    DebugPrint("-----------------------------------------------------------------------------------\n")
    if appendToBug then
      DebugPrint(string.format("Appended to existing issue: %s\n", appendToBug))
    end
    DebugPrint(string.format("Summary: %s\n", summary))
    DebugPrint(string.format("Description: %s\n", description))
    DebugPrint([[


]])
    if Platform.developer and Platform.pc then
      DebugPrint(string.format("System memory load:   %d %%\n", GetMemoryInfo().used))
      DebugPrint(string.format("Process memory usage: %d MB\n", CurProcessMemUsage(1048576)))
      DebugPrint(string.format("Process avg CPU load: %d %%\n", CurProcessCpuUsage()))
    end
    local member_preset = HGMembers and HGMembers[handler] or empty_table
    local is_level_designer = member_preset.group == "Level Design"
    handler = member_preset.mantis_id
    priority = const.BugPriorityValues and const.BugPriorityValues[priority] or nil
    severity = const.BugSeverityValues and const.BugSeverityValues[severity] or nil
    reproducibility = const.BugReproducibilityValues and const.BugReproducibilityValues[reproducibility] or nil
    local bug_autosave_filename, bug_save_filename, bug_save_pstr, attach_save, attach_autosave
    local can_save = CanSaveGame() == "persist"
    if GetMap() ~= "" and (extra_info or params.force_save_check) and rawget(_G, "SaveGameBugReport") then
      attach_autosave = container.idLastAutosave and container.idLastAutosave:GetCheck()
      if attach_autosave and g_LastAutosaveFilename then
        if Platform.console then
          bug_autosave_filename = string.format("%s/%s", self.tempdir, g_LastAutosaveFilename)
          local err = Savegame.Export(g_LastAutosaveFilename, bug_autosave_filename)
          if err then
            bug_autosave_filename = nil
          end
        else
          if Platform.pc then
            bug_autosave_filename = GetPCSaveFolder() .. g_LastAutosaveFilename
          else
          end
        end
      end
      attach_save = can_save and container.idSaveGame:GetCheck()
      if attach_save then
        local display_name = os.date("Bug %Y-%m-%d %H.%M.%S")
        local savepath
        local msg = CreateMessageBox(self, T(273706464856, "Bug report"), T(646010194429, "Saving, please wait..."), T(325411474155, "OK"))
        msg:PreventClose()
        Sleep(100)
        local err, savegame_pstr = SaveGameBugReportPStr(display_name)
        if err then
          print("Bug report savegame error: ", err)
        end
        bug_save_filename = display_name .. string.format(" %s ", LuaRevision) .. string.gsub(summary, "[/?<>\\:*|\"]", "_") .. ".savegame.sav"
        bug_save_pstr = savegame_pstr
        msg:Close()
      end
    end
    local msg = CreateMessageBox(self, T(273706464856, "Bug report"), T(968163992960, "Sending bug report, please wait..."), T(325411474155, "OK"))
    msg:PreventClose()
    local orig_log = extra_info and GetLogFile()
    local bug_data = {
      reporter = reporter_token,
      tags = tags,
      image = dest_filename,
      log = orig_log,
      autosave = bug_autosave_filename,
      save = bug_save_filename,
      save_pstr = bug_save_pstr,
      handler = handler,
      project = Platform.ged and g_GedApp.mantis_project_id or const.MantisProjectID or 9,
      category = category,
      appendToBug = appendToBug,
      summary = is_level_designer and string.format("(%s) %s", GetMap(), summary) or summary,
      description = description,
      extra_info = extra_info,
      note = note,
      priority = priority,
      severity = severity,
      reproducibility = reproducibility,
      target_version = target_version,
      files = self.file_attachments
    }
    DebugPrint("-----------------------------------------------------------------------------------\n")
    FlushLogFile()
    local new_log
    if orig_log and orig_log ~= "" then
      local dir, name, ext = SplitPath(orig_log)
      new_log = string.format("%s/%s.txt", self.tempdir, name)
    end
    if new_log and not AsyncCopyFile(orig_log, new_log) and extra_info then
      bug_data.log = new_log
    end
    local failed, url = ReportBug(bug_data)
    msg:Close()
    Msg("BugReportResult", failed)
    if failed then
      WaitMessage(self, T(273706464856, "Bug report"), T({
        619000999242,
        [[
Sending bug report failed:
<u(http_error_code)>.]],
        http_error_code = failed
      }), T(325411474155, "OK"), self)
    else
      if attach_save or attach_autosave then
        LocalStorage.BugAttachAutosave = attach_autosave
        LocalStorage.BugAttachSave = attach_save
        SaveLocalStorageDelayed()
      end
      local copy_url_button = not Platform.console and url
      if const.MantisCopyUrlButton ~= nil and copy_url_button then
        copy_url_button = const.MantisCopyUrlButton
      end
      if copy_url_button then
        local resp = WaitQuestion(self, T(273706464856, "Bug report"), T(128433133976, "Bug report sent successfully."), T(325411474155, "OK"), T(632653390877, "Copy URL"), self)
        if resp == "cancel" then
          CopyToClipboard(url)
        end
      else
        WaitMessage(self, T(273706464856, "Bug report"), T(128433133976, "Bug report sent successfully."), T(325411474155, "OK"), self)
      end
    end
    if not failed then
      self:Close()
    end
    sendButton:SetEnabled(true)
  end)
end
function XBugReportDlg:ScreenshotDrawOn()
  local buttonDown = false
  local last_pt = false
  local container = self.idScrollArea
  function container.idScreenshot.OnMouseButtonDown(_, pt, button)
    container.idScreenshotText:SetVisible(false)
    if button == "R" then
      self.scribble = false
      self:Invalidate()
      return "break"
    elseif button == "L" then
      buttonDown = true
      pt = pt - container.idScreenshot.box:min()
      if not self.scribble then
        self.scribble = {
          {pt}
        }
      else
        self.scribble[1 + #self.scribble] = {pt}
      end
      last_pt = pt
      self.desktop:SetMouseCapture(container.idScreenshot)
    end
    return "break"
  end
  function container.idScreenshot.OnMouseButtonUp(_, pt, button)
    if button == "L" then
      buttonDown = false
      self.desktop:SetMouseCapture()
      return "break"
    end
  end
  function container.idScreenshot.OnMousePos(_, pt)
    if buttonDown and self.scribble then
      local bbox = container.idScreenshot.box
      pt = ClampPoint(pt, bbox)
      pt = pt - bbox:min()
      if pt:Dist2D(last_pt) > 5 then
        local last_scribble = self.scribble[#self.scribble]
        last_scribble[1 + #last_scribble] = pt
        last_pt = pt
        self:Invalidate()
      end
    end
  end
  function container.idScreenshot.DrawContent(img)
    XImage.DrawContent(img)
    if self.scribble then
      local ptS0 = img.box:min()
      local ptS1 = img.box:min() + point(1, 1)
      for i = 1, #self.scribble do
        local polyline = self.scribble[i]
        if 2 < #polyline then
          for j = 2, #polyline do
            UIL.DrawLine(ptS1 + polyline[j - 1], ptS1 + polyline[j], RGB(0, 0, 0))
            UIL.DrawLine(ptS0 + polyline[j - 1], ptS0 + polyline[j], RGB(255, 0, 0))
          end
        end
      end
    end
  end
end
function XBugReportDlg:HideComboWindow(combo_id)
  local combo_container = self.idScrollArea:ResolveId("idComboContainer")
  if combo_container then
    local combo = combo_container:ResolveId(combo_id)
    if not combo then
      return
    end
    local window = combo:GetParent()
    window:SetVisible(false)
    window:SetDock("ignore")
  end
end
function XBugReportDlg:InitControls()
  local container = self.idScrollArea
  if Platform.developer and container.idAssignTo then
    function container.idAssignTo.OnValueChanged(this, value)
      local member = HGMembers and HGMembers[value]
      if not member then
        return
      end
      local group = member.group
      if group == "Level Design" then
        container.idCategory:SetValue("Maps")
      elseif group == "Code" then
        container.idCategory:SetValue("Code")
      elseif group == "Art" then
        if member.Animation then
          container.idCategory:SetValue("Animation")
        else
          container.idCategory:SetValue("Art")
        end
      elseif group == "Design" then
        container.idCategory:SetValue("Design")
      end
    end
  end
  if not Platform.developer or not insideHG() then
    if container.idComboContainer then
      self:HideComboWindow("idReporter")
      self:HideComboWindow("idAssignTo")
      self:HideComboWindow("idCategory")
      self:HideComboWindow("idTargetVersion")
    end
    if container.idExtraInfo then
      container.idExtraInfo:SetVisible(false)
      container.idExtraInfo:SetDock("ignore")
    end
    if container.idScreenshotCheck then
      container.idScreenshotCheck:SetVisible(false)
      container.idScreenshotCheck:SetDock("ignore")
    end
    if container.idAssignTo then
      container.idAssignTo:SetValue(" ")
    end
  else
    if container.idComboContainer then
      self:HideComboWindow("idSeverity")
      self:HideComboWindow("idReproducibility")
    end
    if container.idAPIToken then
      container.idAPIToken:GetParent():SetVisible(false)
      container.idAPIToken:GetParent():SetDock("ignore")
    end
  end
  local oldOnTextChanged = container.idSummary.OnTextChanged
  function container.idSummary.OnTextChanged(this)
    local sendButton = self:GetSendButtonControl()
    sendButton:SetEnabled(container.idSummary:GetText() ~= "")
    return oldOnTextChanged(this)
  end
  local ctrlSave = container.idSaveGame
  if ctrlSave then
    ctrlSave:SetCheck(Platform.goldmaster or LocalStorage.BugAttachSave)
    ctrlSave:SetEnabled((not Platform.goldmaster or not Platform.asserts) and CanSaveGame())
    ctrlSave:SetText(config.CustomAttachSavegameText or ctrlSave.Translate and T(950219570922, "Attach savegame") or "Attach savegame")
  end
  if container.idLastAutosave then
    container.idLastAutosave:SetCheck(Platform.goldmaster or LocalStorage.BugAttachAutosave)
    container.idLastAutosave:SetEnabled(not Platform.goldmaster and g_LastAutosaveFilename)
  end
  local sendButton = self:GetSendButtonControl()
  function sendButton.OnPress(this)
    self:Report()
  end
  ForceShowMouseCursor("bug report")
end
function XBugReportDlg:Done()
  UnforceShowMouseCursor("bug report")
  Msg("BugReportEnd")
end
function XBugReportDlg:FillReport(screenshot)
  local container = self.idScrollArea
  local ctrlScreenshot = container:ResolveId("idScreenshot")
  local HideCheckBox = function(id)
    local ctrl = container:ResolveId(id)
    if ctrl then
      ctrl:SetCheck(false)
      ctrl:SetVisible(false)
    end
  end
  local params = self.report_params or empty_table
  if params.no_extra_info then
    HideCheckBox("idExtraInfo")
    HideCheckBox("idSaveGame")
    HideCheckBox("idLastAutosave")
    HideCheckBox("idScreenshotCheck")
    ctrlScreenshot:SetVisible(false)
  elseif not params.no_screenshot and screenshot then
    ctrlScreenshot:SetImage(screenshot)
  else
    HideCheckBox("idScreenshotCheck")
    ctrlScreenshot:SetVisible(false)
  end
  if params.no_platform_tags then
    self:HideComboWindow("idPlatformTagsLabel")
  end
  if not LocalStorage.dlgBugReport then
    LocalStorage.dlgBugReport = {}
  end
  local users = {}
  ForEachPreset("HGMember", function(preset, group, users)
    table.insert(users, preset.id)
  end, users)
  table.sort(users, CmpLower)
  local items = {}
  local reporter_token, reporter_name
  if container.idAPIToken and container.idAPIToken:GetVisible() then
    reporter_token = AccountStorage and AccountStorage.MantisToken
  end
  if not reporter_token then
    reporter_token, reporter_name = GetReporter()
  else
    container.idAPIToken:SetText(reporter_token)
  end
  local reporter = reporter_token and reporter_name
  if reporter then
    table.insert(items, reporter)
  end
  for i = 1, #users do
    local user = users[i]
    if user ~= reporter then
      table.insert(items, user)
    end
  end
  if container.idReporter then
    container.idReporter:SetItems(items)
    container.idReporter:SetValue(reporter_name)
  end
  if container.idCategory and const.Categories then
    container.idCategory:SetItems(const.Categories)
    container.idCategory:SetValue(params.category or LocalStorage.dlgBugReport.category or const.Categories[const.DefaultCategory])
  end
  table.insert(items, 1, {name = " ", id = " "})
  local map_author = mapdata and mapdata.Author
  if map_author then
    table.insert(items, 2, {
      name = map_author .. " (map author)",
      id = map_author
    })
  end
  if container.idAssignTo then
    container.idAssignTo:SetItems(items)
    container.idAssignTo:SetValue(LocalStorage.dlgBugReport.handler or " ")
  end
  if container.idPriority then
    if params.no_priority then
      self:HideComboWindow("idPriority")
    end
    container.idPriority:SetItems(const.BugPriorityNames)
    container.idPriority:SetValue(params.priority or const.DefaultBugPriority or "normal")
  end
  if container.idSeverity then
    container.idSeverity:SetItems(const.BugSeverityNames)
    container.idSeverity:SetValue(params.severity or const.DefaultBugSeverity or "minor")
  end
  if container.idReproducibility then
    container.idReproducibility:SetItems(const.BugReproducibilityNames)
    container.idReproducibility:SetValue(const.DefaultBugReproducibility or "have not tried")
  end
  if container.idTargetVersion then
    if const.TargetVersions then
      local items = {
        {id = "", name = ""}
      }
      for i = 1, #const.TargetVersions do
        local version = const.TargetVersions[i]
        items[#items + 1] = {id = version, name = version}
      end
      container.idTargetVersion:SetItems(items)
      if not table.find(items, "name", LocalStorage.dlgBugReport.target_version) then
        LocalStorage.dlgBugReport.target_version = ""
      end
      container.idTargetVersion:SetValue(LocalStorage.dlgBugReport.target_version or const.DefaultTargetVersion)
    else
      container.idTargetVersion:SetVisible(false)
    end
  end
  container.idSummary:SetText(self.init_summary or "")
  container.idDescription:SetText(self.init_descr or "")
  local sendButton = self:GetSendButtonControl()
  sendButton:SetEnabled(self.init_summary and self.init_descr)
  if params.summary_readonly and self.init_summary then
    container.idSummary:SetEnabled(false)
    container.idSummary.OnTextChanged = nil
    sendButton:SetEnabled(true)
  end
  if Platform.asserts and not self.init_summary then
    local TryFillError = function(assert_format, error_msg, error_time)
      local valid
      if error_time and error_msg and error_msg ~= "" then
        local elapsed = RealTime() - error_time
        valid = 0 <= elapsed and elapsed < 10000
      end
      if not valid then
        return
      end
      local hash = xxhash(error_msg, error_time)
      if hash == self.last_report_error_hash then
        return
      end
      self.last_report_error_hash = hash
      local info = error_msg
      local idx = string.find(info, [[


]], 1, true)
      if idx then
        info = string.sub(info, 1, idx - 1)
      end
      local idx1, idx2 = string.find(info, ":%d+: ")
      if idx2 then
        info = string.sub(info, idx2)
      else
        idx1, idx2 = string.find(info, "%(%d+%): ")
        if idx2 then
          info = string.sub(info, idx2)
        end
      end
      if 40 < #info then
        local i1 = string.find(info, "\n", 20, true)
        local i2 = string.find(info, ". ", 20, true)
        local i = i1 and i2 and Min(i1, i2) or i1 or i2
        if i then
          info = string.sub(info, 1, i - 1)
        else
          info = string.sub(info, 1, 60) .. "..."
        end
      end
      self.report_params = self.report_params or {}
      self.report_params.tags = table.create_add(self.report_params.tags, "Assert")
      container.idSummary:SetText(string.format(assert_format, info))
      container.idDescription:SetText(error_msg)
      return true
    end
    local assert_format = "[Assert] %s"
    local error_msg, error_time = GetLastError()
    if Platform.ged then
      local error_msg2, error_time2 = g_GedApp:GetGameError()
      if error_msg2 and (not error_msg or error_time < error_time2) then
        error_msg, error_time = error_msg2, error_time2
        assert_format = "[Game Assert] %s"
      end
      assert_format = "[Ged] " .. assert_format
    end
    if not TryFillError(assert_format, error_msg, error_time) then
      local MarkedErrors = rawget(_G, "MarkedErrors")
      local vme = MarkedErrors and MarkedErrors[#MarkedErrors]
      if vme and vme.report_time then
        error_msg = vme.msg .. [[


Source: ]] .. ValueToStr(vme.source)
        error_time = vme.report_time
        assert_format = "[VME] %s"
        TryFillError(assert_format, error_msg, error_time)
      end
    end
  end
end
function XBugReportDlg:ShowReport(screenshot)
  local container = self.idScrollArea
  self:FillReport(screenshot)
  self:SetModal()
  if self.FocusSummaryOnOpen then
    container.idSummary:SetFocus()
    container.idSummary:SelectAll()
  end
end
function XBugReportDlg:OnShortcut(shortcut, source, ...)
  local container = self.idScrollArea
  if shortcut == "ButtonB" or shortcut == "Escape" then
    self:Close()
    return "break"
  elseif shortcut == "Enter" or shortcut == "Ctrl-Enter" then
    local sendButton = self:GetSendButtonControl()
    if sendButton:GetEnabled() then
      self:Report()
    end
    return "break"
  end
  return XDialog.OnShortcut(self, shortcut, source, ...)
end
local CreateScreenshot = function(screendir)
  local filename
  local i = 1
  while true do
    local name = string.format("%s/BugReport%04d.png", screendir, i)
    if not io.exists(name) then
      filename = name
      break
    end
    i = i + 1
  end
  local oldInterfaceInScreenshot = hr.InterfaceInScreenshot
  hr.InterfaceInScreenshot = 1
  local error = "init"
  local size = UIL.GetScreenSize()
  if WriteScreenshot(filename, size:x(), size:y(), box(point20, size), 75) then
    while true do
      local finished, err = ScreenshotWritten()
      if finished or err then
        error = err
        break
      end
      _G.Sleep(100)
    end
  end
  hr.InterfaceInScreenshot = oldInterfaceInScreenshot
  if error then
    print("Failed to create screenshot \"%s\": %s", filename, error)
  end
  return filename
end
if FirstLoad then
  l_bug_report_counter = 0
end
function CreateXBugReportDlg(summary, descr, files, params)
  local template_id = config.BugReporterXTemplateID
  local dlg = GetDialog(template_id)
  if dlg then
    return
  end
  local lua_load_pct = GetLuaLoadPct()
  Msg("CreateXBugReportDlg")
  WaitNextFrame(2)
  local success, err = io.createpath(tempdir)
  if not success then
    print("Failed to create a temp folder for bug report:", err)
    tempdir = ""
  end
  local no_screenshot = params and params.no_screenshot
  local screenshot = not no_screenshot and CreateScreenshot(tempdir)
  dlg = OpenDialog(template_id)
  dlg.init_summary = summary
  dlg.init_descr = descr
  dlg.file_attachments = files or false
  dlg.report_params = params
  local prints = {}
  local bug_print = function(...)
    prints[#prints + 1] = print_format(...)
  end
  for k, v in sorted_pairs(GamepadUIStyle) do
    bug_print("GamepadUIStyle:", k, v)
  end
  if not config.DisableOptions then
    bug_print("Local Options:", TableToLuaCode(EngineOptions, " "))
    if AccountStorage then
      bug_print("Account Options:", TableToLuaCode(AccountStorage.Options, " "))
    end
    bug_print(string.format([[

Options: (paste in the console)
%s]], GetOptionsString()))
    bug_print("")
  end
  if 0 < lua_load_pct then
    bug_print("Lua Load:", lua_load_pct, "%")
  end
  Msg("BugReportStart", bug_print, dlg)
  dlg.tempdir = tempdir
  dlg.game_specific_info = table.concat(prints, "\n")
  dlg:ShowReport(screenshot)
  return dlg
end
function WaitXBugReportDlg(summary, descr, files, params)
  local dlg
  while true do
    dlg = dlg or CreateXBugReportDlg(summary, descr, files, params)
    if WaitMsg("BugReportEnd", 10000) and dlg then
      break
    end
  end
end
function CloseXBugReportDlg()
  CloseDialog(config.BugReporterXTemplateID)
end
