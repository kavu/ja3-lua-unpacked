function CreateUserText(text, user_text_type)
  return setmetatable({
    text,
    _language = GetLanguage(),
    _steam_id = Platform.steam and IsSteamAvailable() and SteamGetUserId64() or nil,
    _user_text_type = user_text_type
  }, TMeta)
end
function _DefaultInternalFilterUserTexts(unfilteredTs)
  local filteredTs = {}
  for _, T in ipairs(unfilteredTs) do
    filteredTs[T] = TDevModeGetEnglishText(T, "deep", "no_assert")
  end
  return false, filteredTs
end
_InternalFilterUserTexts = _DefaultInternalFilterUserTexts
if FirstLoad then
  FilteredTextsTable = {}
end
function AsyncFilterUserTexts(user_texts)
  local set = {}
  local unfiltered_list = {}
  for _, T in ipairs(user_texts) do
    local hash = table.hash(T)
    if (not FilteredTextsTable[hash] or not FilteredTextsTable[hash].filtered) and not set[hash] and T ~= "" then
      set[hash] = true
      table.insert(unfiltered_list, T)
    end
  end
  if not unfiltered_list then
    return false
  end
  local err, filtered_list = _InternalFilterUserTexts(unfiltered_list)
  for T, filteredT in pairs(filtered_list) do
    local hash = table.hash(T)
    FilteredTextsTable[hash] = FilteredTextsTable[hash] or {}
    FilteredTextsTable[hash].filtered = filteredT
  end
  return err
end
function SetCustomFilteredUserText(T, custom_filter_text)
  local hash = table.hash(T)
  FilteredTextsTable[hash] = FilteredTextsTable[hash] or {}
  FilteredTextsTable[hash].custom = custom_filter_text or TDevModeGetEnglishText(T, false, "no_assert")
end
function SetCustomFilteredUserTexts(Ts, custom_filter_texts)
  for i, v in ipairs(Ts) do
    SetCustomFilteredUserText(v, custom_filter_texts and custom_filter_texts[i])
  end
end
function GetFilteredText(T)
  local cache_entry = FilteredTextsTable[table.hash(T)]
  return cache_entry and (cache_entry.filtered or cache_entry.custom)
end
