DefineClass.Achievement = {
  __parents = {
    "MsgReactionsPreset"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "display_name",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "description",
      name = "Description",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "how_to",
      name = "How To",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "image",
      name = "Image",
      editor = "ui_image",
      default = false
    },
    {
      id = "secret",
      name = "Secret",
      editor = "bool",
      default = false
    },
    {
      id = "target",
      name = "Target",
      editor = "number",
      default = 0
    },
    {
      id = "time",
      name = "Time",
      editor = "number",
      default = 0
    },
    {
      id = "save_interval",
      name = "Save Interval",
      editor = "number",
      default = false
    },
    {
      category = "PS4",
      id = "ps4_trophy_group",
      name = "Trophy Group",
      editor = "preset_id",
      default = "Auto",
      preset_class = "TrophyGroup",
      extra_item = "Auto"
    },
    {
      category = "PS4",
      id = "ps4_used_trophy_group",
      name = "Used Trophy Group",
      editor = "preset_id",
      default = false,
      dont_save = true,
      read_only = true,
      no_edit = function(self)
        return self:GetTrophyGroup("ps4") == ""
      end,
      no_validate = true,
      preset_class = "TrophyGroup"
    },
    {
      category = "PS4",
      id = "ps4_duplicate",
      name = "Duplicate",
      editor = "buttons",
      default = false,
      dont_save = true
    },
    {
      category = "PS4",
      id = "ps4_id",
      name = "Trophy Id",
      editor = "number",
      default = -1,
      no_edit = function(self)
        return self:GetTrophyGroup("ps4") == ""
      end,
      buttons = {
        {
          name = "Generate",
          func = "GenerateTrophyIDs"
        }
      },
      min = -1,
      max = 128
    },
    {
      category = "PS4",
      id = "ps4_grade",
      name = "Grade",
      editor = "choice",
      default = "bronze",
      no_edit = function(self)
        return self:GetTrophyGroup("ps4") == ""
      end,
      items = function(self)
        return PlayStationTrophyGrades
      end
    },
    {
      category = "PS4",
      id = "ps4_points",
      name = "Points",
      editor = "number",
      default = false,
      dont_save = true,
      read_only = true,
      no_edit = function(self)
        return self:GetTrophyGroup("ps4") == ""
      end
    },
    {
      category = "PS4",
      id = "ps4_grouppoints",
      name = "Group Points",
      help = "Total sum for the base game should be 950 - 1050. For each expansion <= 200.",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true,
      no_edit = function(self)
        return self:GetTrophyGroup("ps4") == ""
      end
    },
    {
      category = "PS4",
      id = "ps4_icon",
      name = "Icon",
      editor = "ui_image",
      default = "",
      dont_save = true,
      read_only = true,
      no_edit = function(self)
        return self:GetTrophyGroup("ps4") == ""
      end,
      no_validate = true,
      filter = "All files|*.png"
    },
    {
      category = "PS4",
      id = "ps4_platinum_linked",
      name = "Platinum Linked",
      editor = "bool",
      default = true,
      no_edit = function(self)
        local trophy_group_0 = GetTrophyGroupById("ps4", 0)
        return self:GetTrophyGroup("ps4") ~= trophy_group_0 or self.ps4_grade == "platinum"
      end
    },
    {
      category = "PS5",
      id = "ps5_trophy_group",
      name = "Trophy Group",
      editor = "preset_id",
      default = "Auto",
      preset_class = "TrophyGroup",
      extra_item = "Auto"
    },
    {
      category = "PS5",
      id = "ps5_used_trophy_group",
      name = "Used Trophy Group",
      editor = "preset_id",
      default = false,
      dont_save = true,
      read_only = true,
      no_edit = function(self)
        return self:GetTrophyGroup("ps5") == ""
      end,
      no_validate = true,
      preset_class = "TrophyGroup"
    },
    {
      category = "PS5",
      id = "ps5_id",
      name = "Trophy Id",
      editor = "number",
      default = -1,
      no_edit = function(self)
        return self:GetTrophyGroup("ps5") == ""
      end,
      buttons = {
        {
          name = "Generate",
          func = "GenerateTrophyIDs"
        }
      },
      min = -1,
      max = 128
    },
    {
      category = "PS5",
      id = "ps5_grade",
      name = "Grade",
      editor = "choice",
      default = "bronze",
      no_edit = function(self)
        return self:GetTrophyGroup("ps4") == ""
      end,
      items = function(self)
        return PlayStationTrophyGrades
      end
    },
    {
      category = "PS5",
      id = "ps5_points",
      name = "Points",
      editor = "number",
      default = false,
      dont_save = true,
      read_only = true,
      no_edit = function(self)
        return self:GetTrophyGroup("ps4") == ""
      end
    },
    {
      category = "PS5",
      id = "ps5_grouppoints",
      name = "Group Points",
      help = "Total sum for the base game should be 950 - 1050. For each expansion <= 200.",
      editor = "number",
      default = false,
      dont_save = true,
      read_only = true,
      no_edit = function(self)
        return self:GetTrophyGroup("ps4") == ""
      end
    },
    {
      category = "PS5",
      id = "ps5_icon",
      name = "Icon",
      editor = "ui_image",
      default = "",
      dont_save = true,
      read_only = true,
      no_edit = function(self)
        return self:GetTrophyGroup("ps4") == ""
      end,
      no_validate = true,
      filter = "All files|*.png"
    },
    {
      category = "Xbox",
      id = "xbox_id",
      name = "Achievement Id",
      editor = "number",
      default = -1
    },
    {
      category = "Steam",
      id = "steam_id",
      name = "Steam Id",
      help = "If not specified, the id of the preset will be used.",
      editor = "text",
      default = false
    },
    {
      category = "Epic",
      id = "epic_id",
      name = "Epic Id",
      help = "If not specified, the id of the preset will be used.",
      editor = "text",
      default = false
    },
    {
      category = "Epic",
      id = "flavor_text",
      name = "Flavor text",
      editor = "text",
      default = false,
      translate = true
    }
  },
  HasSortKey = true,
  GlobalMap = "AchievementPresets",
  EditorMenubarName = "Achievements",
  EditorIcon = "CommonAssets/UI/Icons/top trophy winner.png",
  EditorMenubar = "Editors.Lists"
}
function Achievement:GetCompleteText()
  local unlocked = GetAchievementFlags(self.id)
  return unlocked and self.description or self.how_to
end
function Achievement:GetTrophyGroup(platform)
  local group_name_field = platform .. "_trophy_group"
  if self[group_name_field] ~= "Auto" then
    return self[group_name_field]
  end
  local trophies = PresetArray(Achievement, function(achievement)
    return achievement.SaveIn == self.save_in
  end)
  if #trophies ~= 0 then
    for i = #trophies, 1, -1 do
      local group = trophies[i][group_name_field]
      if group ~= "" and group ~= "Auto" then
        return group
      end
    end
  end
  local group = FindPreset("TrophyGroup", self.save_in)
  if group then
    return group.id
  end
  local dlc = FindPreset("DLCConfig", self.save_in)
  local handling_field = platform .. "_handling"
  if dlc and dlc[handling_field] ~= "Embed" then
    return ""
  end
  return GetTrophyGroupById(platform, 0)
end
function Achievement:IsBaseGameTrophy(platform)
  local group = self:GetTrophyGroup(platform)
  return group ~= "" and TrophyGroupPresets[group]:IsBaseGameGroup(platform)
end
function Achievement:IsPlatinumLinked(platform)
  local trophy_group_0 = GetTrophyGroupById(platform, 0)
  local trophy_group = self:GetTrophyGroup(platform)
  local platinum_linked = trophy_group == trophy_group_0 and self[platform .. "_grade"] ~= "platinum"
  if platform == "ps4" and platinum_linked then
    platinum_linked = self.ps4_platinum_linked
  end
  return platinum_linked
end
function Achievement:IsCurrentlyUsed()
  return Platform.steam and self.steam_id or Platform.epic and self.epic_id or Platform.ps4 and self.ps4_id >= 0 or Platform.ps5 and 0 <= self.ps5_id or Platform.xbox and 0 < self.xbox_id or Platform.pc and (self.image or self.msg_reactions)
end
function Achievement:GenerateTrophyIDs(root, prop_id)
  local platform = string.match(prop_id, "(.*)_id")
  local trophy_id_field = prop_id
  local group_id_field = platform .. "_gid"
  local trophies = PresetArray(Achievement, function(achievement)
    return achievement:GetTrophyGroup(platform) ~= ""
  end)
  local trophies_by_group = {}
  for _, trophy in ipairs(trophies) do
    local group = TrophyGroupPresets[trophy:GetTrophyGroup(platform)]
    local group_id = group[group_id_field]
    trophies_by_group[group_id] = trophies_by_group[group_id] or {}
    local group_trophies = trophies_by_group[group_id]
    group_trophies[#group_trophies + 1] = trophy
  end
  local trophy_id = 0
  for _, group_trophies in sorted_pairs(trophies_by_group) do
    for _, trophy in ipairs(group_trophies) do
      if trophy[trophy_id_field] ~= trophy_id then
        trophy[trophy_id_field] = trophy_id
        trophy:MarkDirty()
      end
      trophy_id = trophy_id + 1
    end
  end
end
function Achievement:Getps4_grouppoints()
  local group = self:GetTrophyGroup("ps4")
  local group_points = CalcTrophyGroupPoints(group, "ps4")
  local trophy_group_0 = GetTrophyGroupById("ps4", 0)
  if group == trophy_group_0 then
    local platinum_linked_points = CalcTrophyPlatinumLinkedPoints("ps4")
    if platinum_linked_points ~= group_points then
      return string.format("%d + %d", platinum_linked_points, group_points - platinum_linked_points)
    end
  end
  return tostring(group_points)
end
function Achievement:Getps4_used_trophy_group()
  return self:GetTrophyGroup("ps4")
end
function Achievement:Getps4_points()
  return TrophyGradesPlayStationPoints[self.ps4_grade] or 0
end
function Achievement:Getps4_icon()
  local _, icon_path = GetPlayStationTrophyIcon(self, "ps4")
  return icon_path
end
function Achievement:Getps5_used_trophy_group()
  return self:GetTrophyGroup("ps4")
end
function Achievement:Getps5_points()
  return TrophyGradesPlayStationPoints[self.ps5_grade] or 0
end
function Achievement:Getps5_grouppoints()
  return CalcTrophyGroupPoints(self:GetTrophyGroup("ps5"), "ps5")
end
function Achievement:Getps5_icon()
  local _, icon_path = GetPlayStationTrophyIcon(self, "ps5")
  return icon_path
end
function Achievement:GetError(platform)
  local errors = {}
  local ShouldTestPlatform = function(test_platform)
    return not platform or platform == test_platform
  end
  local trophies = PresetArray(Achievement)
  local GetPlayStationErrors = function(platform)
    local trophy_id_field = platform .. "_id"
    local self_trophy_id = self[trophy_id_field]
    if self.id == "PlatinumTrophy" and self_trophy_id ~= 0 then
      errors[#errors + 1] = string.format("%s platinum trophy's id must be 0!", string.upper(platform))
    elseif self:GetTrophyGroup(platform) ~= "" and self_trophy_id < 0 then
      errors[#errors + 1] = string.format("Missing %s trophy id!", platform)
    elseif 0 <= self_trophy_id then
      table.sortby_field(trophies, trophy_id_field)
      local next_trophy_id = 0
      local trophy_id_holes = {}
      for _, trophy in ipairs(trophies) do
        local curr_trophy_id = trophy[trophy_id_field]
        if self_trophy_id > next_trophy_id and 0 <= curr_trophy_id then
          if next_trophy_id < curr_trophy_id then
            if 1 < curr_trophy_id - next_trophy_id then
              trophy_id_holes[#trophy_id_holes + 1] = string.format("%d-%d", next_trophy_id, curr_trophy_id)
            else
              trophy_id_holes[#trophy_id_holes + 1] = next_trophy_id
            end
          end
          next_trophy_id = curr_trophy_id + 1
        end
        if self ~= trophy and self_trophy_id == curr_trophy_id then
          errors[#errors + 1] = string.format("Duplicated %s trophy id (%s)!", platform, trophy.id)
        end
      end
      if #trophy_id_holes ~= 0 then
        errors[#errors + 1] = string.format("%s trophy ids are not consecutive, missing %s!", string.upper(platform), table.concat(trophy_id_holes, ", "))
      end
    end
  end
  if ShouldTestPlatform("ps4") then
    GetPlayStationErrors("ps4")
  end
  if ShouldTestPlatform("ps5") then
    GetPlayStationErrors("ps5")
  end
  return #errors ~= 0 and table.concat(errors, "\n")
end
function Achievement:GetWarning(platform)
  local warnings = {}
  local ShouldTestPlatform = function(test_platform)
    return (not platform or platform == test_platform) and self:GetTrophyGroup(test_platform) ~= ""
  end
  local GetPlayStationWarnings = function(platform)
    local is_placeholder, icon_path = GetPlayStationTrophyIcon(self, platform)
    if is_placeholder then
      warnings[#warnings + 1] = string.format("Missing %s trophy icon (placeholder used): %s", platform, icon_path)
    end
    local group = self:GetTrophyGroup(platform)
    local group_points = CalcTrophyGroupPoints(group, platform)
    local trophy_group_0 = GetTrophyGroupById(platform, 0)
    if trophy_group_0 == group then
      local platinum_linked_points = CalcTrophyPlatinumLinkedPoints(platform)
      local min, max = GetTrophyBaseGameNonPlatinumLinkedPointsRange(platform)
      local non_platinum_linked_points = group_points - platinum_linked_points
      if min > non_platinum_linked_points or max < non_platinum_linked_points then
        warnings[#warnings + 1] = string.format("%s non platinum linked trophy points sum in base group is not between %d and %d.", string.upper(platform), min, max)
      end
      group_points = platinum_linked_points
    end
    local min, max = GetTrophyGroupPointsRange(group, platform)
    if group_points < min or group_points > max then
      warnings[#warnings + 1] = string.format("%s trophy group points sum is not between %d and %d.", string.upper(platform), min, max)
    end
  end
  if ShouldTestPlatform("ps4") then
    GetPlayStationWarnings("ps4")
  end
  if ShouldTestPlatform("ps5") then
    GetPlayStationWarnings("ps5")
  end
  if ShouldTestPlatform("ps5") then
    if #self.id > 32 then
      warnings[#warnings + 1] = string.format("Trophy Id maximum length is 32 (< %d)!", #self.id)
    end
    if string.find(self.id, "[^%w]") then
      warnings[#warnings + 1] = "Trophy Id contains non-alphanumeric characters!"
    end
  end
  return #warnings ~= 0 and table.concat(warnings, "\n")
end
function Achievement:SaveAll(...)
  ForEachPreset(Achievement, function(trophy)
    if trophy:GetTrophyGroup("ps4") == "" then
      trophy:MarkDirty()
      trophy.ps4_id = -1
    end
    if trophy:GetTrophyGroup("ps5") == "" then
      trophy:MarkDirty()
      trophy.ps5_id = -1
    end
  end)
  Preset.SaveAll(self, ...)
end
DefineClass.DLCConfig = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "General",
      id = "display_name",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      category = "General",
      id = "description",
      name = "Description",
      editor = "text",
      default = false,
      translate = true
    },
    {
      category = "General",
      id = "required_lua_revision",
      editor = "number",
      default = 237259
    },
    {
      category = "General",
      id = "pre_load",
      editor = "func",
      default = function(self)
        if not IsDlcOwned(self) then
          return "remove"
        end
      end
    },
    {
      category = "General",
      id = "post_load",
      editor = "func",
      default = function(self)
        g_AvailableDlc[self.name] = true
      end
    },
    {
      category = "Build Steam",
      id = "steam_dlc_id",
      name = "Steam DLC Id",
      editor = "number",
      default = false
    },
    {
      category = "Build Pops",
      id = "pops_dlc_id",
      name = "Pops DLC Id",
      editor = "text",
      default = false
    },
    {
      category = "Build Epic",
      id = "epic_dlc_id",
      name = "Artifact Id",
      editor = "text",
      default = false
    },
    {
      category = "Build Epic",
      id = "epic_catalog_dlc_id",
      name = "Catalog Id",
      editor = "text",
      default = false
    },
    {
      category = "Build",
      id = "generate_build_rule",
      name = "Generate Build Rule",
      help = "With name Dlc%Id%",
      editor = "bool",
      default = false
    },
    {
      category = "Build",
      id = "deprecated",
      name = "Deprecated",
      help = "Used only for compatibility",
      editor = "bool",
      default = false
    },
    {
      category = "Build",
      id = "generate_art_folders",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Locate PS4 Art",
          func = "LocatePS4Art"
        },
        {
          name = "LocateXboxArt",
          func = "LocateXboxArt"
        }
      }
    },
    {
      category = "Build",
      id = "ext_name",
      help = "(optional) name of executables",
      editor = "text",
      default = false
    },
    {
      category = "Build",
      id = "lua",
      help = "If the Dlc should include Lua.hpk",
      editor = "bool",
      default = false
    },
    {
      category = "Build",
      id = "data",
      help = "If the Dlc should include Data.hpk",
      editor = "bool",
      default = false
    },
    {
      category = "Build",
      id = "localization",
      help = "If the Dlc should include latest localization packfiles",
      editor = "bool",
      default = false
    },
    {
      category = "Build",
      id = "nonentitytextures",
      help = "If the Dlc should include all post release non-entity textures, texture lists and bin assets",
      editor = "bool",
      default = false
    },
    {
      category = "Build",
      id = "entitytextures",
      help = "If the Dlc should include all post release entity textures and texture lists",
      editor = "bool",
      default = false
    },
    {
      category = "Build",
      id = "ui",
      help = "If the Dlc should include UI.hpk",
      editor = "bool",
      default = false
    },
    {
      category = "Build",
      id = "shaders",
      help = "If the Dlc should include lastest shader packs.",
      editor = "bool",
      default = false
    },
    {
      category = "Build",
      id = "sounds",
      help = "If the Dlc should include the latest Sounds.hpk",
      editor = "bool",
      default = false
    },
    {
      category = "Build",
      id = "content_dep",
      help = "List of rules to be build before the content.hpk is packed (e.g. BinAssets)",
      editor = "prop_table",
      default = {}
    },
    {
      category = "Build",
      id = "content_files",
      help = "Files added to the dlc content.hpk (e.g. PatchTextures.hpk, etc.)",
      editor = "nested_list",
      default = false,
      base_class = "DLCConfigContentFile",
      inclusive = true
    },
    {
      category = "BuildPS4",
      id = "ps4_handling",
      name = "Handling",
      help = [[
Enable - Creates a full dlc package
Embed - Creates only a .hpk to be embedded in the main game package
Exclude - Not shipped on this platform]],
      editor = "combo",
      default = "Exclude",
      items = function(self)
        return {
          "Enable",
          "Embed",
          "Exclude"
        }
      end
    },
    {
      category = "BuildPS4",
      id = "ps4_label",
      name = "Label",
      editor = "text",
      default = false,
      no_edit = function(self)
        return self.ps4_handling ~= "Enable"
      end
    },
    {
      category = "BuildPS4",
      id = "ps4_version",
      name = "Version",
      editor = "text",
      default = "01.00",
      no_edit = function(self)
        return self.ps4_handling ~= "Enable"
      end
    },
    {
      category = "BuildPS4",
      id = "ps4_entitlement_key",
      name = "Entitlement Key",
      help = "Unique 16 byte key. Will be automatically generated. Must be kept secret and not regenerated after certification.",
      editor = "text",
      default = false,
      read_only = true,
      no_edit = function(self)
        return self.ps4_handling ~= "Enable"
      end
    },
    {
      category = "BuildPS5",
      id = "ps5_handling",
      name = "Handling",
      help = [[
Enable - Creates a full dlc package
Embed - Creates only a .hpk to be embedded in the main game package
Exclude - Not shipped on this platform]],
      editor = "combo",
      default = "Exclude",
      items = function(self)
        return {
          "Enable",
          "Embed",
          "Exclude"
        }
      end
    },
    {
      category = "BuildPS5",
      id = "ps5_label",
      name = "Label",
      editor = "text",
      default = false,
      no_edit = function(self)
        return self.ps5_handling ~= "Enable"
      end
    },
    {
      category = "BuildPS5",
      id = "ps5_master_version",
      name = "Master Version",
      editor = "text",
      default = "01.00",
      no_edit = function(self)
        return self.ps5_handling ~= "Enable"
      end
    },
    {
      category = "BuildPS5",
      id = "ps5_content_version",
      name = "Content Version",
      editor = "text",
      default = "01.000.000",
      no_edit = function(self)
        return self.ps5_handling ~= "Enable"
      end
    },
    {
      category = "BuildPS5",
      id = "ps5_entitlement_key",
      name = "Entitlement Key",
      help = "Unique 16 byte key. Will be automatically generated. Must be kept secret and not regenerated after certification.",
      editor = "text",
      default = false,
      read_only = true,
      no_edit = function(self)
        return self.ps5_handling ~= "Enable"
      end
    },
    {
      category = "BuildXbox",
      id = "xbox_handling",
      name = "Handling",
      help = [[
Enable - Creates a full dlc package
Embed - Creates only a .hpk to be embedded in the main game package
Exclude - Not shipped on this platform]],
      editor = "combo",
      default = "Exclude",
      items = function(self)
        return {
          "Enable",
          "Embed",
          "Exclude"
        }
      end
    },
    {
      category = "BuildXbox",
      id = "xbox_name",
      editor = "text",
      default = false,
      no_edit = function(self)
        return self.xbox_handling ~= "Enable"
      end
    },
    {
      category = "BuildXbox",
      id = "xbox_store_id",
      editor = "text",
      default = false,
      no_edit = function(self)
        return self.xbox_handling ~= "Enable"
      end
    },
    {
      category = "BuildXbox",
      id = "xbox_display_name",
      editor = "text",
      default = false,
      no_edit = function(self)
        return self.xbox_handling ~= "Enable"
      end
    },
    {
      category = "BuildXbox",
      id = "xbox_identity",
      editor = "text",
      default = false,
      no_edit = function(self)
        return self.xbox_handling ~= "Enable"
      end
    },
    {
      category = "BuildXbox",
      id = "xbox_version",
      editor = "text",
      default = "1.0.0.0",
      no_edit = function(self)
        return self.xbox_handling ~= "Enable"
      end
    },
    {
      category = "BuildWindowsStore",
      id = "ws_identity_name",
      editor = "text",
      default = false
    },
    {
      category = "BuildWindowsStore",
      id = "ws_version",
      editor = "text",
      default = "1.0.0.0"
    },
    {
      category = "BuildWindowsStore",
      id = "ws_store_id",
      editor = "text",
      default = false
    },
    {
      id = "SaveIn",
      editor = "text",
      default = false,
      read_only = true,
      no_edit = true
    },
    {
      category = "Build",
      id = "public",
      help = "information from/about this DLC can be made public",
      editor = "bool",
      default = false
    },
    {
      category = "Build",
      id = "split_files",
      help = "These files will be split and added to the DLC.",
      editor = "string_list",
      default = {},
      item_default = "",
      items = false,
      arbitrary_value = true
    }
  },
  HasCompanionFile = true,
  SingleFile = false,
  EditorMenubarName = "DLC config",
  EditorIcon = "CommonAssets/UI/Icons/add buy cart plus.png",
  EditorMenubar = "DLC",
  save_in = "future"
}
function DLCConfig:GetEditorView()
  local str = self.id
  if self.generate_build_rule then
    str = str .. " <color 0 128 128>build</color>"
  end
  if self.deprecated then
    str = str .. " <color 128 128 0>deprecated</color>"
  end
  if self.Comment ~= "" then
    str = str .. " <color 0 128 0>" .. self.Comment .. "</color>"
  end
  return str
end
function DLCConfig:LocatePS4Art(root)
  local folder = "svnAssets/Source/ps4/" .. root.id .. "/"
  local files = {"icon0.png"}
  if not io.exists(folder) then
    io.createpath(folder)
  end
  for _, file in ipairs(files) do
    local path = folder .. file
    if not io.exists(path) then
      CopyFile("CommonAssets/Images/Achievements/PS4/ICON0.PNG", path)
    end
  end
  OS_LocateFile(folder)
end
function DLCConfig:LocateXboxArt(root)
  local folder = "svnAssets/Source/xbox/" .. root.id .. "/"
  local files = {
    "Logo.png",
    "SmallLogo.png",
    "WideLogo.png"
  }
  if not io.exists(folder) then
    io.createpath(folder)
  end
  for _, file in ipairs(files) do
    local path = folder .. file
    if not io.exists(path) then
      CopyFile("CommonAssets/Images/Achievements/PS4/ICON0.PNG", path)
    end
  end
  OS_LocateFile(folder)
end
function DLCConfig:GetCompanionFileSavePath(save_path)
  local dlc_id = string.match(save_path, "(%w+)%.lua")
  dlc_id = dlc_id or "unknown"
  return "svnProject/Dlc/" .. self.id .. "/autorun.lua"
end
function DLCConfig:GenerateCompanionFileCode(code)
  local autorun_template = {
    name = self.id,
    deprecated = self.deprecated or nil,
    display_name = self.display_name,
    required_lua_revision = self.required_lua_revision,
    ps4_trophy_group_description = self.ps4_trophy_group_description,
    ps5_trophy_group_description = self.ps5_trophy_group_description,
    steam_dlc_id = self.steam_dlc_id,
    pops_dlc_id = self.pops_dlc_id,
    epic_dlc_id = self.epic_dlc_id,
    epic_catalog_dlc_id = self.epic_catalog_dlc_id,
    ps4_label = self.ps4_label,
    ps5_label = self.ps5_label,
    ps4_gid = self.ps4_gid,
    ps5_gid = self.ps5_gid,
    pre_load = self.pre_load,
    post_load = self.post_load
  }
  code:append("return ")
  code:append(TableToLuaCode(autorun_template))
end
function DLCConfig:SaveAll(...)
  local class = self.PresetClass or self.class
  local dlcs = PresetArray(class)
  local PlayStationGenerateEntitlementKeys = function(additional_contents, platform)
    local handling = platform .. "_handling"
    local entitlement_key = platform .. "_entitlement_key"
    local used_entitlement_keys = {}
    for _, additional_content in ipairs(additional_contents) do
      if additional_content[entitlement_key] then
        used_entitlement_keys[additional_content[entitlement_key]] = true
      end
    end
    for _, additional_content in ipairs(additional_contents) do
      if additional_content[handling] == "Enable" and not additional_content[entitlement_key] then
        repeat
          additional_content[entitlement_key] = random_hex(128)
        until not used_entitlement_keys[additional_content[entitlement_key]]
        used_entitlement_keys[additional_content[entitlement_key]] = true
        additional_content:MarkDirty()
      end
    end
  end
  PlayStationGenerateEntitlementKeys(dlcs, "ps4")
  PlayStationGenerateEntitlementKeys(dlcs, "ps5")
  Preset.SaveAll(self, ...)
  local epic_ids = {}
  ForEachPreset(class, function(preset, group)
    local epic_catalog_dlc_id = preset.epic_catalog_dlc_id
    if (epic_catalog_dlc_id or "") ~= "" then
      epic_ids[#epic_ids + 1] = epic_catalog_dlc_id
    end
  end)
  local text = string.format("%sg_EpicDlcIds = %s", exported_files_header_warning, TableToLuaCode(epic_ids))
  local path = "svnProject/Lua/EpicDlcIds.lua"
  local err = SaveSVNFile(path, text)
  if err then
    printf("Failed to save %s: %s", path, err)
  end
end
DefineClass.DLCConfigContentFile = {
  __parents = {
    "PropertyObject"
  },
  properties = {
    {
      id = "Source",
      editor = "text",
      default = ""
    },
    {
      id = "Destination",
      editor = "text",
      default = ""
    }
  }
}
DefineClass.GradingLUTSource = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Input",
      id = "src_path",
      name = "Path",
      editor = "browse",
      default = false,
      folder = "svnAssets/Source/Textures/LUTs",
      filter = "LUT (*.cube)|*.cube"
    },
    {
      category = "Output",
      id = "name",
      name = "Name",
      editor = "text",
      default = false
    },
    {
      category = "Output",
      id = "size",
      name = "Size",
      editor = "number",
      default = false,
      dont_save = true,
      read_only = true
    },
    {
      category = "Output",
      id = "color_space",
      name = "Color Space",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true
    },
    {
      category = "Output",
      id = "color_gamma",
      name = "Color Gamma",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true
    },
    {
      category = "Output",
      id = "dst_path",
      name = "Path",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true,
      buttons = {
        {
          name = "Locate",
          func = "LUT_LocateFile"
        }
      }
    }
  },
  GlobalMap = "GradingLUTs",
  EditorMenubarName = "Grading LUTs",
  EditorMenubar = "Editors.Art",
  dst_dir = "svnAssets/Bin/win32/Textures/LUTs/"
}
function GradingLUTSource:OnPreSave()
  if self:IsDirty() then
    self:OnSrcChange()
  end
end
function GradingLUTSource:Getsize()
  return hr.ColorGradingLUTSize
end
function GradingLUTSource:Getcolor_space()
  return GetColorSpaceName(hr.ColorGradingLUTColorSpace)
end
function GradingLUTSource:Getcolor_gamma()
  return GetColorGammaName(hr.ColorGradingLUTColorGamma)
end
function GradingLUTSource:SaveAll(...)
  Preset.SaveAll(self, ...)
  CleanGradingLUTsDir()
end
function GradingLUTSource:OnSrcChange()
  CreateRealTimeThread(function(self)
    if not io.exists(self.dst_dir) then
      local err = AsyncCreatePath(self.dst_dir)
      if err then
        print(string.format("Could not create path %s: err", self.dst_dir, err))
      end
      SVNAddFile(self.dst_dir)
    end
    local dst_path = self:Getdst_path()
    ImportColorGradingLUT(self:Getsize(), dst_path, self.src_path)
    Sleep(3000)
    SVNAddFile(dst_path)
    SVNAddFile(self.src_path)
  end, self)
end
function GradingLUTSource:Getdst_path()
  return string.format("%s%s.dds", self.dst_dir, self.name)
end
function GradingLUTSource:GetError()
  local errors = {}
  if not self.src_path then
    errors[#errors + 1] = "Missing input path."
  elseif not io.exists(self.src_path) then
    errors[#errors + 1] = "Invalid input path."
  end
  return #errors ~= 0 and table.concat(errors, "\n")
end
if Platform.pc and Platform.developer then
  function CleanGradingLUTsDir()
    if not IsFSUnpacked() then
      return
    end
    local err, processed_luts = AsyncListFiles(GradingLUTSource.dst_dir, "*.dds", "relative")
    if err then
      print(string.format("[GradingLUTs] Failed listing processed LUTs: %s", err))
    end
    for _, lut in pairs(GradingLUTs) do
      table.remove_entry(processed_luts, lut.name .. ".dds")
    end
    for _, lut in ipairs(processed_luts) do
      local lut_path = GradingLUTSource.dst_dir .. lut
      local err = AsyncFileDelete(lut_path)
      if err then
        print(string.format("[GradingLUTs] Failed deleting %s: %s", lut_path, err))
      else
        SVNDeleteFile(lut_path)
      end
    end
  end
  function OnMsg.DataLoaded()
    if not IsFSUnpacked() then
      return
    end
    for _, lut in pairs(GradingLUTs) do
      local src_timestamp, src_err = io.getmetadata(lut.src_path, "modification_time")
      if src_err then
        print(string.format("[GradingLUTs] Failed checking %s for modification: %s", lut.src_path, src_err))
      else
        local dst_timestamp, dst_err = io.getmetadata(lut:Getdst_path(), "modification_time")
        if dst_err or src_timestamp > dst_timestamp then
          lut:OnSrcChange()
        end
      end
    end
    CleanGradingLUTsDir()
  end
  function LUT_LocateFile(preset)
    OS_LocateFile(preset:Getdst_path())
  end
end
DefineClass.PlayStationActivities = {
  __parents = {
    "MsgReactionsPreset"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "title",
      name = "Title",
      help = "The name of the challenge. This field can be localized.",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "description",
      name = "Description",
      help = "The description of the challenge. This field can be localized.",
      editor = "text",
      default = false,
      translate = true,
      wordwrap = true,
      lines = 3,
      max_lines = 10
    },
    {
      id = "_openEndedHelp",
      help = "An open-ended activity has no specific completion objective. It ends when the player chooses to end it. For example, batting practice in MLB\194\174 The Show\226\132\162, build mode in Dreams, or realms in God of War.\n\nOpen-ended activities can contain tasks and subtasks that can be used to track optional objectives within the activity.\n\nThe system handles open-ended activities like progress activities, but when an open-ended activity ends, any result sent is ignored.\n\nJust like progress activities, results for single-player activities can be passed using UDS events. You must use the matches API to pass results for open-ended activities that are being played in multiplayer scenarios.",
      editor = "help",
      default = false,
      dont_save = true,
      read_only = true,
      no_edit = function(self)
        return self.category ~= "openEnded"
      end
    },
    {
      id = "_progressHelp",
      help = [[
A progress activity is defined as any activity that requires the player to complete an objective or series of objectives in order to complete the activity. For example, chapters in Uncharted, or quests in Horizon Zero Dawn.

Progress activities can optionally contain tasks and subtasks that players can use to understand what they should do next and track how close they are to completing an activity. See Tasks and Subtasks for more information on how these can be used.

Progress activities must have a result when ended. For single-player progress activities, the game can set the result to COMPLETED, FAILED, or ABANDONED and pass this result back to the platform by means of the UDS activityEnd event. If you end a progress activity as COMPLETED or FAILED, it is written into the player's history and progress is reset for the next instance.

Note:
These outcomes are automatically tagged on any publicly available UGC that is created. In the case of successful completion, this UGC can be surfaced to other players who are at the same point in the game as a form of help or walkthrough.

For the multiplayer match case, SUCCESS or FAILED are the only supported results. You must use the matches API to pass these results. If you want to make an activity no longer active while retaining its progress, you must move the match to ONHOLD through its status property.]],
      editor = "help",
      default = false,
      dont_save = true,
      read_only = true,
      no_edit = function(self)
        return self.category ~= "progress"
      end
    },
    {
      id = "category",
      name = "Category",
      editor = "choice",
      default = "openEnded",
      items = function(self)
        return {"openEnded", "progress"}
      end
    },
    {
      id = "default_playtime_estimate",
      name = "Default Playtime Estimate (minutes)",
      help = "The default playtime estimate is displayed in System UI when the system has not determined the estimated playtime. Once the system determines the estimated playtime, the value may be switched over from the default playtime that is specified. You can specify the time in minute at the activity, task and subtask level.\n\226\128\162 When the category is not \"challenge\", allow the value at 5-minute intervals. (e.g. 5, 10, 15);\n\226\128\162 When the category is \"challenge\", allow the value at 1-minute intervals (e.g. 1, 2, 3);\n\226\128\162 When the type is \"task\" or \"subTask\", allow the value at 1-minute intervals (e.g. 1, 2, 3).",
      editor = "number",
      default = false,
      step = 5,
      min = 0
    },
    {
      id = "available_by_default",
      name = "Available By Default",
      help = "When set to true, this automatically sets the availability of an activity to available. Use this for any activity that the player can play from the very first time they launch the game. For players who have the Spoiler Warning set to warn on \"Everything You Haven't Seen Yet\", this setting instructs the Spoiler service to ignore this activity as containing any spoilers, even when it hasn't yet been seen by the user.",
      editor = "bool",
      default = true
    },
    {
      id = "hidden_by_default",
      name = "Hidden By Default",
      help = "When set to true, this activity, task, or subtask is considered a spoiler throughout the UX of the platform, until it becomes available, started, or ended for the player. This means that players see a spoiler flag on any user-generated content containing this activity, task, or subtask if they have not encountered it in the game yet. Additionally, if a friend is playing a hidden activity that the player hasn't encountered yet, the card is obscured for the player when viewed on the friend's profile.",
      editor = "bool",
      default = false
    },
    {
      id = "is_required_for_completion",
      name = "Required For Completion",
      help = "This is used to determine if the player must complete the activity to complete the main story and to pass the activities TRC if your game has a main story. Primarily, this is used to determine the sorting of activities, as activities with isRequiredforCompletion set to true that the player has never completed are more likely to be suggested to the player. In addition, this can be set on tasks. When completed, those tasks are treated as part of the progress of the activity, ultimately controlling the completion percentage progress bars. If set to false, then tasks are ignored in the completion percentage progress bar giving you more granular control of those bars. You cannot set this value on subtasks. All subtasks are considered required for completion.",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return self.category ~= "progress"
      end
    },
    {
      id = "abandon_on_done_map",
      name = "Abandon on DoneMap",
      editor = "bool",
      default = false
    },
    {
      id = "Launch",
      name = "Launch",
      editor = "func",
      default = function(self)
      end
    },
    {
      id = "fullscreen_image",
      name = "Fullscreen Image",
      help = "\226\128\162 Dimension : 3840x2160 px\n\226\128\162 Image Format : PNG\n\226\128\162 24-bit non-Interlaced\n\226\128\162 Full screen image used",
      editor = "ui_image",
      default = false,
      dont_save = true,
      read_only = true,
      no_validate = true
    },
    {
      id = "card_image",
      name = "Card Image",
      help = "Image used on action cards representing the game or challenge and in notifications triggered for a challenge.\n\226\128\162 Dimension : 864x1040 px\n\226\128\162 Image Format : PNG\n\226\128\162 24 bit non-Interlaced",
      editor = "ui_image",
      default = false,
      dont_save = true,
      read_only = true,
      no_validate = true
    }
  },
  GlobalMap = "ActivitiesPresets",
  EditorMenubarName = "PlayStation Activities",
  EditorMenubar = "Editors.Other"
}
function PlayStationActivities:Getfullscreen_image()
  return string.format("svnAssets/Source/Images/Activities/%s_fullscreen.png", self.id)
end
function PlayStationActivities:Getcard_image()
  return string.format("svnAssets/Source/Images/Activities/%s_card.png", self.id)
end
function PlayStationActivities:Start()
  AsyncPlayStationActivityStart(self.id)
  AccountStorage.PlayStationStartedActivities[self.id] = true
  SaveAccountStorage(5000)
end
function PlayStationActivities:IsActive()
  return AccountStorage.PlayStationStartedActivities[self.id]
end
function PlayStationActivities:Complete()
  AsyncPlayStationActivityEnd(self.id, const.PlayStationActivityOutcomeCompleted)
  AccountStorage.PlayStationStartedActivities[self.id] = nil
  SaveAccountStorage(5000)
end
function PlayStationActivities:Fail()
  AsyncPlayStationActivityEnd(self.id, const.PlayStationActivityOutcomeFailed)
  AccountStorage.PlayStationStartedActivities[self.id] = nil
  SaveAccountStorage(5000)
end
function PlayStationActivities:Abandon()
  AsyncPlayStationActivityEnd(self.id, const.PlayStationActivityOutcomeAbandoned)
  AccountStorage.PlayStationStartedActivities[self.id] = nil
  SaveAccountStorage(5000)
end
function PlayStationActivities:GetWarning()
  local warnings = {}
  if not rawget(self, "Launch") then
    warnings[#warnings + 1] = "Missing launch procedure!"
  end
  return #warnings ~= 0 and table.concat(warnings, "\n")
end
if Platform.ps5 then
  if FirstLoad then
    g_DelayedLaunchActivity = false
    g_PauseLaunchActivityReasons = {EngineStarted = true, AccountStorage = true}
  end
  function PlayStationLaunchActivity(activity_id)
    if g_PauseLaunchActivityReasons ~= empty_table then
      g_DelayedLaunchActivity = activity_id
      return
    end
    local activity = ActivitiesPresets[activity_id]
    if activity then
      activity:Launch()
      return
    end
  end
  function PauseLaunchActivity(reason)
    g_PauseLaunchActivityReasons[reason] = true
  end
  function ResumeLaunchActivity(reason)
    g_PauseLaunchActivityReasons[reason] = nil
    if g_DelayedLaunchActivity and g_PauseLaunchActivityReasons == empty_table then
      PlayStationLaunchActivity(g_DelayedLaunchActivity)
      g_DelayedLaunchActivity = false
    end
  end
  function OnMsg.DoneMap()
    for activity_id, _ in pairs(AccountStorage.PlayStationStartedActivities) do
      if g_DelayedLaunchActivity ~= activity_id then
        local activity = ActivitiesPresets[activity_id]
        if activity.abandon_on_done_map then
          activity:Abandon()
        end
      end
    end
  end
  function OnMsg.EngineStarted()
    ResumeLaunchActivity("EngineStarted")
    CreateRealTimeThread(function()
      while not AccountStorage do
        WaitMsg("AccountStorageChanged")
      end
      AccountStorage.PlayStationStartedActivities = AccountStorage.PlayStationStartedActivities or {}
      for activity_id, activity in pairs(ActivitiesPresets) do
        if activity.abandon_on_done_map or g_DelayedLaunchActivity ~= activity_id then
          if not activity.abandon_on_done_map and activity:IsActive() then
            activity:Start()
          else
            activity:Abandon()
          end
        end
      end
      ResumeLaunchActivity("AccountStorage")
    end)
  end
end
DefineClass.RichPresence = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "name",
      name = "Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "desc",
      name = "Description",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "xbox_id",
      name = "Xbox ID",
      editor = "text",
      default = false
    }
  },
  GlobalMap = "RichPresencePresets",
  EditorMenubarName = "Rich Presence",
  EditorMenubar = "Editors.Lists"
}
DefineClass.TrophyGroup = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "BuildPS4",
      id = "ps4_gid",
      name = "Group ID",
      help = "Those must be consecutive and unique.",
      editor = "number",
      default = -1,
      buttons = {
        {
          name = "Generate",
          func = "GenerateGroupIDs"
        }
      },
      min = -1,
      max = 128
    },
    {
      category = "BuildPS4",
      id = "ps4_name",
      name = "Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      category = "BuildPS4",
      id = "ps4_description",
      name = "Trophy Group Description",
      editor = "text",
      default = false,
      translate = true
    },
    {
      category = "BuildPS4",
      id = "ps4_icon",
      name = "Icon",
      editor = "ui_image",
      default = "",
      dont_save = true,
      read_only = true,
      no_validate = true,
      filter = "All files|*.png"
    },
    {
      category = "BuildPS4",
      id = "ps4_trophies",
      name = "Trophies",
      editor = "preset_id_list",
      default = {},
      dont_save = true,
      read_only = true,
      no_validate = true,
      preset_class = "Achievement",
      item_default = ""
    },
    {
      category = "BuildPS5",
      id = "ps5_gid",
      name = "Group ID",
      help = "Those must be consecutive and unique.",
      editor = "number",
      default = -1,
      buttons = {
        {
          name = "Generate",
          func = "GenerateGroupIDs"
        }
      },
      min = -1,
      max = 128
    },
    {
      category = "BuildPS5",
      id = "ps5_name",
      name = "Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      category = "BuildPS5",
      id = "ps5_description",
      name = "Description",
      editor = "text",
      default = false,
      translate = true
    },
    {
      category = "BuildPS5",
      id = "ps5_icon",
      name = "Icon",
      editor = "ui_image",
      default = "",
      dont_save = true,
      read_only = true,
      no_validate = true,
      filter = "All files|*.png"
    },
    {
      category = "BuildPS5",
      id = "ps5_trophies",
      name = "Trophies",
      editor = "preset_id_list",
      default = {},
      dont_save = true,
      read_only = true,
      no_validate = true,
      preset_class = "Achievement",
      item_default = ""
    }
  },
  GlobalMap = "TrophyGroupPresets",
  EditorMenubarName = "Trophy Groups",
  EditorIcon = "CommonAssets/UI/Icons/top trophy winner.png",
  EditorMenubar = "Editors.Lists"
}
function TrophyGroup:Getps4_icon()
  local _, icon_path = GetPlayStationTrophyGroupIcon(self.id, "ps4")
  return icon_path
end
function TrophyGroup:Getps4_trophies()
  return self:GetTrophies("ps4")
end
function TrophyGroup:Getps5_icon()
  local _, icon_path = GetPlayStationTrophyGroupIcon(self.id, "ps5")
  return icon_path
end
function TrophyGroup:Getps5_trophies()
  return self:GetTrophies("ps5")
end
function TrophyGroup:GenerateGroupIDs(root, prop_id)
  local platform = string.match(prop_id, "(.*)_gid")
  local group_id_field = prop_id
  local groups_counter = 0
  ForEachPreset(TrophyGroup, function(group)
    local is_group_used = CalcTrophyGroupPoints(group.id, platform) ~= 0
    local group_id = -1
    if is_group_used then
      group_id = groups_counter
      groups_counter = groups_counter + 1
    end
    if group[group_id_field] ~= group_id then
      group[group_id_field] = group_id
      group:MarkDirty()
    end
  end)
end
function TrophyGroup:GetTrophies(platform)
  local trophies = PresetArray(Achievement, function(achievement)
    return achievement:GetTrophyGroup(platform) == self.id
  end)
  return table.imap(trophies, function(trophy)
    return trophy.id
  end)
end
function TrophyGroup:IsBaseGameGroup(platform)
  if self[platform .. "_gid"] < 0 then
    return false
  end
  local dlc = FindPreset("DLCConfig", self.save_in)
  return not dlc or dlc[platform .. "_handling"] == "Embed"
end
function TrophyGroup:GetError(platform)
  local errors = {}
  local ShouldTestPlatform = function(test_platform)
    return not platform or platform == test_platform
  end
  local groups = PresetArray(TrophyGroup)
  local GetPlayStationErrors = function(platform)
    local group_id_field = platform .. "_gid"
    local self_group_id = self[group_id_field]
    if CalcTrophyGroupPoints(self.id, platform) > 0 and self_group_id < 0 then
      errors[#errors + 1] = string.format("Missing %s trophy group id!", platform)
    elseif 0 <= self_group_id then
      table.sortby_field(groups, group_id_field)
      local next_group_id = 0
      local group_id_holes = {}
      for _, group in ipairs(groups) do
        local curr_group_id = group[group_id_field]
        if self_group_id > next_group_id and 0 <= curr_group_id then
          if next_group_id < curr_group_id then
            if 1 < curr_group_id - next_group_id then
              group_id_holes[#group_id_holes + 1] = string.format("%d-%d", next_group_id, curr_group_id)
            else
              group_id_holes[#group_id_holes + 1] = next_group_id
            end
          end
          next_group_id = curr_group_id + 1
        end
        if self ~= group and self_group_id == curr_group_id then
          errors[#errors + 1] = string.format("Duplicated %s trophy group id (%s)!", platform, group.id)
        end
      end
      if #group_id_holes ~= 0 then
        errors[#errors + 1] = string.format("%s group ids are not consecutive, missing %s!", string.upper(platform), table.concat(group_id_holes, ", "))
      end
    end
  end
  if ShouldTestPlatform("ps4") then
    GetPlayStationErrors("ps4")
  end
  if ShouldTestPlatform("ps5") then
    GetPlayStationErrors("ps5")
  end
  return #errors ~= 0 and table.concat(errors, "\n")
end
function TrophyGroup:GetWarning(platform)
  local warnings = {}
  local ShouldTestPlatform = function(test_platform)
    return not platform or platform == test_platform
  end
  local GetPlayStationWarnings = function(platform)
    local trophies = self:GetTrophies(platform)
    if self[platform .. "_gid"] >= 0 then
      if #trophies == 0 then
        warnings[#warnings + 1] = string.format("Has %s group id but no trophies assigned!", platform)
      end
      local is_placeholder, icon_path = GetPlayStationTrophyGroupIcon(self.id, platform)
      if is_placeholder then
        warnings[#warnings + 1] = string.format("Missing %s trophy group icon (placeholder used): %s", platform, icon_path)
      end
    end
    local is_base_game_group = self:IsBaseGameGroup(platform)
    for _, trophy_name in ipairs(trophies) do
      local trophy = FindPreset("Achievement", trophy_name)
      local is_base_game_trophy = trophy:IsBaseGameTrophy(platform)
      if trophy.save_in ~= self.save_in and (not is_base_game_group or not is_base_game_trophy) then
        warnings[#warnings + 1] = string.format("%s trophy %s saved in %s while the group is saved in %s.", string.upper(platform), trophy_name, trophy.save_in, self.save_in)
      end
    end
  end
  if ShouldTestPlatform("ps4") then
    GetPlayStationWarnings("ps4")
  end
  if ShouldTestPlatform("ps5") then
    GetPlayStationWarnings("ps5")
  end
  return #warnings ~= 0 and table.concat(warnings, "\n")
end
DefineClass.VideoDef = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "source",
      editor = "browse",
      default = false,
      folder = "svnAssets/Source/Movies",
      filter = "Video Files|*.avi|All Files|*.*"
    },
    {
      id = "ffmpeg_input_pattern",
      editor = "text",
      default = "-i \"$(source)\""
    },
    {
      id = "sound",
      editor = "browse",
      default = false,
      folder = "svnAssets/Source/Movies",
      filter = "Audio Files|*.wav"
    },
    {
      id = "present_desktop",
      editor = "bool",
      default = true
    },
    {
      id = "extension_desktop",
      editor = "text",
      default = "ivf",
      no_edit = function(self)
        return not self.present_desktop
      end
    },
    {
      id = "ffmpeg_commandline_desktop",
      editor = "text",
      default = "-c:v vp8 -preset veryslow",
      no_edit = function(self)
        return not self.present_desktop
      end
    },
    {
      id = "bitrate_desktop",
      editor = "number",
      default = 8000,
      no_edit = function(self)
        return not self.present_desktop
      end
    },
    {
      id = "framerate_desktop",
      editor = "number",
      default = 30,
      no_edit = function(self)
        return not self.present_desktop
      end
    },
    {
      id = "resolution_desktop",
      editor = "point",
      default = point(1920, 1080),
      no_edit = function(self)
        return not self.present_desktop
      end
    },
    {
      id = "present_ps4",
      editor = "bool",
      default = true
    },
    {
      id = "extension_ps4",
      editor = "text",
      default = "bsf",
      no_edit = function(self)
        return not self.present_ps4
      end
    },
    {
      id = "ffmpeg_commandline_ps4",
      editor = "text",
      default = "-c:v h264 -profile:v high422 -pix_fmt yuv420p -x264opts force-cfr -bsf h264_mp4toannexb -f h264 -r 30000/1001",
      no_edit = function(self)
        return not self.present_ps4
      end
    },
    {
      id = "bitrate_ps4",
      editor = "number",
      default = 6000,
      no_edit = function(self)
        return not self.present_ps4
      end
    },
    {
      id = "framerate_ps4",
      editor = "number",
      default = 30,
      no_edit = function(self)
        return not self.present_ps4
      end
    },
    {
      id = "resolution_ps4",
      editor = "point",
      default = point(1920, 1080),
      no_edit = function(self)
        return not self.present_ps4
      end
    },
    {
      id = "present_ps5",
      editor = "bool",
      default = true
    },
    {
      id = "extension_ps5",
      editor = "text",
      default = "bsf",
      no_edit = function(self)
        return not self.present_ps5
      end
    },
    {
      id = "ffmpeg_commandline_ps5",
      editor = "text",
      default = "-c:v h264 -profile:v high422 -pix_fmt yuv420p -x264opts force-cfr -bsf h264_mp4toannexb -f h264 -r 30000/1001",
      no_edit = function(self)
        return not self.present_ps5
      end
    },
    {
      id = "bitrate_ps5",
      editor = "number",
      default = 6000,
      no_edit = function(self)
        return not self.present_ps5
      end
    },
    {
      id = "framerate_ps5",
      editor = "number",
      default = 30,
      no_edit = function(self)
        return not self.present_ps5
      end
    },
    {
      id = "resolution_ps5",
      editor = "point",
      default = point(1920, 1080),
      no_edit = function(self)
        return not self.present_ps5
      end
    },
    {
      id = "present_xbox_one",
      editor = "bool",
      default = true
    },
    {
      id = "extension_xbox_one",
      editor = "text",
      default = "mp4",
      no_edit = function(self)
        return not self.present_xbox_one
      end
    },
    {
      id = "ffmpeg_commandline_xbox_one",
      editor = "text",
      default = "-c:v h264 -preset veryslow -pix_fmt yuv420p",
      no_edit = function(self)
        return not self.present_xbox_one
      end
    },
    {
      id = "bitrate_xbox_one",
      editor = "number",
      default = 6000,
      no_edit = function(self)
        return not self.present_xbox_one
      end
    },
    {
      id = "framerate_xbox_one",
      editor = "number",
      default = 30,
      no_edit = function(self)
        return not self.present_xbox_one
      end
    },
    {
      id = "resolution_xbox_one",
      editor = "point",
      default = point(1920, 1080),
      no_edit = function(self)
        return not self.present_xbox_one
      end
    },
    {
      id = "present_xbox_series",
      editor = "bool",
      default = true
    },
    {
      id = "extension_xbox_series",
      editor = "text",
      default = "mp4",
      no_edit = function(self)
        return not self.present_xbox_series
      end
    },
    {
      id = "ffmpeg_commandline_xbox_series",
      editor = "text",
      default = "-c:v h264 -preset veryslow -pix_fmt yuv420p",
      no_edit = function(self)
        return not self.present_xbox_series
      end
    },
    {
      id = "bitrate_xbox_series",
      editor = "number",
      default = 6000,
      no_edit = function(self)
        return not self.present_xbox_series
      end
    },
    {
      id = "framerate_xbox_series",
      editor = "number",
      default = 30,
      no_edit = function(self)
        return not self.present_xbox_series
      end
    },
    {
      id = "resolution_xbox_series",
      editor = "point",
      default = point(1920, 1080),
      no_edit = function(self)
        return not self.present_xbox_series
      end
    },
    {
      id = "present_switch",
      editor = "bool",
      default = true
    },
    {
      id = "extension_switch",
      editor = "text",
      default = "mp4",
      no_edit = function(self)
        return not self.present_switch
      end
    },
    {
      id = "ffmpeg_commandline_switch",
      editor = "text",
      default = "-c:v h264 -preset veryslow -pix_fmt yuv420p",
      no_edit = function(self)
        return not self.present_switch
      end
    },
    {
      id = "bitrate_switch",
      editor = "number",
      default = 700,
      no_edit = function(self)
        return not self.present_switch
      end
    },
    {
      id = "framerate_switch",
      editor = "number",
      default = 30,
      no_edit = function(self)
        return not self.present_switch
      end
    },
    {
      id = "resolution_switch",
      editor = "point",
      default = point(1280, 720),
      no_edit = function(self)
        return not self.present_switch
      end
    }
  },
  HasCompanionFile = true,
  GlobalMap = "VideoDefs",
  EditorMenubarName = "Video defs",
  EditorIcon = "CommonAssets/UI/Icons/outline video.png",
  EditorMenubar = "Editors.Engine"
}
function VideoDef:GetPropsForPlatform(platform)
  local result = {}
  local props = {
    "extension",
    "ffmpeg_commandline",
    "bitrate",
    "framerate",
    "resolution",
    "present"
  }
  for key, value in ipairs(props) do
    result[value] = self[value .. "_" .. platform]
  end
  local video_path = string.match(self.source or "", "svnAssets/Source/(.+)")
  if video_path then
    local dir, name, ext = SplitPath(video_path)
    result.video_game_path = dir .. name .. "." .. result.extension
  end
  local sound_path = string.match(self.sound or "", "svnAssets/Source/(.+)")
  if sound_path then
    local dir, name, ext = SplitPath(sound_path)
    result.sound_game_path = dir .. name
  end
  return result
end
DefineClass.VoiceActorDef = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "VoiceId",
      name = "VoiceID",
      editor = "text",
      default = false
    }
  },
  GlobalMap = "VoiceActors",
  EditorMenubarName = "Voice Actors",
  EditorIcon = "CommonAssets/UI/Icons/human male man people person.png",
  EditorMenubar = "Editors.Audio",
  EditorView = Untranslated("<u(Id)> <color 0 128 0><u(VoiceId)>")
}
