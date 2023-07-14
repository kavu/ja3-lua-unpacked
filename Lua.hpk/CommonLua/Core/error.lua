MessageText = {}
MessageTitle = {}
MessageTemplate = {}
function AddMessageContext(context, ...)
  if not context then
    return
  end
  MessageText[context] = MessageText[context] or {}
  MessageTitle[context] = MessageTitle[context] or {}
  MessageTemplate[context] = MessageTemplate[context] or {}
  return AddMessageContext(...)
end
MessageTitle.Generic = T(634182240966, "Error")
MessageTitle.Warning = T(824112417429, "Warning")
MessageText.Generic = T(463126936264, "An error has occurred: \"<err>/<context>\"")
MessageText.DlcRequiresUpdate = T(519529788732, "Some downloadable content requires a game update in order to work.")
MessageText["File is corrupt"] = T(631831331619, "File is corrupted.")
MessageText["File Not Found"] = T(950959678764, "File not found.")
MessageText["Mount Not Found"] = T(639145562955, "Mount not found.")
MessageText["Access Denied"] = T(157438408284, "Access denied.")
MessageText["Invalid Parameter"] = T(311342666009, "Invalid parameter.")
MessageText["Allocation Error"] = T(932157256532, "Out of memory.")
MessageText["A file of the same name exists"] = T(493581690114, "File already exists.")
MessageText["Savegame not initialized"] = T(320309712530, "Storage is not initialized.")
MessageText["Savegame busy"] = T(843835835267, "Storage is busy.")
MessageText["Savegame fingerprint mismatch"] = T(462819971888, "Storage fingerprint mismatch.")
MessageText["Savegame internal"] = T(686870623950, "Savegame internal error.")
MessageText["Savegame mount full"] = T(557131064264, "Storage mount is full.")
MessageText["Savegame bad mounted"] = T(147878217218, "Faulty storage mount.")
MessageText["Savegame invalid login user"] = T(739959355591, "Invalid storage user.")
MessageText["Savegame memory not ready"] = T(850329789527, "Storage memory is not ready.")
MessageText["Savegame not mounted"] = T(166996754616, "Storage is not mounted.")
AddMessageContext("account save")
MessageTitle["account save"].Generic = MessageTitle.Warning
MessageText["account save"].Generic = T(392924077757, "Failed to save your settings")
MessageText["account save"]["Disk Full"] = T(477874811467, "There is not enough storage space. To save your settings, free storage space.")
MessageText["account save"]["Save Storage Full"] = T(947319053929, "The save data limit for this game was reached. To save your settings, delete old save data.")
AddMessageContext("account load")
MessageTitle["account load"].Generic = MessageTitle.Warning
MessageText["account load"].Generic = T(704174513880, "Failed to load your settings.")
MessageText["account load"]["File is corrupt"] = T(832314654091, "Failed to load game settings. The saved data is corrupted. This saved data will be deleted and new saved data will be created.")
AddMessageContext("savegame")
MessageTitle.savegame.Generic = T(606901390406, "Save Failed")
MessageText.savegame.Generic = T(408428310307, "Unidentified error while saving <savename>!<newline>Error code: <error_code>")
MessageText.savegame["Disk Full"] = T(269487733043, "There is not enough storage space. To save your progress, free storage space.")
MessageText.savegame["Save Storage Full"] = T(758106651114, "The save data limit for this game was reached. To save your progress, delete old save data.")
MessageText.savegame["Out Of Local Storage"] = T(898462935482, "The local storage of this console is full. To save your progress, free storage space.")
MessageText.savegame["Xblive Sync Failed"] = T(293964617315, "There has been a problem with connecting to the cloud savegame storage at this time.")
AddMessageContext("loadgame")
MessageTitle.loadgame.Generic = T(307531266745, "Load Failed")
MessageText.loadgame.Generic = T(209917042810, "Could not load <name>.")
MessageText.loadgame["File is corrupt"] = T(620584534835, "Could not load <name>.<newline>The savegame is corrupted.")
MessageText.loadgame.incompatible = T(117116727535, "Please update the game to the latest version to load this savegame.")
MessageText.loadgame.corrupt = T(726428638755, "The savegame is corrupted.")
MessageText.loadgame["Xblive Sync Failed"] = T(293964617315, "There has been a problem with connecting to the cloud savegame storage at this time.")
AddMessageContext("deletegame")
MessageTitle.deletegame.Generic = MessageTitle.Warning
MessageText.deletegame.Generic = T(109901281893, "Unable to delete <name>")
function GetErrorText(err, context, obj)
  err = tostring(err or "no err")
  context = tostring(context or "unknown")
  local tcontext = MessageText[context]
  local text = tcontext and tcontext[err] or MessageText[err]
  if text then
    return type(text) == "function" and text() or text
  end
  text = tcontext and tcontext.Generic or MessageText.Generic
  if not text then
    return ""
  end
  return T({
    text,
    obj,
    err = Untranslated(err),
    context = Untranslated(context)
  })
end
function GetErrorTitle(err, context)
  err = tostring(err or "no err")
  context = tostring(context or "unknown")
  local tcontext = MessageTitle[context]
  local text = tcontext and tcontext[err] or MessageTitle[err]
  if text then
    return text
  end
  return tcontext and tcontext.Generic or MessageTitle.Generic or ""
end
function GetErrorTemplate(err, context)
  err = tostring(err or "no err")
  context = tostring(context or "unknown")
  local tcontext = MessageTemplate[context]
  local template = tcontext and tcontext[err] or MessageTemplate[err]
  if template then
    return template
  end
  return tcontext and tcontext.Generic or MessageTemplate.Generic or ""
end
function CreateErrorMessageBox(err, context, ok_text, parent, obj)
  RecordError("msg", err, context)
  return CreateMessageBox(parent, GetErrorTitle(err, context), GetErrorText(err, context, obj), ok_text, obj, GetErrorTemplate(err, context))
end
function WaitErrorMessage(err, context, ok_text, parent, obj)
  RecordError("msg", err, context)
  return WaitMessage(parent or terminal.desktop, GetErrorTitle(err, context), GetErrorText(err, context, obj), ok_text, obj, GetErrorTemplate(err, context))
end
function RecordError(action, err, context)
  if Platform.ged then
    return
  end
  local stack = GetStack(2) or "(no stack)"
  action = tostring(action or "unknown")
  err = tostring(err or "no err")
  context = tostring(context or "unknown")
  NetRecord("err-" .. action, err, context, stack)
  DebugPrint(string.format([[
err-%s: %s (%s)
%s
]], action, err, context, stack))
  printf("err-%s: %s (%s)", action, err, context)
end
function IgnoreError(err, context)
  RecordError("ignore", err, context)
end
