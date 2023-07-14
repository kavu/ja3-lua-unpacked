DefineClass.SquadName = {
  __parents = {"Preset"},
  properties = {
    {
      id = "Name",
      name = "Name",
      editor = "text",
      default = "",
      translate = true
    },
    {
      id = "ShortName",
      name = "Short Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Context",
      name = "Context",
      editor = "text",
      default = ""
    }
  },
  PropertyTranslation = true,
  HasSortKey = true,
  EditorMenubarName = "SquadNames",
  EditorMenubar = "Editors.Other",
  EditorViewPresetPostfix = Untranslated(" <color 75 105 198><Name>")
}
DefineModItemPreset("SquadName", {EditorName = "SquadName", EditorSubmenu = "Gameplay"})
Affiliations = {
  "AIM",
  "Legion",
  "Army",
  "Beast",
  "Adonis",
  "Rebel",
  "Civilian",
  "Secret",
  "Thugs",
  "Other"
}
GameVar("gv_UsedSquadNameIndexes", {})
function SquadName:GetShortNameFromName(Name)
  local shortName
  local name_id = TGetID(Name)
  ForEachPreset("SquadName", function(preset)
    if TGetID(preset.Name) == name_id then
      shortName = preset.ShortName
      return "break"
    end
  end)
  return shortName or Name
end
function SquadName:GetNewSquadName(side, units)
  local nameType = false
  if side == "player1" or side == "player2" then
    nameType = "Player"
  else
    if not units or not next(units) then
      return Presets.SquadName.Default.Enemy.Name
    end
    local firstUnit = units[1]
    firstUnit = firstUnit and gv_UnitData[firstUnit]
    if firstUnit then
      nameType = firstUnit.Affiliation
    end
  end
  local names = Presets.SquadName[nameType]
  if not names then
    if side ~= "enemy1" then
      return Presets.SquadName.Default.Squad.Name
    end
    return Presets.SquadName.Default.Enemy.Name
  end
  local used = gv_UsedSquadNameIndexes[nameType] or {}
  for _, preset in ipairs(names) do
    if not used[preset.id] then
      used[preset.id] = true
      gv_UsedSquadNameIndexes[nameType] = used
      return preset.Name
    end
  end
  for _, preset in ipairs(names) do
    local nameUsed = false
    for _, squad in ipairs(g_SquadsArray) do
      if TGetID(squad.Name) == TGetID(preset.Name) then
        nameUsed = true
        break
      end
    end
    if not nameUsed then
      return preset.Name
    end
  end
  gv_UsedSquadNameIndexes[nameType] = {
    [names[1].id] = true
  }
  return names[1].Name
end
function SavegameSessionDataFixups.ConvertUsedSquadNamesToPresetIds(data, metadata, lua_ver)
  local to_fixup = data.gvars.gv_UsedSquadNameIndexes
  for group, idx in pairs(to_fixup) do
    local used_ids = {}
    for i = 1, idx do
      used_ids[string.format("Name%02d", i)] = true
    end
    to_fixup[group] = used_ids
  end
end
