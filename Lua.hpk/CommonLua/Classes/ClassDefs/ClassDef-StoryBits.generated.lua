DefineClass.StoryBit = {
  __parents = {
    "PresetWithQA"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "General",
      id = "ScriptDone",
      name = "Script done",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return IsKindOf(self, "ModItem")
      end
    },
    {
      category = "General",
      id = "TextReadyForValidation",
      name = "Text ready for validation",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return IsKindOf(self, "ModItem")
      end
    },
    {
      category = "General",
      id = "TextsDone",
      name = "Texts done",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return IsKindOf(self, "ModItem")
      end
    },
    {
      category = "Activation",
      id = "Category",
      editor = "preset_id",
      default = "FollowUp",
      preset_class = "StoryBitCategory",
      extra_item = "FollowUp"
    },
    {
      category = "Activation",
      id = "Trigger",
      editor = "choice",
      default = "StoryBitTick",
      read_only = function(self)
        return self.Category ~= "FollowUp"
      end,
      items = function(self)
        return StoryBitTriggersCombo
      end
    },
    {
      category = "Activation",
      id = "Enabled",
      editor = "bool",
      default = false,
      read_only = function(self)
        return self.Category == "FollowUp"
      end
    },
    {
      category = "Activation",
      id = "EnableChance",
      name = "Enable Chance",
      help = "Chance to be enabled in a specific playthrough (use sparingly for story bits that occur too often)",
      editor = "number",
      default = 100,
      no_edit = function(self)
        return not self.Enabled
      end,
      scale = "%"
    },
    {
      category = "Activation",
      id = "InheritsObject",
      name = "Inherits object",
      help = "Associate with the object of the story bit that enabled this one",
      editor = "bool",
      default = true,
      no_edit = function(self)
        return self.Enabled
      end
    },
    {
      category = "Activation",
      id = "OneTime",
      name = "One-time",
      editor = "bool",
      default = true,
      read_only = function(self)
        return self.Category == "FollowUp"
      end
    },
    {
      category = "Activation",
      id = "ExpirationTime",
      name = "Expiration time",
      editor = "number",
      default = false,
      scale = "h"
    },
    {
      category = "Activation",
      id = "ExpirationModifier",
      name = "Expiration modifier",
      editor = "expression",
      default = function(self, context, obj)
        return 100
      end,
      params = "self, context, obj"
    },
    {
      category = "Activation",
      id = "SuppressTime",
      name = "Suppress for",
      help = "This StoryBit can't trigger for this period after it was enabled",
      editor = "number",
      default = 0,
      scale = "h"
    },
    {
      category = "Activation",
      id = "Sets",
      name = "Sets",
      help = "Sets this story bit belongs to. These sets can be disabled by game-specific logic.",
      editor = "set",
      default = false,
      items = function(self)
        return PresetsCombo("CooldownDef", "StoryBits")
      end
    },
    {
      category = "Activation",
      id = "Prerequisites",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      category = "Activation Effects",
      id = "Disables",
      help = "List of StoryBits to disable",
      editor = "preset_id_list",
      default = {},
      preset_class = "StoryBit",
      item_default = ""
    },
    {
      category = "Activation Effects",
      id = "Delay",
      help = "This StoryBit waits this long after triggering before it gets activated and displayed",
      editor = "number",
      default = 0,
      scale = "h"
    },
    {
      category = "Activation Effects",
      id = "DetachObj",
      name = "Detach object",
      help = "Detach the story bit related object on delay.",
      editor = "bool",
      default = false
    },
    {
      category = "Activation Effects",
      id = "ActivationEffects",
      name = "Activation Effects",
      editor = "nested_list",
      default = false,
      base_class = "Effect",
      all_descendants = true
    },
    {
      category = "Notification",
      id = "HasNotification",
      name = "Has notification",
      editor = "bool",
      default = true
    },
    {
      category = "Notification",
      id = "NotificationPriority",
      name = "Notification priority",
      editor = "choice",
      default = "StoryBit",
      no_edit = function(self)
        return not self.HasNotification
      end,
      items = function(self)
        return GetGameNotificationPriorities()
      end
    },
    {
      category = "Notification",
      id = "NotificationTitle",
      name = "Notification Title",
      help = "Leave empty to use the popup title",
      editor = "text",
      default = "",
      no_edit = function(self)
        return not self.HasNotification
      end,
      translate = true,
      lines = 1
    },
    {
      category = "Notification",
      id = "NotificationText",
      name = "Notification Text",
      help = "Leave empty to use the popup title",
      editor = "text",
      default = "",
      no_edit = function(self)
        return not self.HasNotification
      end,
      translate = true,
      lines = 1
    },
    {
      category = "Notification",
      id = "NotificationRolloverTitle",
      name = "Notification rollover title",
      editor = "text",
      default = "",
      no_edit = function(self)
        return not self.HasNotification
      end,
      translate = true,
      lines = 1
    },
    {
      category = "Notification",
      id = "NotificationRolloverText",
      name = "Notification rollover text",
      editor = "text",
      default = "",
      no_edit = function(self)
        return not self.HasNotification
      end,
      translate = true,
      lines = 1,
      max_lines = 6
    },
    {
      category = "Notification",
      id = "NotificationAction",
      name = "Notification action",
      editor = "choice",
      default = "complete",
      no_edit = function(self)
        return not self.HasNotification
      end,
      items = function(self)
        return {
          "complete",
          "select object",
          "callback",
          "nothing"
        }
      end
    },
    {
      category = "Notification",
      id = "NotificationCallbackFunc",
      name = "Notification click callback",
      editor = "func",
      default = function(self, state)
        return true
      end,
      no_edit = function(self)
        return self.NotificationAction ~= "callback"
      end,
      params = "self, state"
    },
    {
      category = "Notification",
      id = "NotificationExpirationBar",
      name = "Display expiration bar",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return not self.HasNotification
      end
    },
    {
      category = "Notification",
      id = "NotificationCanDismiss",
      name = "Can dismiss",
      editor = "bool",
      default = true,
      no_edit = function(self)
        return not self.HasNotification or self.HasPopup
      end
    },
    {
      category = "Popup",
      id = "HasPopup",
      name = "Has popup",
      editor = "bool",
      default = true
    },
    {
      category = "Notification",
      id = "FxAction",
      name = "FX Action",
      help = "This is used for calling the FX system with given action. Leave it empty to have default notification FX actions.",
      editor = "text",
      default = ""
    },
    {
      category = "Popup",
      id = "Actor",
      editor = "combo",
      default = "narrator",
      no_edit = function(self)
        return not self.HasPopup
      end,
      items = function(self)
        return VoiceActors
      end
    },
    {
      category = "Popup",
      id = "Title",
      editor = "text",
      default = false,
      no_edit = function(self)
        return not self.HasPopup
      end,
      translate = true,
      lines = 1
    },
    {
      category = "Popup",
      id = "VoicedText",
      name = "Voiced Text",
      editor = "text",
      default = false,
      no_edit = function(self)
        return not self.HasPopup
      end,
      translate = true,
      lines = 1,
      max_lines = 256,
      context = VoicedContextFromField("Actor")
    },
    {
      category = "Popup",
      id = "Text",
      editor = "text",
      default = false,
      no_edit = function(self)
        return not self.HasPopup
      end,
      translate = true,
      lines = 4,
      max_lines = 256
    },
    {
      category = "Popup",
      id = "Image",
      editor = "ui_image",
      default = "",
      no_edit = function(self)
        return not self.HasPopup
      end,
      image_preview_size = 200
    },
    {
      category = "Popup",
      id = "UseObjectImage",
      name = "Use object image",
      help = "Extract a popup image from the context object",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return not self.HasPopup
      end
    },
    {
      category = "Popup",
      id = "SelectObject",
      name = "Select Object",
      help = "Select the object when opening the popup",
      editor = "bool",
      default = true,
      no_edit = function(self)
        return not self.HasPopup
      end
    },
    {
      category = "Popup",
      id = "PopupFxAction",
      name = "FX Action",
      help = "This is used for calling the FX system with given action when opening Popup.",
      editor = "text",
      default = ""
    },
    {
      category = "Completion Effects",
      id = "Enables",
      help = "List of StoryBits to enable",
      editor = "preset_id_list",
      default = {},
      preset_class = "StoryBit",
      item_default = ""
    },
    {
      category = "Completion Effects",
      id = "Effects",
      name = "Completion Effects",
      editor = "nested_list",
      default = false,
      base_class = "Effect",
      all_descendants = true
    },
    {
      id = "max_reply_id",
      name = "Max Reply Id",
      editor = "number",
      default = 0,
      read_only = true,
      no_edit = true
    }
  },
  HasParameters = true,
  SingleFile = false,
  GlobalMap = "StoryBits",
  ContainerClass = "StoryBitSubItem",
  EditorMenubarName = "Story Bits",
  EditorShortcut = "Ctrl-Alt-E",
  EditorIcon = "CommonAssets/UI/Icons/book 2.png",
  EditorMenubar = "Scripting",
  EditorCustomActions = {
    {Name = "Debug"},
    {
      FuncName = "GedRpcTestStoryBit",
      Icon = "CommonAssets/UI/Ged/play.tga",
      Menubar = "Debug",
      Name = "TestStoryBit",
      Toolbar = "main"
    },
    {
      FuncName = "GedRpcTestPrerequisitesStoryBit",
      Icon = "CommonAssets/UI/Ged/preview.tga",
      Menubar = "Debug",
      Name = "Test prerequisites",
      Toolbar = "main"
    }
  },
  EditorView = Untranslated("<ChooseColor><id><color 0 128 0><if(not_eq(Trigger,'StoryBitTick'))> (<Trigger>)</if><opt(u(Comment),' ','')><color 128 128 128><opt(u(save_in),' - ','')>")
}
DefineModItemPreset("StoryBit", {EditorName = "Story bit", EditorSubmenu = "Gameplay"})
function StoryBit:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "Category" then
    if self.Category == "FollowUp" or self.Category == "" then
      self.Enabled = false
      self.OneTime = true
    else
      self.Trigger = StoryBitCategories[self.Category].Trigger
      self.Enabled = true
    end
  end
  if prop_id == "Enables" or prop_id == "Effects" or prop_id == "ActivationEffects" then
    StoryBitResetEnabledReferences()
  end
end
function StoryBit:ChooseColor()
  if not self.ScriptDone then
    return ""
  end
  local color = not self.TextsDone and (self.TextReadyForValidation and RGB(180, 0, 180) or RGB(205, 32, 32)) or not self.TextReadyForValidation and RGB(220, 120, 0) or (not self.Image or self.Image == "") and self.Category ~= "FollowUp" and RGB(50, 50, 200) or RGB(32, 128, 32)
  local r, g, b = GetRGB(color)
  return string.format("<color %s %s %s>", r, g, b)
end
if config.Mods then
  function ModItemStoryBit:TestModItem(ged)
    if not GameState.gameplay then
      return
    end
    CreateGameTimeThread(function()
      ForceActivateStoryBit(self.id, SelectedObj, "immediate")
    end)
  end
end
if Platform.developer then
  local referenced_storybits = false
  function StoryBitResetEnabledReferences()
    referenced_storybits = false
    ObjModified(Presets.StoryBit)
  end
  local add_effect_references = function(effects)
    for _, effect in ipairs(effects or empty_table) do
      if effect:IsKindOf("StoryBitActivate") then
        referenced_storybits[effect.Id] = true
      end
      if effect:IsKindOf("StoryBitEnableRandom") then
        for _, id in ipairs(effect.StoryBits or empty_table) do
          referenced_storybits[id] = true
        end
      end
    end
  end
  function OnMsg.MarkReferencedStoryBits(referenced_storybits)
    ForEachPreset(StoryBit, function(storybit)
      for _, id in ipairs(storybit.Enables or empty_table) do
        referenced_storybits[id] = true
      end
      add_effect_references(storybit.Effects)
      add_effect_references(storybit.ActivationEffects)
      for _, child in ipairs(storybit) do
        if child:IsKindOf("StoryBitOutcome") then
          for _, id in ipairs(child.Enables) do
            referenced_storybits[id] = true
          end
          add_effect_references(child.Effects)
        end
      end
    end)
  end
  function StoryBit:GetError()
    if not referenced_storybits then
      referenced_storybits = {}
      Msg("MarkReferencedStoryBits", referenced_storybits)
    end
    return not self.Enabled and not referenced_storybits[self.id] and "This story bit is not enabled by itself, or from anywhere else."
  end
else
  function StoryBitResetEnabledReferences()
  end
end
DefineClass.StoryBitOutcome = {
  __parents = {
    "StoryBitSubItem"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Activation",
      id = "Prerequisites",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      category = "Activation",
      id = "Weight",
      editor = "number",
      default = 100
    },
    {
      category = "Popup",
      id = "Title",
      editor = "text",
      default = false,
      translate = true,
      lines = 1
    },
    {
      category = "Popup",
      id = "VoicedText",
      name = "Voiced Text",
      editor = "text",
      default = false,
      translate = true,
      lines = 1,
      max_lines = 256,
      context = VoicedContextFromField("Actor")
    },
    {
      category = "Popup",
      id = "Text",
      editor = "text",
      default = false,
      translate = true,
      lines = 4,
      max_lines = 256
    },
    {
      category = "Popup",
      id = "Actor",
      editor = "combo",
      default = "narrator",
      items = function(self)
        return VoiceActors
      end
    },
    {
      category = "Popup",
      id = "Image",
      editor = "ui_image",
      default = ""
    },
    {
      id = "Enables",
      help = "List of StoryBits to enable",
      editor = "preset_id_list",
      default = {},
      preset_class = "StoryBit",
      item_default = ""
    },
    {
      id = "Disables",
      help = "List of StoryBits to disable",
      editor = "preset_id_list",
      default = {},
      preset_class = "StoryBit",
      item_default = ""
    },
    {
      category = "Effect",
      id = "StoryBits",
      help = "A list of storybits with weight. One will be chosen and activated based on weight and met prerequisites.",
      editor = "nested_list",
      default = false,
      base_class = "StoryBitWithWeight",
      all_descendants = true
    },
    {
      category = "Effect",
      id = "Effects",
      help = "All effects in the list will be executed even if some storybits have been added to the StoryBits property.",
      editor = "nested_list",
      default = false,
      base_class = "Effect",
      all_descendants = true
    }
  },
  EditorName = "New Outcome"
}
function StoryBitOutcome:GetEditorView()
  local result = "<tab 20>Outcome (<Weight>): "
  if self.VoicedText then
    result = result .. "<color 128 128 128><literal(VoicedText)></color>"
  elseif self.Text then
    result = result .. "<color 128 128 128><literal(Text)></color>"
  else
    result = result .. "<color 128 128 128>no display text</color>"
  end
  for _, cond in ipairs(self.Prerequisites or empty_table) do
    result = result .. [[

<tab 20><color 140 64 32>]] .. _InternalTranslate(cond:GetProperty("EditorView"), cond, false) .. "</color>"
  end
  for _, effect in ipairs(self.Effects or empty_table) do
    result = result .. [[

<tab 20><color 140 64 32>]] .. _InternalTranslate(effect:GetProperty("EditorView"), effect, false) .. "</color>"
  end
  for _, effect in ipairs(self.StoryBits) do
    result = result .. [[

<tab 20><color 140 64 32>]] .. _InternalTranslate(effect:GetProperty("EditorView"), effect, false) .. "</color>"
  end
  if next(self.Enables or empty_table) then
    result = result .. [[

<tab 20>Enables: <color 140 64 32>]] .. table.concat(self.Enables, ", ") .. "</color>"
  end
  if next(self.Disables or empty_table) then
    result = result .. [[

<tab 20>Disables: <color 140 64 32>]] .. table.concat(self.Disables, ", ") .. "</color>"
  end
  return T({
    Untranslated(result)
  })
end
function StoryBitOutcome:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "Enables" or prop_id == "Effects" then
    StoryBitResetEnabledReferences()
  end
end
DefineClass.StoryBitReply = {
  __parents = {
    "StoryBitSubItem"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Text",
      editor = "text",
      default = false,
      translate = true,
      lines = 1
    },
    {
      id = "PrerequisiteText",
      name = "Prerequisite text",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Prerequisites",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      id = "Cost",
      editor = "number",
      default = 0
    },
    {
      id = "HideIfDisabled",
      name = "Hide if disabled",
      editor = "bool",
      default = false
    },
    {
      id = "OutcomeText",
      name = "Outcome Text",
      editor = "choice",
      default = "none",
      items = function(self)
        return {
          {text = "None", value = "none"},
          {
            text = "Auto (from 1st outcome effects)",
            value = "auto"
          },
          {text = "Custom", value = "custom"}
        }
      end
    },
    {
      id = "CustomOutcomeText",
      name = "Custom outcome text",
      editor = "text",
      default = false,
      no_edit = function(self)
        return self.OutcomeText ~= "custom"
      end,
      translate = true,
      lines = 1
    },
    {
      category = "Comment",
      id = "Comment",
      editor = "text",
      default = false
    },
    {
      id = "unique_id",
      name = "Unique Id",
      editor = "number",
      default = 0,
      read_only = true,
      no_edit = true
    }
  },
  EditorName = "New Reply"
}
function StoryBitReply:GetEditorView()
  local conditions = {}
  for _, cond in ipairs(self.Prerequisites) do
    table.insert(conditions, _InternalTranslate(cond:GetProperty("EditorView"), cond, false))
  end
  local cost = self.Cost
  if cost ~= 0 then
    table.insert(conditions, "Cost " .. _InternalTranslate(T(504461186435, "<cost>"), cost, false))
  end
  local cond_text = 0 < #conditions and "[" .. table.concat(conditions, ", ") .. "] " or ""
  local result = "Reply: <color 0 128 0>" .. cond_text .. "<literal(Text)></color>"
  if self.OutcomeText == "custom" then
    result = result .. [[

<color 128 128 128>(<literal(CustomOutcomeText)>)]]
  elseif self.OutcomeText == "auto" then
    result = result .. [[

<color 128 128 128> - auto display of outcome text -]]
  end
  if self.Comment and self.Comment ~= "" then
    result = result .. [[

<color 75 105 198>]] .. self.Comment .. "</color>"
  end
  if const.TagLookupTable.em then
    result = result:gsub(const.TagLookupTable.em, "")
    result = result:gsub(const.TagLookupTable["/em"], "")
  end
  return T({
    Untranslated(result)
  })
end
function StoryBitReply:OnEditorNew(parent, ged, is_paste)
  parent.max_reply_id = parent.max_reply_id + 1
  self.unique_id = parent.max_reply_id
end
DefineClass.StoryBitSubItem = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  StoreAsTable = true
}
