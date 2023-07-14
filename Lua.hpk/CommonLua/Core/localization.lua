localization_ignore_header = "-- [[localization-ignore]]"
const.TagLookupTable = const.TagLookupTable or {}
local TagLookupTable = const.TagLookupTable
local type = type
local getmetatable = getmetatable
local setmetatable = setmetatable
RandomLocIds = {}
local TIgnoreErrors = false
local locId_sig = shift(255, 56)
local locId_mask = bnot(locId_sig)
local LocIDToLightUserdata = function(id)
  return id and LightUserData(bor(id, locId_sig))
end
local LightUserdataToLocId = function(value)
  value = LightUserDataValue(value)
  if value and band(value, locId_sig) == locId_sig then
    return band(value, locId_mask)
  end
end
local IsTCompatible = function()
  return true
end
if Platform.developer then
  function IsTCompatible(T)
    return LightUserdataToLocId(T) or type(T) == "number" or type(T) == "function" or type(T) == "string" and IsTagsAndPunctuation(T) or type(T) == "table" and (getmetatable(T) == TMeta or getmetatable(T) == TConcatMeta)
  end
end
function IsT(T)
  return T == "" or LightUserdataToLocId(T) or type(T) == "table" and (getmetatable(T) == TMeta or getmetatable(T) == TConcatMeta)
end
function IsUserText(T)
  return type(T) == "table" and getmetatable(T) == TMeta and T._language ~= nil
end
function TGetID(T)
  if T == "" then
    return false
  end
  local value = LightUserdataToLocId(T)
  if value then
    return value
  end
  if type(T[1]) == "number" then
    return T[1]
  elseif type(T[1]) == "table" then
    return TGetID(T[1])
  else
    return LightUserdataToLocId(T[1])
  end
end
function TDevModeGetEnglishText(T, deep, no_assert)
  if T == "" then
    return ""
  end
  local no_assert = no_assert or not Platform.pc or Platform.ged
  if type(T) ~= "table" then
    local id = LightUserdataToLocId(T)
    return id and TranslationTable[id] or "Missing text"
  end
  local ret = type(T[1]) == "number" and T[2] or T[1]
  ret = deep and type(ret) ~= "string" and TDevModeGetEnglishText(ret, true, no_assert) or ret
  if not Platform.developer and type(ret) == "string" then
    ret = ret:gsub("%(design%)%s*", ""):gsub("%(minor%)%s*", "")
  end
  return ret
end
function TSort(t, field, case_insensitive)
  local sortkey_internal_translation
  if type(field) == "function" then
    for i = 1, #t do
      sortkey_internal_translation = _InternalTranslate(field(t[i]))
      if Platform.pc then
        t[i].__sort_key = utf8.ToUtf16(sortkey_internal_translation)
      else
        t[i].__sort_key = sortkey_internal_translation
      end
    end
  else
    for i = 1, #t do
      sortkey_internal_translation = _InternalTranslate(t[i][field])
      if Platform.pc then
        t[i].__sort_key = utf8.ToUtf16(sortkey_internal_translation)
      else
        t[i].__sort_key = sortkey_internal_translation
      end
    end
  end
  if Platform.pc then
    local lang = table.find_value(AllLanguages, "value", GetLanguage())
    local wchar_locale = utf8.ToUtf16(lang and lang.locale or "en-US")
    table.stable_sort(t, function(a, b)
      return LocaleCmp(a.__sort_key, b.__sort_key, wchar_locale, case_insensitive)
    end)
  elseif case_insensitive then
    table.stable_sort(t, function(a, b)
      return CmpLower(a.__sort_key, b.__sort_key)
    end)
  else
    table.stable_sort(t, function(a, b)
      return a.__sort_key < b.__sort_key
    end)
  end
  for i = 1, #t do
    t[i].__sort_key = nil
  end
end
function IsTagsAndPunctuation(str)
  local untagged, tag, first, last = str:nexttag(1)
  while tag do
    if untagged:find("%w") then
      return false
    end
    untagged, tag, first, last = str:nexttag(last + 1)
  end
  return not untagged:find("%w")
end
function IsLookupTag(str)
  local untagged, tag, first, last = str:nexttag(1)
  if not tag then
    return false
  end
  while tag do
    if untagged:find("%w") then
      return false
    end
    if not TagLookupTable[tag] then
      return false
    end
    untagged, tag, first, last = str:nexttag(last + 1)
  end
  return not untagged:find("%w")
end
function THasArgs(T)
  if type(T) == "table" then
    local hasID = type(T[1]) == "number"
    for k, v in pairs(T) do
      if k ~= 1 and (not hasID or k ~= 2) and k ~= "untranslated" and k ~= "_steam_id" and k ~= "_language" then
        return true
      end
      if THasArgs(v) then
        return true
      end
    end
  end
  return false
end
function TStripArgs(_T)
  if type(_T) == "table" then
    local hasID = type(_T[1]) == "number"
    if hasID then
      return T({
        _T[1],
        TStripArgs(_T[2])
      })
    else
      return T({
        TStripArgs(_T[1])
      })
    end
  end
  return _T
end
local gender_offset = {
  [false] = 0,
  m = 0,
  M = 0,
  Male = 0,
  f = 1,
  F = 1,
  Female = 1,
  n = 2,
  N = 2
}
function GenderChangedID(id, gender)
  if type(id) ~= "number" then
    return id
  end
  if IsT(gender) then
    gender = GetTGender(gender)
  elseif type(gender) == "table" then
    gender = gender.Gender
  end
  local offset = gender_offset[gender or false]
  local new_id = id + (offset or 0)
  return TranslationTable[new_id] and new_id or id
end
function T(T, Ttext, gender)
  if type(T) == "table" then
    if getmetatable(T[1]) == TConcatMeta then
      return T[1]
    end
    local id = T[1]
    local text = type(id) == "number" and T[2] or T[1]
    if text == "" then
      return ""
    end
    if type(id) == "number" and type(text) == "string" then
      if IsRandomLocId(id) then
        RandomLocIds[id] = true
      end
      gender = T.TGender
      if gender then
        T[1] = GenderChangedID(id, gender)
      end
      if not Platform.developer and not Platform.ged and TranslationTable[id] and not THasArgs(T) then
        return LocIDToLightUserdata(id)
      end
    end
    return setmetatable(T, TMeta)
  else
    local id = T
    local text = type(id) == "number" and Ttext or T
    if text == "" then
      return ""
    end
    if type(id) == "number" and type(text) == "string" then
      if IsRandomLocId(id) then
        RandomLocIds[id] = true
      end
      if gender then
        id = GenderChangedID(id, gender)
      end
      if not Platform.developer and not Platform.ged and TranslationTable[id] then
        return LocIDToLightUserdata(id)
      end
    end
    return setmetatable({T, Ttext}, TMeta)
  end
end
local locId_random_start = 100000000000
local locId_random_range = 899999000000
function IsRandomLocId(id)
  if type(id) == "number" then
    id = id - locId_random_start
    return 0 <= id and id < locId_random_range
  end
end
function RandomLocId()
  for i = 1, 1000 do
    local id = locId_random_start + AsyncRand(locId_random_range)
    if not RandomLocIds[id] and not RandomLocIds[id - 1] and not RandomLocIds[id - 2] and not RandomLocIds[id + 1] and not RandomLocIds[id + 2] then
      RandomLocIds[id] = true
      return id
    end
  end
end
function Untranslated(_T)
  if IsT(_T) then
    return _T
  end
  if type(_T) == "table" then
    return T(_T)
  end
  return T({
    tostring(_T or ""),
    untranslated = true
  })
end
function TLookupTag(_T)
  return T({
    tostring(_T)
  })
end
if FirstLoad then
  TMeta = {}
  TConcatMeta = {}
  LightUserDataSetMetatable(TMeta)
  oldTableConcat = table.concat
  TranslationTable = {}
  TranslationGenderTable = {}
  g_ignore_translation_errors = false
end
function OnMsg.PersistGatherPermanents(permanents)
  permanents["T.meta"] = TMeta
  permanents["TConcat.meta"] = TConcatMeta
  permanents["func:type"] = type
end
function TMeta.__concat(T1, T2)
  if IsTCompatible(T1) then
    if type(T1) == "table" and getmetatable(T1) == TConcatMeta then
      T1 = table.copy(T1)
    else
      T1 = {T1}
    end
  elseif type(T1) == "string" then
    T1 = {T1}
  else
    return T2
  end
  if IsTCompatible(T2) then
    if type(T2) == "table" and getmetatable(T2) == TConcatMeta then
      local num = #T1
      for i = 1, #T2 do
        T1[num + i] = T2[i]
      end
    else
      T1[1 + #T1] = T2
    end
  else
    if type(T2) == "string" then
      T1[1 + #T1] = T2
    else
    end
  end
  return setmetatable(T1, TConcatMeta)
end
function TMeta.__newindex()
end
function TMeta:__copy()
  return self
end
function TMeta:__toluacode(indent, pstr)
  return TToLuaCode(self, ContextCache[self], pstr)
end
function TMeta.__eq(op1, op2)
  return IsT(op1) and IsT(op2) and TDevModeGetEnglishText(op1, false, "no assert") == TDevModeGetEnglishText(op2, false, "no assert")
end
function TMeta.__serialize(T)
  return "TMeta", table.raw_copy(T)
end
function TMeta.__unserialize(serialized_data)
  local T = setmetatable(serialized_data, TMeta)
  return T
end
ContextCache = {}
TConcatMeta.__concat = TMeta.__concat
function TConcatMeta.__newindex()
end
function TConcatMeta:__toluacode(indent, pstr)
  local lines, context = {}, ContextCache[self]
  for _, value in ipairs(self) do
    lines[#lines + 1] = TToLuaCode(value, context)
  end
  if type(indent) ~= "string" then
    indent = string.rep("\t", indent or 0)
  end
  lines = [[
{
	]] .. indent .. table.concat(lines, [[
,
	]] .. indent) .. "\n" .. indent .. "}"
  if pstr then
    return pstr:append("TConcat(", lines, ")")
  else
    return string.format("TConcat(%s)", lines)
  end
end
function TConcat(table)
  return setmetatable(table, TConcatMeta)
end
function table.concat(t, sep, i, j)
  if not next(t) then
    return ""
  end
  i = i or 1
  j = j or #t
  local idx, item = i, t[i]
  if i == j then
    return item
  end
  while item == "" and j > idx do
    idx = idx + 1
    item = t[idx]
  end
  if IsT(item) and item ~= "" then
    for n = i, j do
      local item = t[n]
    end
    return setmetatable({
      setmetatable({
        table = t,
        sep = sep,
        i = i,
        j = j
      }, TConcatMeta)
    }, TConcatMeta)
  end
  if IsT(sep) then
    sep = _InternalTranslate(sep)
  end
  return oldTableConcat(t, sep, i, j)
end
local function evalIdentifier(T, context_obj, id)
  local value
  if type(T) == "table" then
    local format_string_index = type(T[1]) == "number" and 2 or 1
    local innerT = T[format_string_index]
    if IsT(innerT) then
      value = evalIdentifier(innerT, context_obj, id)
    end
    value = value or T[id]
    if not value and context_obj then
      value = ResolveValue(context_obj, id)
    end
    if not value then
      for j = format_string_index + 1, #T do
        local obj = T[j]
        if context_obj ~= obj then
          value = ResolveValue(obj, id)
          if value then
            break
          end
        end
      end
    end
  elseif not value and context_obj then
    value = ResolveValue(context_obj, id)
  end
  value = value or TagLookupTable[id]
  if type(value) == "function" then
    value = value(context_obj)
  end
  return value
end
local evalIdentifiers = function(T, context_obj, ids)
  local first = 1
  while first do
    local rest = ids:find(".", first, true)
    context_obj = evalIdentifier(T, context_obj, ids:sub(first, (rest or 0) - 1))
    first = rest and rest + 1
  end
  return context_obj
end
local evalFunctionCall
local function evalParams(T, context_obj, tag, start)
  local param, cont = tag:match("^%s*([%a_][%w_.]*)%s*[,)]()", start)
  if param == "true" or param == "false" then
    param = param == "true"
    return param, evalParams(T, context_obj, tag, cont)
  end
  if param then
    return evalIdentifiers(T, context_obj, param), evalParams(T, context_obj, tag, cont)
  end
  local param_start
  param, param_start, cont = tag:match("^%s*([%a_][%w_]*)()%b()%s*[,)]()", start)
  if param then
    return evalFunctionCall(T, context_obj, param, tag, param_start + 1), evalParams(T, context_obj, tag, cont)
  end
  param, cont = tag:match("^%s*%'(.-)%'%s*[,)]()", start)
  if param then
    return param, evalParams(T, context_obj, tag, cont)
  end
  param, cont = tag:match("^%s*(%-?%d+)%s*[,)]()", start)
  if param then
    param = tonumber(param)
    return param, evalParams(T, context_obj, tag, cont)
  end
end
function evalFunctionCall(T, context_obj, fn, tag, param_start)
  local f = TFormat[fn]
  if f then
    return f(context_obj, evalParams(T, context_obj, tag, param_start))
  end
  local f, obj = ResolveFunc(context_obj, fn)
  if f then
    return f(obj or context_obj, evalParams(T, context_obj, tag, param_start))
  end
end
local evalTag = function(T, context_obj, tag)
  local func, param_start = tag:match("^(/?[%a_][%w_]*)()%b()$")
  if func then
    return evalFunctionCall(T, context_obj, func, tag, param_start + 1)
  end
  return evalIdentifiers(T, context_obj, tag)
end
local evalConcat = function(T, context_obj, check, tags_off)
  local pieces = {}
  local t = T.table
  if t then
    for i = T.i, T.j do
      table.insert(pieces, _InternalTranslate(t[i], context_obj, check, tags_off))
    end
    return oldTableConcat(pieces, T.sep and _InternalTranslate(T.sep, context_obj, check, tags_off))
  end
  for i = 1, #T do
    table.insert(pieces, _InternalTranslate(T[i], context_obj, check, tags_off))
  end
  return oldTableConcat(pieces)
end
local appendTranslateFunctionCall = function(_pstr, T, context_obj, fn, tag, param_start, check)
  local append_f = TFormatPstr[fn]
  if append_f then
    local err = append_f(_pstr, context_obj, evalParams(T, context_obj, tag, param_start))
    return err
  end
  local eval_f = TFormat[fn]
  if eval_f then
    local value, ignore_check = eval_f(context_obj, evalParams(T, context_obj, tag, param_start))
    if value == nil then
      return "not_a_tag"
    end
    if not value then
      return "failed"
    end
    return AppendTTranslate(_pstr, value, context_obj, check ~= false and not ignore_check)
  end
  local eval_f, obj = ResolveFunc(context_obj, fn)
  if eval_f then
    local value, ignore_check = eval_f(obj or context_obj, evalParams(T, context_obj, tag, param_start))
    if value == nil then
      return "not_a_tag"
    end
    if not value then
      return "failed"
    end
    return AppendTTranslate(_pstr, value, context_obj, check ~= false and not ignore_check)
  end
end
local appendTranslateTag = function(_pstr, T, context_obj, tag, check)
  local func, param_start = tag:match("^(/?[%a_][%w_]*)()%b()$")
  if func then
    local err = appendTranslateFunctionCall(_pstr, T, context_obj, func, tag, param_start + 1, check)
    return err
  else
    local value, ignore_check = evalIdentifiers(T, context_obj, tag)
    if value == nil then
      return "not_a_tag"
    end
    if not value then
      return "failed"
    end
    local err = AppendTTranslate(_pstr, value, context_obj, check ~= false and not ignore_check)
    return err
  end
  return false
end
local appendTranslateT = function(_pstr, T, context_obj, check, tags_off)
  local id = TGetID(T)
  local str = (not Platform.developer or GetLanguage() ~= "English" or type(T) == "userdata") and TranslationTable[id] or TDevModeGetEnglishText(T, "deep", "no_assert") or string.format("{#%d}", id)
  if tags_off then
    _pstr:append(str)
    return false
  end
  local untagged, tag, first, last = str:nexttag(1)
  context_obj = context_obj or type(T) == "table" and T[type(T[1]) == "number" and 3 or 2] or nil
  while tag do
    _pstr:append(untagged)
    local success, err = procall(appendTranslateTag, _pstr, T, context_obj, tag, check)
    if not success then
      print("once", "evalTag", tag, "failed for", str)
      untagged = ""
      break
    end
    if err == "not_a_tag" then
      _pstr:append_sub(str, first, last)
    elseif err then
      untagged = ""
      break
    end
    untagged, tag, first, last = str:nexttag(last + 1)
  end
  _pstr:append(untagged)
  return false
end
local appendTranslateConcat = function(_pstr, T, context_obj, check, tags_off)
  local AppendTTranslate = AppendTTranslate
  local t = T.table
  if t then
    local t_start = T.i
    local t_end = T.j
    if T.sep then
      for i = t_start, t_end - 1 do
        AppendTTranslate(_pstr, t[i], context_obj, check, tags_off)
        AppendTTranslate(_pstr, T.sep, context_obj, check, tags_off)
      end
      AppendTTranslate(_pstr, t[t_end], context_obj, check, tags_off)
    else
      for i = t_start, t_end do
        AppendTTranslate(_pstr, t[i], context_obj, check, tags_off)
      end
    end
    return false
  end
  for i = 1, #T do
    AppendTTranslate(_pstr, T[i], context_obj, check, tags_off)
  end
  return false
end
local appendTranslateUserText = function(_pstr, T, check)
  local text = GetFilteredText(T)
  _pstr:append(text or TDevModeGetEnglishText(T, false, "no_assert"))
  return false
end
function AppendTTranslate(_pstr, T, context_obj, check, tags_off)
  if T == "" then
    return false
  end
  local Ttype = type(T)
  if Ttype == "userdata" then
    local err = appendTranslateT(_pstr, T, context_obj, check)
    if err then
      return err
    end
  elseif Ttype == "string" then
    _pstr:append(T)
  elseif Ttype == "number" then
    _pstr:append(LocaleInt(T))
  elseif IsUserText(T) then
    local err = appendTranslateUserText(_pstr, T, check)
    if err then
      return err
    end
  elseif Ttype == "table" and getmetatable(T) == TMeta then
    local err = appendTranslateT(_pstr, T, context_obj, check, tags_off)
    if err then
      return err
    end
  elseif Ttype == "table" and getmetatable(T) == TConcatMeta then
    local err = appendTranslateConcat(_pstr, T, context_obj, check, tags_off)
    if err then
      return err
    end
  else
    return true
  end
  return false
end
local g_TranslatePrependIDs
function ToggleTranslatePrependIDs()
  g_TranslatePrependIDs = not g_TranslatePrependIDs
  Msg("TranslationChanged")
end
local TTranslatePstrCache = pstr("", 256)
function TTranslate(T, context_obj, check, tags_off)
  local _pstr = TTranslatePstrCache
  if not _pstr then
    _pstr = pstr("", 256)
  else
    TTranslatePstrCache = false
    _pstr:clear()
  end
  local err = AppendTTranslate(_pstr, T, context_obj, check ~= false and not TIgnoreErrors, tags_off)
  TTranslatePstrCache = _pstr
  if g_TranslatePrependIDs then
    local id = TGetID(T)
    if id then
      return id .. ":" .. _pstr:str()
    end
  end
  return _pstr:str()
end
_InternalTranslate = TTranslate
local ThousandsSeparator
function LocaleInt(x)
  ThousandsSeparator = ThousandsSeparator or TTranslate(T(433967674729, ","))
  local ts = ThousandsSeparator
  local r = ""
  if x < 0 then
    r = "-"
    x = -x
  end
  if x < 1000 then
    r = r .. tostring(x)
  elseif x < 1000000 then
    r = string.format("%s%d%s%03d", r, x / 1000, ts, x % 1000)
  elseif x < 1000000000 then
    r = string.format("%s%d%s%03d%s%03d", r, x / 1000000, ts, x / 1000 % 1000, ts, x % 1000)
  else
    r = string.format("%s%d%s%03d%s%03d%s%03d", r, x / 1000000000, ts, x / 1000000 % 1000, ts, x / 1000 % 1000, ts, x % 1000)
  end
  return r
end
function OnMsg.TranslationChanged()
  ThousandsSeparator = false
  ObjModified("PreGameButtons")
end
function LocaleDateTime(os_time)
  return os.date(GetLanguage() == "Japanese" and "%Y.%m.%d %H:%M" or "%d %b %Y %H:%M", os_time)
end
function GetDateTimeOrder()
  local format = GetSystemDateFormat()
  local lastC = false
  local order = {}
  for i = 1, #format do
    local c = format:sub(i, i)
    local isMonthChar = c == "m" or c == "M"
    local isYearChar = c == "Y" or c == "y"
    local isDayChar = c == "D" or c == "d"
    local isValidChar = isMonthChar or isYearChar or isDayChar
    if isValidChar then
      if c ~= lastC then
        if isMonthChar then
          order[#order + 1] = "month"
        elseif isYearChar then
          order[#order + 1] = "year"
        elseif isDayChar then
          order[#order + 1] = "day"
        end
      end
      lastC = c
    end
  end
  return order
end
function TToLuaCode(T, context, pstr)
  if IsUserText(T) then
    return UserTextToLuaCode(T, context, pstr)
  end
  return IDTextToLuaCode(TGetID(T), TDevModeGetEnglishText(T, false, "no assert"), context, pstr)
end
function UserTextToLuaCode(T, context, pstr)
  local lua_str = string.format("T%s", TableToLuaCode(T))
  if pstr then
    return pstr:appendf(lua_str)
  end
  return string.format(lua_str)
end
function IDTextToLuaCode(id, text, context, pstr)
  local context_str = context and context ~= "" and string.format("--[[%s]] ", context) or ""
  if id then
    if text ~= "" then
      if pstr then
        return pstr:appendf("T(%d, %s%v)", id, context_str, text)
      end
      return string.format("T(%d, %s%s)", id, context_str, StringToLuaCode(text))
    else
      if pstr then
        return pstr:append("\"\"")
      end
      return "\"\""
    end
  else
    if pstr then
      return pstr:appendf("T(%s%v)", context_str, text)
    end
    return string.format("T(%s%s)", context_str, StringToLuaCode(text))
  end
end
local csv_load_fields = {
  [1] = "id",
  [2] = "text",
  [5] = "translated",
  [3] = "translated_new",
  [7] = "gender"
}
function LoadTranslationTableFile(filename)
  local loaded = {}
  LoadCSV(filename, loaded, csv_load_fields, "omit_captions")
  return ProcessLoadedTables(loaded, GetLanguage(), TranslationTable, TranslationGenderTable)
end
function LoadTranslationTablesFolder(path, language, out_table, out_gendertable)
  local loaded = {}
  local files = io.listfiles(path, "*.csv") or {}
  table.sort(files)
  for _, filename in ipairs(files) do
    LoadCSV(filename, loaded, csv_load_fields, "omit_captions")
  end
  return ProcessLoadedTables(loaded, language, out_table, out_gendertable)
end
function ProcessLoadedTables(loaded, language, out_table, out_gendertable)
  local order = {
    "translated_new",
    "translated",
    "text"
  }
  if language == "English" then
    order = {
      "translated_new",
      "text",
      "translated"
    }
  end
  for _, entry in ipairs(loaded) do
    local translation
    if entry[order[1]] and entry[order[1]] ~= "" then
      translation = entry[order[1]]
    elseif entry[order[2]] and entry[order[2]] ~= "" then
      translation = entry[order[2]]
    else
      translation = entry[order[3]]
    end
    local id = tonumber(entry.id)
    if id then
      out_table[id] = translation
      if out_gendertable then
        out_gendertable[id] = entry.gender
      end
    end
  end
  return next(loaded) ~= nil
end
local AlwaysWrapLanguages = {
  Schinese = true,
  Tchinese = true,
  Japanese = true,
  Koreana = true
}
function LoadTranslationTables()
  TranslationTable = {}
  collectgarbage("collect")
  local path = GetExecDirectory() .. "CurrentLanguage"
  if LoadTranslationTablesFolder(path, GetLanguage(), TranslationTable, TranslationGenderTable) or LoadTranslationTablesFolder("CurrentLanguage/", GetLanguage(), TranslationTable, TranslationGenderTable) or Platform.developer or not Platform.cmdline then
  end
  config.TextWrapAnywhere = AlwaysWrapLanguages[GetLanguage()] or false
  if not Loading then
    Msg("TranslationChanged")
  end
  collectgarbage("collect")
end
g_BuildLocTables = false
g_BuildLocTablesSignal = false
function LoadBuildLocTables(project_path)
  if g_BuildLocTables then
    return
  end
  if g_BuildLocTablesSignal then
    WaitMsg(g_BuildLocTablesSignal)
    return
  end
  g_BuildLocTablesSignal = {}
  local loctables = {}
  local err, languages = AsyncListFiles(project_path .. "/LocalizationOut", "*", "folders,relative")
  if err then
    print("Error loading translation tables: ", err)
    return
  end
  for _, language in ipairs(languages) do
    local path = project_path .. "/LocalizationOut/" .. language .. "/CurrentLanguage"
    local err, files = AsyncListFiles(path, "*.csv")
    if not err then
      local loaded = {}
      local needed_fields = {
        [1] = "id",
        [2] = "text",
        [3] = "translated_new"
      }
      table.sort(files)
      for i = 1, #files do
        LoadCSV(files[i], loaded, needed_fields, "omit_captions")
      end
      local order = {
        "translated_new"
      }
      if language == "English" then
        order = {
          "translated_new",
          "text"
        }
      end
      local lang_result = {}
      for _, entry in ipairs(loaded) do
        if entry[order[1]] and entry[order[1]] ~= "" then
          lang_result[tonumber(entry.id)] = entry[order[1]]
        elseif order[2] and entry[order[2]] and entry[order[2]] ~= "" then
          lang_result[tonumber(entry.id)] = entry[order[2]]
        end
      end
      loctables[language] = lang_result
    end
  end
  g_BuildLocTables = loctables
  Msg(g_BuildLocTablesSignal)
  g_BuildLocTablesSignal = false
end
function GetTGender(T)
  return TranslationGenderTable[TGetID(T) or false] or false
end
function GetTByGender(T, gender)
  if (T or "") == "" then
    return T
  end
  if THasArgs(T) then
    T[1] = GenderChangedID(T[1], gender)
    return T
  else
    local id = GenderChangedID(TGetID(T), gender)
    return TranslationTable[id or false] and LocIDToLightUserdata(id) or T
  end
end
function IdGenderSuffix(T, id)
  local gender = TranslationGenderTable[TGetID(T) or false] or "M"
  if gender == "F" then
    return id .. "_f"
  elseif gender == "N" then
    return id .. "_n"
  else
    return id .. "_m"
  end
end
local IME_languages = {
  "Koreana",
  "Japanese",
  "Schinese",
  "Tchinese"
}
function InitWindowsImeState()
  local lang = GetLanguage()
  config.EnableIme = Platform.pc and table.find(IME_languages, lang)
  config.EnableImeCandidateWindow = lang ~= "Koreana"
  hr.HideIme = true
end
function IsImeEnabled()
  return config.EnableIme
end
function SetImePosition(x, y, fontId)
  if IsImeEnabled() then
    hr.WindowsImePositionX = x
    hr.WindowsImePositionY = y
    hr.WindowsImeFontId = fontId or -1
    hr.WindowsImePosChanged = hr.WindowsImePosChanged + 1
  end
end
function HideIme()
  if IsImeEnabled() and not hr.HideIme then
    hr.HideIme = true
  end
end
function ShowIme()
  if IsImeEnabled() and hr.HideIme then
    hr.HideIme = false
  end
end
function GetImeWindowWidthHeight(fontId)
  local compStr = terminal.GetWindowsImeCompositionString()
  if compStr then
    return UIL.MeasureText(compStr, fontId)
  end
  return 0, 0
end
AllLanguages = {
  {
    value = "Brazilian",
    text = T(699854757080, "Brazilian Portuguese"),
    ps_locale = "pt-BR",
    locale = "pt-BR",
    pdx_locale = "pt",
    epic_locale = "pt-BR"
  },
  {
    value = "Bulgarian",
    text = T(385829073168, "Bulgarian"),
    ps_locale = "bg-BG",
    locale = "bg-BG",
    pdx_locale = "bg",
    epic_locale = false
  },
  {
    value = "Czech",
    text = T(552240423015, "Czech"),
    ps_locale = "cs-CZ",
    locale = "cs-CZ",
    pdx_locale = "cs",
    epic_locale = false
  },
  {
    value = "Danish",
    text = T(782416127227, "Danish"),
    ps_locale = "da-DK",
    locale = "da-DK",
    pdx_locale = "da",
    epic_locale = "da"
  },
  {
    value = "Dutch",
    text = T(675114896426, "Dutch"),
    ps_locale = "nl-NL",
    locale = "nl-NL",
    pdx_locale = "nl",
    epic_locale = "nl"
  },
  {
    value = "English",
    text = T(147611982706, "English"),
    ps_locale = "en-US",
    locale = "en-US",
    pdx_locale = "en",
    epic_locale = "en-US"
  },
  {
    value = "Finnish",
    text = T(283206621979, "Finnish"),
    ps_locale = "fi-FI",
    locale = "fi-FI",
    pdx_locale = "fi",
    epic_locale = "fi"
  },
  {
    value = "French",
    text = T(170273676234, "French"),
    ps_locale = "fr-FR",
    locale = "fr-FR",
    pdx_locale = "fr",
    epic_locale = "fr"
  },
  {
    value = "German",
    text = T(505552009073, "German"),
    ps_locale = "de-DE",
    locale = "de-DE",
    pdx_locale = "de",
    epic_locale = "de"
  },
  {
    value = "Hungarian",
    text = T(646055054297, "Hungarian"),
    ps_locale = "hu-HU",
    locale = "hu-HU",
    pdx_locale = "hu",
    epic_locale = false
  },
  {
    value = "Indonesian",
    text = T(596539604344, "Indonesian"),
    ps_locale = "id-ID",
    locale = "id-ID",
    pdx_locale = "id",
    epic_locale = false
  },
  {
    value = "Italian",
    text = T(330877865785, "Italian"),
    ps_locale = "it-IT",
    locale = "it-IT",
    pdx_locale = "it",
    epic_locale = "it"
  },
  {
    value = "Japanese",
    text = T(527962174587, "Japanese"),
    ps_locale = "ja-JP",
    locale = "ja-JP",
    pdx_locale = "ja",
    epic_locale = "ja"
  },
  {
    value = "Koreana",
    text = T(585811408758, "Korean"),
    ps_locale = "ko-KR",
    locale = "ko-KR",
    pdx_locale = "ko",
    epic_locale = "ko"
  },
  {
    value = "Norwegian",
    text = T(369233670775, "Norwegian"),
    ps_locale = "nb-NO",
    locale = "nb-NO",
    pdx_locale = "no",
    epic_locale = "no"
  },
  {
    value = "Polish",
    text = T(197791212449, "Polish"),
    ps_locale = "pl-PL",
    locale = "pl-PL",
    pdx_locale = "pl",
    epic_locale = "pl"
  },
  {
    value = "Portuguese",
    text = T(661132086100, "Portuguese"),
    ps_locale = "pt-PT",
    locale = "pt-PT",
    pdx_locale = "pt",
    epic_locale = false
  },
  {
    value = "Romanian",
    text = T(375694388084, "Romanian"),
    ps_locale = "ro-RO",
    locale = "ro-RO",
    pdx_locale = "ro",
    epic_locale = false
  },
  {
    value = "Russian",
    text = T(794451731349, "Russian"),
    ps_locale = "ru-RU",
    locale = "ru-RU",
    pdx_locale = "ru",
    epic_locale = "ru"
  },
  {
    value = "Schinese",
    text = T(465743231919, "Chinese (Simplified)"),
    ps_locale = "zh-Hans",
    locale = "zh-CN",
    pdx_locale = "zh",
    epic_locale = "zh-Hans"
  },
  {
    value = "Spanish",
    text = T(277226277909, "Spanish (Spain)"),
    ps_locale = "es-ES",
    locale = "es-ES",
    pdx_locale = "es",
    epic_locale = "es-ES"
  },
  {
    value = "Latam",
    text = T(342769994919, "Spanish (Latin America)"),
    ps_locale = "es-MX",
    locale = "es-MX",
    pdx_locale = "es",
    epic_locale = "es-MX"
  },
  {
    value = "Swedish",
    text = T(487752404194, "Swedish"),
    ps_locale = "sv-SE",
    locale = "sv-SE",
    pdx_locale = "sv",
    epic_locale = "sv"
  },
  {
    value = "Tchinese",
    text = T(508880261610, "Chinese (Traditional)"),
    ps_locale = "zh-Hant",
    locale = "zh-TW",
    pdx_locale = "zh",
    epic_locale = "zh-Hant"
  },
  {
    value = "Thai",
    text = T(681908731541, "Thai"),
    ps_locale = "th-TH",
    locale = "th-TH",
    pdx_locale = "th",
    epic_locale = "th"
  },
  {
    value = "Turkish",
    text = T(218295023775, "Turkish"),
    ps_locale = "tr-TR",
    locale = "tr-TR",
    pdx_locale = "tr",
    epic_locale = "tr"
  }
}
LanguagesWithNamesStartWithFamily = {Tchinese = true, Schinese = true}
PlayStationLanguageCodes = {
  "Japanese",
  "00",
  "English",
  "01",
  "French",
  "02",
  "Spanish",
  "03",
  "German",
  "04",
  "Italian",
  "05",
  "",
  "06",
  "Portuguese",
  "07",
  "Russian",
  "08",
  "Koreana",
  "09",
  "Tchinese",
  "10",
  "Schinese",
  "11",
  "",
  "12",
  "",
  "13",
  "",
  "14",
  "",
  "15",
  "Polish",
  "16",
  "Brazilian",
  "17",
  "English",
  "18",
  "",
  "19",
  "Latam",
  "20",
  "French",
  "22",
  "Czech",
  "23",
  "Hungarian",
  "24",
  "",
  "25",
  "Romanian",
  "26",
  "Thai",
  "27",
  "",
  "28",
  "Indonesian",
  "29"
}
function LocaleToPlayStationLocale(locale)
  return table.find_value(AllLanguages, "locale", locale).ps_locale
end
function IsLocalizationLanguageAvailable(language)
  local folder_or_pack = (config.UnpackedLocalization or config.UnpackedLocalization == nil and IsFSUnpacked()) and "svnProject/LocalizationOut/" .. language .. "/CurrentLanguage/" or "Local/" .. language .. ".hpk"
  return io.exists(folder_or_pack)
end
function OnMsg.Autorun()
  local result = {
    {
      value = "Auto",
      text = T(388818321440, "Auto"),
      iso_639_1 = "en"
    }
  }
  if Platform.desktop and rawget(_G, "OptionsData") then
    for _, language in ipairs(AllLanguages) do
      if IsLocalizationLanguageAvailable(language.value) then
        result[#result + 1] = language
      end
    end
    OptionsData.Options.Language = result
  end
end
local list_separator = T(651365107459, ", ")
function TList(list, separator)
  return table.concat(list, separator or _InternalTranslate(list_separator))
end
