if not config.Mods then
  return
end
function ModDef:GetTags()
  local tags_used = {}
  for i, tag in ipairs(PredefinedModTags) do
    if self[tag.id] then
      table.insert(tags_used, tag.display_name)
    end
  end
  return tags_used
end
function CheatTestExploration()
  CreateRealTimeThread(function()
    DbgStartExploration()
  end)
end
function CheatEnable(id, side)
  NetSyncEvent("CheatEnable", id, nil, side)
end
function CheatActivate(id)
  NetSyncEvent(id)
end
function CheatAddMerc(id)
  if table.find(g_Units, "session_id", id) then
    return
  end
  if not next(GetPlayerMercSquads()) then
    DbgStartExploration(nil, {id})
  else
    local ud = gv_UnitData[id]
    ud = ud or CreateUnitData(id, id, InteractionRand(nil, "CheatAddMerc"))
    UIAddMercToSquad(id)
    HiredMercArrived(gv_UnitData[id])
  end
end
function GetItemsIds()
  local items = {}
  ForEachPreset("InventoryItemCompositeDef", function(o)
    table.insert(items, o.id)
  end)
  return items
end
function CheatAddItem(id)
  UIPlaceInInventory(nil, InventoryItemDefs[id])
end
function ModEditorOpen(mod)
  CreateRealTimeThread(function()
    if not IsModEditorMap(CurrentMap) then
      ChangeMap(ModEditorMapName)
      CloseMenuDialogs()
    end
    if mod then
      OpenModEditor(mod)
    else
      local context = {
        dlcs = g_AvailableDlc or {},
        mercs = GetGroupedMercsForCheats(nil, nil, true),
        items = GetItemsIds()
      }
      local ged = OpenGedApp("ModManager", ModsList, context)
      if ged then
        ged:BindObj("log", ModMessageLog)
      end
      if not ModdingHelpShownOnEditorOpen then
        ModdingHelpShownOnEditorOpen = true
        if not Platform.developer then
          GedOpHelpMod()
        end
      end
    end
  end)
end
function OpenModEditor(mod)
  for _, presets in pairs(Presets) do
    PopulateParentTableCache(presets)
  end
  local mod_path = ModConvertSlashes(mod:GetModRootPath())
  local context = {
    mod_items = GedItemsMenu("ModItem"),
    dlcs = g_AvailableDlc or {},
    mod_path = mod_path,
    mod_os_path = ConvertToOSPath(mod_path),
    mod_content_path = mod:GetModContentPath(),
    WarningsUpdateRoot = "root",
    suppress_property_buttons = {
      "GedOpPresetIdNewInstance",
      "GedRpcEditPreset",
      "OpenTagsEditor"
    },
    mercs = GetGroupedMercsForCheats(nil, nil, true),
    items = GetItemsIds()
  }
  Msg("GatherModEditorLogins", context)
  local editor = OpenGedApp("ModEditor", Container:new({mod}), context)
  if editor then
    editor:Send("rfnApp", "SetSelection", "root", {1})
  end
  return editor
end
function CheatSpawnEnemy()
  local p = GetTerrainCursorXY(UIL.GetScreenSize() / 2)
  local freePoint = DbgFindFreePassPositions(p, 1, 20, xxhash(p))
  if not next(freePoint) then
    return
  end
  local unit = SpawnUnit("LegionRaider", tostring(RealTime()), freePoint[1])
  unit:SetSide("enemy1")
end
function ModsUIClosePopup(win)
  local dlg = GetDialog(win)
  local obj = dlg.context
  obj.popup_shown = false
  local wnd = dlg:ResolveId("idPopUp")
  if wnd and wnd.window_state ~= "destroying" then
    wnd:Close()
  end
  dlg:UpdateActionViews(dlg)
  if GetDialog("PreGameMenu") then
    CreateRealTimeThread(function()
      LoadingScreenOpen("idLoadingScreen", "main menu")
      OpenPreGameMainMenu("")
      LoadingScreenClose("idLoadingScreen", "main menu")
    end)
  end
end
function OnMsg.ClassesPreprocess(classdefs)
  UndefineClass("ModItemShelterSlabMaterials")
  UndefineClass("ModItemStoryBit")
  UndefineClass("ModItemStoryBitCategory")
  UndefineClass("ModItemActionFXColorization")
  UndefineClass("ModItemGameValue")
end
DefineModItemPreset("AppearancePreset", {
  EditorName = "Appearance Preset",
  EditorSubmenu = "Unit"
})
if FirstLoad then
  ModsOptionsOriginal = false
end
function ApplyModOptions(modsOptions)
  CreateRealTimeThread(function(modsOptions)
    for _, modOptions in ipairs(modsOptions) do
      local mod = modOptions.__mod
      Msg("ApplyModOptions", mod.id)
      AccountStorage.ModOptions = AccountStorage.ModOptions or {}
      local storage_table = AccountStorage.ModOptions[mod.id] or {}
      for _, prop in ipairs(modOptions:GetProperties()) do
        local value = modOptions:GetProperty(prop.id)
        value = type(value) == "table" and table.copy(value) or value
        storage_table[prop.id] = value
      end
      AccountStorage.ModOptions[mod.id] = storage_table
    end
    ModsOptionsOriginal = false
    SaveAccountStorage(1000)
  end, modsOptions)
end
function CancelModOptions()
  CreateRealTimeThread(function(ModsOptionsOriginal)
    for _, modOriginalOptions in ipairs(ModsOptionsOriginal or {}) do
      local properties = modOriginalOptions:GetProperties()
      for i = 1, #properties do
        local prop = properties[i]
        local original_value = modOriginalOptions:GetProperty(prop.id)
        local mod = table.find_value(ModsLoaded, "id", modOriginalOptions.__mod.id)
        mod.options:SetProperty(prop.id, original_value)
      end
    end
  end, ModsOptionsOriginal)
end
function ModItemOption:GetOptionMeta()
  local display_name = self.DisplayName
  if not display_name or display_name == "" then
    display_name = self.name
  end
  return {
    id = self.name,
    name = T(display_name),
    editor = self.ValueEditor,
    default = self.DefaultValue,
    help = Untranslated(self.Help),
    modId = self.mod.id
  }
end
