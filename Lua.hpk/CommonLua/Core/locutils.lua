if FirstLoad then
  g_LipSyncData = {}
end
function GetVoiceFilename(T, seed)
  if not T then
    return
  end
  local id = TGetID(T)
  if not id then
    return
  end
  if g_VoiceVariations then
    local all_vars = g_VoiceVariations[id] or g_VoiceVariations[tostring(id)]
    if all_vars and 0 < #all_vars then
      local var = 1 + (seed and BraidRandom(seed, #all_vars) or AsyncRand(#all_vars))
      return all_vars[var]
    end
  end
  local not_robot_voice = "CurrentLanguage/Voices/" .. id
  if not config.VoicesTTS or not GetAccountStorageOptionValue("VoicesTTS") then
    return not_robot_voice
  end
  if GetSoundDuration(not_robot_voice) then
    return not_robot_voice
  end
  local robo_voice = "CurrentLanguage/VoicesTTS/" .. id
  if io.exists(robo_voice .. ".opus") then
    return robo_voice
  end
end
function VoiceSampleByText(T, actor, pathName)
  local id = TGetID(T)
  if not id then
    return false
  end
  local sample
  if actor == "male" then
    sample = pathName or "CurrentLanguage/Voices/Male/" .. id
  elseif actor == "female" then
    sample = pathName or "CurrentLanguage/Voices/Female/" .. id
  elseif actor and actor ~= "" and actor ~= "narrator" then
    sample = string.concat(pathName or "CurrentLanguage/Voices/", not pathName and actor or "", "/", id)
  else
    sample = pathName or "CurrentLanguage/Voices/" .. id
  end
  if not io.exists(sample .. ".opus") then
    sample = GetVoiceFilename(T)
  end
  return sample
end
function VoicedContextFromField(field, annotation, voiced_prop, annotation_prop)
  return function(obj, prop_meta, parent)
    if type(field) == "table" then
      for i = 1, #field do
        if obj[field[i]] and obj[field[i]] ~= "" then
          field = field[i]
          break
        end
      end
    end
    local extra_annotation = annotation_prop and obj[annotation_prop]
    if IsT(extra_annotation) then
      extra_annotation = _InternalTranslate(extra_annotation)
    end
    if (not voiced_prop or obj[voiced_prop]) and obj[field] then
      if annotation and extra_annotation then
        return string.format("%s %s voice:%s", annotation, extra_annotation, obj[field])
      elseif annotation or extra_annotation then
        return string.format("%s voice:%s", annotation or extra_annotation, obj[field])
      else
        return string.format("voice:%s", obj[field])
      end
    else
      return annotation and extra_annotation and annotation .. " " .. extra_annotation or annotation or extra_annotation or ""
    end
  end
end
function GenerateLocalizationIDs(obj)
  if not obj then
    return
  end
  if PropObjHasMember(obj, "GetProperties") then
    local props = obj:GetProperties()
    for i = 1, #props do
      local prop = props[i]
      local id = prop.id
      if prop.translate then
        local value = obj:GetProperty(id)
        if IsT(value) and not obj:IsDefaultPropertyValue(id, prop, value) then
          obj:SetProperty(id, T({
            RandomLocId(),
            TDevModeGetEnglishText(value)
          }))
        end
      end
      local editor = prop.editor
      if editor == "T_list" and not obj:IsDefaultPropertyValue(id, prop, value) then
        local tlist = obj:GetProperty(id)
        for idx, text in ipairs(tlist) do
          tlist[idx] = T({
            RandomLocId(),
            TDevModeGetEnglishText(text)
          })
        end
      elseif editor == "nested_obj" then
        GenerateLocalizationIDs(obj:GetProperty(id))
      elseif editor == "nested_list" then
        for _, subobj in ipairs(obj:GetProperty(id)) do
          GenerateLocalizationIDs(subobj)
        end
      end
    end
  end
  for i = 1, #obj do
    GenerateLocalizationIDs(obj[i], true)
  end
  return obj
end
g_TestUIPlatform = false
const.XboxToPlayStationButtons = {
  ButtonA = const.PlayStationEnterBtnCircle and "Circle" or "Cross",
  ButtonB = const.PlayStationEnterBtnCircle and "Cross" or "Circle",
  ButtonY = "Triangle",
  ButtonX = "Square",
  LT = "L2",
  RT = "R2",
  LS = "L",
  RS = "R",
  LSPress = "L3",
  RSPress = "R3",
  LB = "L1",
  RB = "R1",
  Start = "Options",
  Back = "TouchPad"
}
const.ShortenedButtonNames = {
  LeftTrigger = "LT",
  RightTrigger = "RT",
  LeftShoulder = "LB",
  RightShoulder = "RB",
  RightThumbClick = "RSPress",
  LeftThumbClick = "LSPress"
}
local RecreateButtonsTagLookupTable = function()
  const.TagLookupTable.ButtonA = GetPlatformSpecificImageTag("ButtonA")
  const.TagLookupTable.ButtonB = GetPlatformSpecificImageTag("ButtonB")
  const.TagLookupTable.ButtonX = GetPlatformSpecificImageTag("ButtonX")
  const.TagLookupTable.ButtonY = GetPlatformSpecificImageTag("ButtonY")
  const.TagLookupTable.DPad = GetPlatformSpecificImageTag("DPad")
  const.TagLookupTable.DPadUp = GetPlatformSpecificImageTag("DPadUp")
  const.TagLookupTable.DPadDown = GetPlatformSpecificImageTag("DPadDown")
  const.TagLookupTable.DPadLeft = GetPlatformSpecificImageTag("DPadLeft")
  const.TagLookupTable.DPadRight = GetPlatformSpecificImageTag("DPadRight")
  const.TagLookupTable.DPadUpDown = GetPlatformSpecificImageTag("DPad_Up_Down")
  const.TagLookupTable.DPadLeftRight = GetPlatformSpecificImageTag("DPad_Left_Right")
  const.TagLookupTable.LT = GetPlatformSpecificImageTag("LT")
  const.TagLookupTable.RT = GetPlatformSpecificImageTag("RT")
  const.TagLookupTable.LeftTrigger = GetPlatformSpecificImageTag("LT")
  const.TagLookupTable.RightTrigger = GetPlatformSpecificImageTag("RT")
  const.TagLookupTable.LS = GetPlatformSpecificImageTag("LS")
  const.TagLookupTable.RS = GetPlatformSpecificImageTag("RS")
  const.TagLookupTable.LSPress = GetPlatformSpecificImageTag("LSPress")
  const.TagLookupTable.RSPress = GetPlatformSpecificImageTag("RSPress")
  const.TagLookupTable.LB = GetPlatformSpecificImageTag("LB")
  const.TagLookupTable.RB = GetPlatformSpecificImageTag("RB")
  const.TagLookupTable.Start = GetPlatformSpecificImageTag("Start")
  const.TagLookupTable.Back = GetPlatformSpecificImageTag("Back")
  const.TagLookupTable.lsupdown = GetPlatformSpecificImageTag("ls_up_down")
  const.TagLookupTable.lsright = GetPlatformSpecificImageTag("lsright")
  const.TagLookupTable.lsleft = GetPlatformSpecificImageTag("lsleft")
  const.TagLookupTable.lsup = GetPlatformSpecificImageTag("lsup")
  const.TagLookupTable.lsdown = GetPlatformSpecificImageTag("lsdown")
  const.TagLookupTable.rsupdown = GetPlatformSpecificImageTag("rs_up_down")
  const.TagLookupTable.rsright = GetPlatformSpecificImageTag("rsright")
  const.TagLookupTable.rsleft = GetPlatformSpecificImageTag("rsleft")
  const.TagLookupTable.rsup = GetPlatformSpecificImageTag("rsup")
  const.TagLookupTable.rsdown = GetPlatformSpecificImageTag("rsdown")
  const.TagLookupTable.RightThumbUp = GetPlatformSpecificImageTag("rsup")
  const.TagLookupTable.RightThumbDown = GetPlatformSpecificImageTag("rsdown")
end
if Platform.pc then
  function UpdateActiveControllerType()
    if not (rawget(_G, "XInput") and IsXInputControllerConnected()) or not ActiveController then
      return
    end
    local previous = g_PCActiveControllerType
    g_PCActiveControllerType = XInput.GetControllerType(ActiveController) or false
    if g_PCActiveControllerType ~= previous then
      RecreateButtonsTagLookupTable()
      Msg("OnControllerTypeChanged", g_PCActiveControllerType)
    end
  end
  OnMsg.XInputInitialized = UpdateActiveControllerType
  OnMsg.ActiveControllerUpdated = UpdateActiveControllerType
  if FirstLoad then
    g_PCActiveControllerType = false
  end
  function GetPCActiveControllerType()
    return g_PCActiveControllerType
  end
else
  function GetPCActiveControllerType()
  end
end
function ShouldShowPS4Images()
  return Platform.ps4 or g_TestUIPlatform == "ps4" or not g_TestUIPlatform and GetPCActiveControllerType() == "ps4"
end
function ShouldShowPS5Images()
  return Platform.ps5 or g_TestUIPlatform == "ps5" or not g_TestUIPlatform and GetPCActiveControllerType() == "ps5"
end
function GetPlatformSpecificImagePath(btn)
  btn = const.ShortenedButtonNames[btn] or btn
  local path = "UI/DesktopGamepad/"
  local ext = ".tga"
  local btnimg = btn
  if ShouldShowPS4Images() then
    path = "UI/PS4/"
    btnimg = const.XboxToPlayStationButtons[btn] or btn
  elseif ShouldShowPS5Images() then
    path = "UI/PS5/"
    btnimg = const.XboxToPlayStationButtons[btn] or btn
  elseif Platform.xbox or g_TestUIPlatform == "xbox" then
    path = "UI/Xbox/"
  else
    if Platform.switch or g_TestUIPlatform == "switch" or GetPCActiveControllerType() == "switch" then
      path = "UI/Switch/"
    else
    end
  end
  return path .. btnimg .. ext, 500
end
function GetPlatformSpecificImageTag(btn, scale)
  btn = const.ShortenedButtonNames[btn] or btn
  local path = "UI/DesktopGamepad/"
  local btnimg = btn
  if ShouldShowPS4Images() then
    path = "UI/PS4/"
    btnimg = const.XboxToPlayStationButtons[btn] or btn
  elseif ShouldShowPS5Images() then
    path = "UI/PS5/"
    btnimg = const.XboxToPlayStationButtons[btn] or btn
  elseif Platform.xbox or g_TestUIPlatform == "xbox" then
    path = "UI/Xbox/"
  else
    if Platform.switch or g_TestUIPlatform == "switch" then
      path = "UI/Switch/"
    else
    end
  end
  if scale then
    return string.format("<image %s%s.tga %d>", path, btnimg, tonumber(scale) or 1000)
  else
    return string.format("<image %s%s.tga>", path, btnimg)
  end
end
OnMsg.XInputInitialized = RecreateButtonsTagLookupTable
RecreateButtonsTagLookupTable()
const.TagLookupTable.tm = Untranslated("\226\132\162")
const.TagLookupTable.copyright = Untranslated("\194\169")
const.TagLookupTable.registered = Untranslated("\194\174")
const.TagLookupTable.nbsp = Untranslated("\194\160")
local replace_map = {
  ["`"] = "'",
  ["\226\128\152"] = "'",
  ["\226\128\153"] = "'",
  ["\226\128\156"] = "\"",
  ["\226\128\157"] = "\"",
  ["\226\128\147"] = "-",
  ["\226\128\148"] = "-",
  ["\226\136\146"] = "-",
  ["\226\128\166"] = "..."
}
function ReplaceNonStandardCharacters(s)
  for k, v in pairs(replace_map) do
    s = s:gsub(k, v)
  end
  return s
end
changed = {}
function FixupPresetTs()
  local count = 0
  local validation_start = GetPreciseTicks()
  PauseInfiniteLoopDetection("FixupPresetTs")
  local eval = prop_eval
  local dirty = {}
  for class_name, presets in pairs(Presets) do
    for _, group in ipairs(presets) do
      for _, preset in ipairs(group) do
        preset:ForEachSubObject(function(obj)
          for _, prop in ipairs(obj:GetProperties()) do
            if prop.editor == "text" and eval(prop.translate, obj, prop) then
              local t = obj:GetProperty(prop.id)
              if t and t ~= "" then
                local id, text = TGetID(t) or RandomLocId(), TDevModeGetEnglishText(t)
                local new_text = ReplaceNonStandardCharacters(text)
                if text ~= new_text then
                  obj:SetProperty(prop.id, T(id, new_text))
                  table.insert(changed, preset.class .. " " .. new_text)
                  dirty[class_name] = true
                  count = count + 1
                end
              end
            end
          end
        end)
      end
    end
  end
  for class_name in pairs(dirty) do
    _G[class_name]:SaveAll("force save all")
  end
  ResumeInfiniteLoopDetection("FixupPresetTs")
  CreateMessageBox(nil, Untranslated("Fixup Ts"), Untranslated(string.format("Changed a total of %d texts for %d ms", count, GetPreciseTicks() - validation_start)))
end
local diacritics_map = {
  ["\195\128"] = "A",
  ["\195\129"] = "A",
  ["\195\130"] = "A",
  ["\195\131"] = "A",
  ["\195\132"] = "A",
  ["\195\133"] = "A",
  ["\195\134"] = "AE",
  ["\195\135"] = "C",
  ["\195\136"] = "E",
  ["\195\137"] = "E",
  ["\195\138"] = "E",
  ["\195\139"] = "E",
  ["\195\140"] = "I",
  ["\195\141"] = "I",
  ["\195\142"] = "I",
  ["\195\143"] = "I",
  ["\195\144"] = "D",
  ["\195\145"] = "N",
  ["\195\146"] = "O",
  ["\195\147"] = "O",
  ["\195\148"] = "O",
  ["\195\149"] = "O",
  ["\195\150"] = "O",
  ["\195\152"] = "O",
  ["\195\153"] = "U",
  ["\195\154"] = "U",
  ["\195\155"] = "U",
  ["\195\156"] = "U",
  ["\195\157"] = "Y",
  ["\195\158"] = "P",
  ["\195\159"] = "s",
  ["\195\160"] = "a",
  ["\195\161"] = "a",
  ["\195\162"] = "a",
  ["\195\163"] = "a",
  ["\195\164"] = "a",
  ["\195\165"] = "a",
  ["\195\166"] = "ae",
  ["\195\167"] = "c",
  ["\195\168"] = "e",
  ["\195\169"] = "e",
  ê = "e",
  ["\195\171"] = "e",
  ["\195\172"] = "i",
  ["\195\173"] = "i",
  ["\195\174"] = "i",
  ["\195\175"] = "i",
  ["\195\176"] = "eth",
  ["\195\177"] = "n",
  ["\195\178"] = "o",
  ["\195\179"] = "o",
  ["\195\180"] = "o",
  õ = "o",
  ["\195\182"] = "o",
  ["\195\184"] = "o",
  ["\195\185"] = "u",
  ú = "u",
  ["\195\187"] = "u",
  ["\195\188"] = "u",
  ["\195\189"] = "y",
  ["\195\190"] = "p",
  ["\195\191"] = "y"
}
function RemoveDiacritics(s)
  return s:gsub("[%z\001-\127\194-\244][\128-\191]*", diacritics_map)
end
tag_processors = {}
DefineClass.XTextToken = {
  __parents = {
    "PropertyObject"
  },
  text = false,
  type = false,
  args = false
}
function XTextTokenize(input_text, token_func, stream)
  if not token_func then
    stream = stream or {}
    function token_func(stream, ttype, args, text)
      if text == "" then
        return
      end
      local next_token = XTextToken:new({
        type = ttype,
        text = text,
        args = args
      })
      table.insert(stream, next_token)
    end
  end
  if type(input_text) ~= "string" or not utf8.IsValidString(input_text) then
    token_func(stream, "text", false, "Not a valid UTF-8 string:" .. string.gsub(input_text, [=[
[^a-zA-Z0-9
 <%>-%:%(%)\/]]=], "."))
    return stream
  end
  local byte_idx = 1
  local input_text_bytes_len = #input_text
  local tags_on = true
  while byte_idx <= input_text_bytes_len do
    local start_byte_idx, end_byte_idx = string.find(input_text, "</?[^%s=>][^>]*>", byte_idx)
    start_byte_idx = start_byte_idx or input_text_bytes_len + 1
    token_func(stream, "text", false, string.sub(input_text, byte_idx, start_byte_idx - 1))
    byte_idx = start_byte_idx + 1
    if end_byte_idx then
      byte_idx = end_byte_idx + 1
      local token = string.sub(input_text, start_byte_idx + 1, end_byte_idx - 1)
      local elements
      if token:find("%s") then
        elements = {}
        for part in string.gmatch(token, "[^%s]+") do
          table.insert(elements, part)
        end
        local i = 1
        while i <= #elements do
          if elements[i]:starts_with("'") then
            if i < #elements and not elements[i]:ends_with("'") then
              elements[i] = string.format("%s %s", elements[i], elements[i + 1])
              table.remove(elements, i + 1)
            else
              if elements[i]:ends_with("'") then
                elements[i] = elements[i]:sub(2, -2)
              end
              i = i + 1
            end
          else
            i = i + 1
          end
        end
      end
      local tag = elements and elements[1] or token
      if tag == "tags" then
        tags_on = elements and elements[2] == "on"
      elseif tag == "literal" and tonumber(elements and elements[2]) then
        local offset = tonumber(elements[2])
        offset = Min(Max(0, offset), input_text_bytes_len)
        byte_idx = Max(end_byte_idx + 1, Min(input_text_bytes_len + 1, end_byte_idx + offset + 1))
        token_func(stream, "text", false, string.sub(input_text, end_byte_idx + 1, byte_idx - 1))
      elseif not (token ~= "" and tag_processors[tag]) or tag == "text" or not tags_on then
        token_func(stream, "text", false, "<" .. token .. ">")
      else
        if elements then
          table.remove(elements, 1)
        end
        token_func(stream, tag, elements, token)
      end
    end
  end
  return stream
end
local starts_with = string.starts_with
local string_gmatch = string.gmatch
function CountWords(line)
  local count = 0
  for _, span in ipairs(XTextTokenize(line)) do
    if span.type == "text" then
      local text = span.text
      if not starts_with(text, "<") then
        for word in string_gmatch(text, "[^%s]+") do
          count = count + 1
        end
      end
    end
  end
  return count
end
