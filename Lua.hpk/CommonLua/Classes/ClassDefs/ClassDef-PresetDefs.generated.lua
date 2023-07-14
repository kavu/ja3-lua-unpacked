DefineClass.ActorFXClassDef = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Preset",
      id = "help",
      help = T(757555070861, [[
Use the Group property to define the ActorFXClass parent - all FX from the parent are inherited.

Entries in the Default group are considered top level and have no parents.]]),
      editor = "help",
      default = false
    }
  },
  PropertyTranslation = true,
  GlobalMap = "ActorFXClassDefs",
  EditorMenubarName = "FX Classes",
  EditorMenubar = "Editors.Art",
  StoreAsTable = true
}
function OnMsg.GatherFXActors(list)
  ForEachPreset("ActorFXClassDef", function(preset, group, list)
    list[#list + 1] = preset.id
  end, list)
end
function OnMsg.GetCustomFXInheritActorRules(custom_inherit)
  ForEachPreset("ActorFXClassDef", function(preset, group, custom_inherit)
    if preset.group ~= "Default" then
      custom_inherit[#custom_inherit + 1] = preset.id
      custom_inherit[#custom_inherit + 1] = preset.group
    end
  end, custom_inherit)
end
DefineClass.AnimComponent = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "label",
      name = "Label",
      help = "Label that identifies the kind of IK",
      editor = "text",
      default = false
    }
  },
  GlobalMap = "AnimComponents",
  EditorMenubar = "Editors.Art"
}
DefineClass.AnimIKLimbAdjust = {
  __parents = {
    "AnimComponent"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Limbs",
      editor = "nested_list",
      default = false,
      base_class = "AnimLimbData",
      inclusive = true,
      auto_expand = true
    },
    {
      id = "adjust_root_to_reach_targets",
      help = "Adjust root position along an axis in case limb targets are too far from the current position",
      editor = "bool",
      default = false
    },
    {
      id = "adjust_root_axis",
      help = "Axis to adjust root position to reach far out limb targets",
      editor = "point",
      default = point(0, 0, 1000)
    },
    {
      id = "max_target_speed",
      help = "Maximum units per second the adjusted limb fit positions are allowed to move, 0 means no limit",
      editor = "number",
      default = 5000,
      min = 0
    }
  },
  PresetClass = "AnimComponent"
}
DefineClass.AnimIKLookAt = {
  __parents = {
    "AnimComponent"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "pivot_bone",
      editor = "text",
      default = false
    },
    {
      id = "pivot_parents",
      help = "Number of bones to distribute the rotation between",
      editor = "number",
      default = 1,
      min = 1
    },
    {
      id = "aim_bone",
      editor = "text",
      default = false
    },
    {
      id = "aim_forward",
      help = "Forward direction in local bone space",
      editor = "point",
      default = point(-1000, 0, 0)
    },
    {
      id = "aim_up",
      help = "Up direction in local bone space",
      editor = "point",
      default = point(0, -1000, 0)
    },
    {
      id = "max_vertical_angle",
      editor = "number",
      default = 2700,
      scale = "deg",
      min = 0,
      max = 10800
    },
    {
      id = "max_horizontal_angle",
      editor = "number",
      default = 5400,
      scale = "deg",
      min = 0,
      max = 10800
    },
    {
      id = "out_of_bound_vertical_snap",
      help = "Snap vertical angle to 0 if target is outside horizontal limits",
      editor = "bool",
      default = false
    },
    {
      id = "max_angular_speed",
      help = "Maximum local angle per second",
      editor = "number",
      default = 5400,
      scale = "deg",
      min = 0,
      max = 43200
    }
  },
  PresetClass = "AnimComponent"
}
DefineClass.AnimMetadata = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "FX",
      id = "Action",
      name = "Test action",
      editor = "combo",
      default = false,
      dont_save = true,
      items = function(self)
        return table.ifilter(PresetsPropCombo("FXPreset", "Action")(), function(idx, item)
          return FXActionToAnim(item) == item
        end)
      end,
      show_recent_items = 7
    },
    {
      category = "FX",
      id = "Actor",
      name = "Test actor",
      editor = "combo",
      default = false,
      dont_save = true,
      items = function(self)
        return ActionFXClassCombo()
      end,
      show_recent_items = 7
    },
    {
      category = "FX",
      id = "Target",
      name = "Test target",
      editor = "combo",
      default = false,
      dont_save = true,
      items = function(self)
        return TargetFXClassCombo
      end,
      show_recent_items = 7
    },
    {
      category = "FX",
      id = "FXInherits",
      editor = "string_list",
      default = {},
      item_default = "idle",
      items = function(self)
        return IsValidEntity(self.group) and GetStates(self.group) or {"idle"}
      end
    },
    {
      category = "Moments",
      id = "ReconfirmAll",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Reconfirm",
          func = "ReconfirmMoments"
        }
      }
    },
    {
      category = "Moments",
      id = "Moments",
      editor = "nested_list",
      default = false,
      base_class = "AnimMoment",
      inclusive = true
    },
    {
      category = "Animation",
      id = "SpeedModifier",
      editor = "number",
      default = 100,
      min = 10,
      max = 1000
    },
    {
      category = "Animation",
      id = "StepModifier",
      editor = "number",
      default = 100,
      min = 10,
      max = 1000
    },
    {
      category = "Anim Components",
      id = "VariationWeight",
      editor = "number",
      default = 100,
      slider = true,
      min = 0,
      max = 10000
    },
    {
      category = "Anim Components",
      id = "RandomizePhase",
      editor = "number",
      default = -1,
      min = -1
    },
    {
      category = "Anim Components",
      id = "AnimComponents",
      editor = "nested_list",
      default = false,
      base_class = "AnimComponentWeight",
      inclusive = true,
      auto_expand = true
    }
  },
  GedEditor = ""
}
function AnimMetadata:GetAction()
  if not self.Action then
    local obj = GetAnimationMomentsEditorObject()
    if obj then
      local anim = AnimationMomentsEditorMode == "selection" and obj:Getanim() or GetStateName(obj:GetState())
      return FXAnimToAction(anim)
    end
  end
  return self.Action
end
function AnimMetadata:GetActor()
  if not self.Actor then
    local obj = GetAnimationMomentsEditorObject()
    if obj then
      obj = rawget(obj, "obj") or obj
      local obj_class = obj.class
      if obj:IsKindOfClasses("Unit", "BaseObjectAME") or obj_class == "DummyUnit" then
        obj_class = "Unit"
      end
      return g_Classes[obj_class].fx_actor_class or obj_class
    end
  end
  return self.Actor
end
function AnimMetadata:PostLoad()
  local ent_speed_mod = const.AnimSpeedScale * self.SpeedModifier / 100
  local entity = self.group
  local state = GetStateIdx(self.id)
  SetStateSpeedModifier(entity, state, ent_speed_mod)
  SetStateStepModifier(entity, state, self.StepModifier)
end
function AnimMetadata:OnPreSave()
  for _, moment in ipairs(self.Moments) do
    if moment.AnimRevision == 999999999 then
      moment.AnimRevision = EntitySpec:GetAnimRevision(self.group, self.id)
    end
  end
end
function AnimMetadata:ReconfirmMoments(root, prop_id, ged)
  local revision = GetAnimationMomentsEditorObject().AnimRevision
  for _, moment in ipairs(self.Moments or empty_table) do
    if moment.AnimRevision ~= revision then
      moment.AnimRevision = revision
      ObjModified(moment)
    end
  end
  ObjModified(self)
  ObjModified(ged:ResolveObj("Animations"))
end
function AnimMetadata:GetError()
  local entity = self.group
  if not IsValidEntity(entity) then
    return "No such entity " .. (entity or "")
  end
  local state = self.id
  if not HasState(entity, state) then
    return "No such anim " .. entity .. "." .. (state or "")
  end
end
table.insert(AnimMetadata.properties, {
  id = "Id",
  editor = "text",
  no_edit = true
})
table.insert(AnimMetadata.properties, {
  id = "Group",
  editor = "text",
  no_edit = true
})
DefineClass.Appearance = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Body",
      id = "Body",
      name = "Body",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCharacterBodyComboItems()
      end
    },
    {
      category = "Body",
      id = "BodyColor",
      name = "Body Color",
      editor = "nested_obj",
      default = false,
      base_class = "ColorizationPropSet"
    },
    {
      category = "Head",
      id = "Head",
      name = "Head",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCharacterHeadComboItems(self)
      end
    },
    {
      category = "Head",
      id = "HeadColor",
      name = "Head Color",
      editor = "nested_obj",
      default = false,
      base_class = "ColorizationPropSet"
    },
    {
      category = "Shirt",
      id = "Shirt",
      name = "Shirt",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCharacterShirtComboItems(self)
      end
    },
    {
      category = "Shirt",
      id = "ShirtColor",
      name = "Shirt Color",
      editor = "nested_obj",
      default = false,
      base_class = "ColorizationPropSet"
    },
    {
      category = "Pants",
      id = "Pants",
      name = "Pants",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCharacterPantsComboItems(self)
      end
    },
    {
      category = "Pants",
      id = "PantsColor",
      name = "Pants Color",
      editor = "nested_obj",
      default = false,
      base_class = "ColorizationPropSet"
    },
    {
      category = "Armor",
      id = "Armor",
      name = "Armor",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCharacterArmorComboItems(self)
      end
    },
    {
      category = "Armor",
      id = "ArmorColor",
      name = "Armor Color",
      editor = "nested_obj",
      default = false,
      base_class = "ColorizationPropSet"
    },
    {
      category = "Chest",
      id = "Chest",
      name = "Chest",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCharacterChestComboItems(self)
      end
    },
    {
      category = "Chest",
      id = "ChestSpot",
      name = "Chest Spot",
      help = "Where to attach the hat",
      editor = "combo",
      default = "Torso",
      items = function(self)
        return {"Torso", "Origin"}
      end
    },
    {
      category = "Chest",
      id = "ChestColor",
      name = "Chest Color",
      editor = "nested_obj",
      default = false,
      base_class = "ColorizationPropSet"
    },
    {
      category = "Hip",
      id = "Hip",
      name = "Hip",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCharacterHipComboItems(self)
      end
    },
    {
      category = "Hip",
      id = "HipSpot",
      name = "Hip Spot",
      help = "Where to attach the hat",
      editor = "combo",
      default = "Groin",
      items = function(self)
        return {"Groin", "Origin"}
      end
    },
    {
      category = "Hip",
      id = "HipColor",
      name = "Hip Color",
      editor = "nested_obj",
      default = false,
      base_class = "ColorizationPropSet"
    },
    {
      category = "Hat",
      id = "Hat",
      name = "Hat",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCharacterHatComboItems()
      end
    },
    {
      category = "Hat",
      id = "HatSpot",
      name = "Hat Spot",
      help = "Where to attach the hat",
      editor = "combo",
      default = "Head",
      items = function(self)
        return {"Head", "Origin"}
      end
    },
    {
      category = "Hat",
      id = "HatAttachOffsetX",
      name = "Hat Attach Offset X",
      editor = "number",
      default = false,
      scale = "cm",
      slider = true,
      min = -50,
      max = 50
    },
    {
      category = "Hat",
      id = "HatAttachOffsetY",
      name = "Hat Attach Offset Y",
      editor = "number",
      default = false,
      scale = "cm",
      slider = true,
      min = -50,
      max = 50
    },
    {
      category = "Hat",
      id = "HatAttachOffsetZ",
      name = "Hat Attach Offset Z",
      editor = "number",
      default = false,
      scale = "cm",
      slider = true,
      min = -50,
      max = 50
    },
    {
      category = "Hat",
      id = "HatAttachOffsetAngle",
      name = "Hat Attach Offset Angle",
      editor = "number",
      default = false,
      scale = "deg",
      slider = true,
      min = -18000,
      max = 10800
    },
    {
      category = "Hat",
      id = "HatColor",
      name = "Hat Color",
      editor = "nested_obj",
      default = false,
      base_class = "ColorizationPropSet"
    },
    {
      category = "Hat",
      id = "Hat2",
      name = "Hat2",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCharacterHatComboItems()
      end
    },
    {
      category = "Hat",
      id = "Hat2Spot",
      name = "Hat 2 Spot",
      help = "Where to attach the hat",
      editor = "combo",
      default = "Head",
      items = function(self)
        return {"Head", "Origin"}
      end
    },
    {
      category = "Hat",
      id = "Hat2AttachOffsetX",
      name = "Hat 2 Attach Offset X",
      editor = "number",
      default = false,
      scale = "cm",
      slider = true,
      min = -50,
      max = 50
    },
    {
      category = "Hat",
      id = "Hat2AttachOffsetY",
      name = "Hat 2 Attach Offset Y",
      editor = "number",
      default = false,
      scale = "cm",
      slider = true,
      min = -50,
      max = 50
    },
    {
      category = "Hat",
      id = "Hat2AttachOffsetZ",
      name = "Hat 2 Attach Offset Z",
      editor = "number",
      default = false,
      scale = "cm",
      slider = true,
      min = -50,
      max = 50
    },
    {
      category = "Hat",
      id = "Hat2AttachOffsetAngle",
      name = "Hat 2 Attach Offset Angle",
      editor = "number",
      default = false,
      scale = "deg",
      slider = true,
      min = -18000,
      max = 10800
    },
    {
      category = "Hat",
      id = "Hat2Color",
      name = "Hat 2 Color",
      editor = "nested_obj",
      default = false,
      base_class = "ColorizationPropSet"
    },
    {
      category = "Hair",
      id = "Hair",
      name = "Hair",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCharacterHairComboItems(self)
      end
    },
    {
      category = "Hair",
      id = "HairSpot",
      name = "Hair Spot",
      help = "Where to attach the hat",
      editor = "combo",
      default = "Head",
      items = function(self)
        return {"Head"}
      end
    },
    {
      category = "Hair",
      id = "HairColor",
      name = "Hair Color",
      editor = "nested_obj",
      default = false,
      base_class = "ColorizationPropSet"
    },
    {
      category = "Hair",
      id = "HairParam1",
      name = "Hair Spec Strength",
      editor = "number",
      default = 51,
      slider = true,
      min = 0,
      max = 255
    },
    {
      category = "Hair",
      id = "HairParam2",
      name = "Hair Env Strength",
      editor = "number",
      default = 51,
      slider = true,
      min = 0,
      max = 255
    },
    {
      category = "Hair",
      id = "HairParam3",
      name = "Hair Light Softness",
      editor = "number",
      default = 255,
      slider = true,
      min = 0,
      max = 255
    },
    {
      category = "Hair",
      id = "HairParam4",
      name = "Hair Specular Colorization",
      editor = "number",
      default = 0,
      no_edit = true,
      slider = true,
      min = 0,
      max = 255
    }
  }
}
DefineClass.AppearancePreset = {
  __parents = {"Preset", "Appearance"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "ViewInChararacterEditorButton",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "View in Anim Metadata Editor",
          func = "ViewInAnimMetadataEditor"
        }
      }
    },
    {
      id = "ViewInAnimMetadataEditor",
      editor = "func",
      default = function(self)
        CloseAnimationMomentsEditor()
        OpenAnimationMomentsEditor(self.id)
      end,
      no_edit = true
    }
  },
  GlobalMap = "AppearancePresets",
  EditorMenubarName = "Appearance Editor",
  EditorIcon = "CommonAssets/UI/Icons/business compare decision direction marketing.png",
  EditorMenubar = "Characters",
  EditorCustomActions = {
    {
      FuncName = "RefreshApperanceToAllUnits",
      Icon = "CommonAssets/UI/Ged/play",
      Menubar = "Actions",
      Name = "Apply to All",
      Rollover = "Refreshes all units on map with this appearance",
      Toolbar = "main"
    }
  }
}
function AppearancePreset:GetError()
  local parts = table.copy(AppearanceObject.attached_parts)
  table.insert(parts, "Body")
  local results = {}
  for _, part in ipairs(parts) do
    if self[part] and self[part] ~= "" and not IsValidEntity(self[part]) then
      results[#results + 1] = string.format("%s: invalid entity %s", part, self[part])
    end
  end
  if next(results) then
    return table.concat(results, "\n")
  end
end
DefineClass.BadgePresetDef = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "HasArrow",
      name = "HasArrow",
      editor = "bool",
      default = false
    },
    {
      id = "ArrowTemplate",
      name = "ArrowTemplate",
      editor = "combo",
      default = false,
      items = function(self)
        return XTemplateCombo("XBadgeArrow", false)
      end
    },
    {
      id = "UITemplate",
      name = "UITemplate",
      help = "The UI template which defines how the badge will look above the object.",
      editor = "combo",
      default = false,
      items = function(self)
        return XTemplateCombo()
      end
    },
    {
      id = "ZoomUI",
      name = "Zoom UI",
      editor = "bool",
      default = false
    },
    {
      id = "EntityName",
      name = "EntityName",
      help = "The entity to spawn as a badge on the unit, if any.",
      editor = "combo",
      default = false,
      items = function(self)
        return table.keys2(table.filter(GetAllEntities(), function(e)
          return e:sub(1, 2) == "Iw"
        end, "none"))
      end
    },
    {
      id = "AttachSpotName",
      name = "Attach Spot Name",
      help = "If set the badge will attach to the spot with that name.",
      editor = "text",
      default = false
    },
    {
      id = "attachOffset",
      name = "Entity Attach Offset",
      help = "An offset from the specified point to attach the badge to. Will overwrite any such offsets from the entity class.",
      editor = "point",
      default = false
    },
    {
      id = "noRotate",
      name = "Don't Rotate Arrow",
      help = "If set the arrow template will not be rotated according to the direction of the target but just stick on the edge of the screen.",
      editor = "bool",
      default = false
    },
    {
      id = "noHide",
      name = "Don't Hide",
      help = "Don't hide this badge if there are other badges on the target. Badges marked as \"noHide\" also do not count towards \"other badges on the target\".",
      editor = "bool",
      default = false
    },
    {
      id = "handleMouse",
      name = "Handle Mouse",
      help = "If enabled the badge will have a thread running to make sure it can handle mouse events like a normal UI window.",
      editor = "bool",
      default = false
    },
    {
      id = "BadgePriority",
      name = "BadgePriority",
      editor = "number",
      default = false
    }
  },
  GlobalMap = "BadgePresetDefs"
}
DefineClass.BindingsMenuCategory = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Name",
      editor = "text",
      default = false,
      translate = true
    }
  }
}
DefineClass.BugReportTag = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Platform",
      help = "Whether this is a Platform tag.",
      editor = "bool",
      default = false
    },
    {
      id = "Automatic",
      editor = "bool",
      default = false
    },
    {
      id = "ShowInExternal",
      name = "Show in External Bug Report",
      editor = "bool",
      default = false
    }
  }
}
DefineClass.Camera = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Preset",
      id = "comment",
      name = "comment",
      editor = "text",
      default = "Camera"
    },
    {
      category = "Preset",
      id = "display_name",
      name = "Display Name",
      editor = "text",
      default = T(145449857928, "Camera"),
      translate = true
    },
    {
      category = "Preset",
      id = "description",
      name = "Description",
      editor = "text",
      default = false,
      translate = true,
      lines = 3,
      max_lines = 10
    },
    {
      category = "Camera",
      id = "map",
      name = "Map",
      editor = "combo",
      default = false,
      cam_prop = true,
      items = function(self)
        return ListMaps()
      end
    },
    {
      category = "Camera",
      id = "SavedGame",
      name = "Saved Game",
      editor = "text",
      default = false
    },
    {
      category = "Camera",
      id = "order",
      name = "Order",
      editor = "number",
      default = 0
    },
    {
      category = "Camera",
      id = "locked",
      name = "Locked",
      editor = "bool",
      default = false,
      cam_prop = true
    },
    {
      category = "Camera",
      id = "flip_to_adjacent",
      name = "Flip to Adjacent",
      editor = "bool",
      default = false
    },
    {
      category = "Camera",
      id = "fade_in",
      name = "Fade In",
      editor = "number",
      default = 200
    },
    {
      category = "Camera",
      id = "fade_out",
      name = "Fade Out",
      editor = "number",
      default = 200
    },
    {
      category = "Camera",
      id = "movement",
      name = "Movement",
      editor = "combo",
      default = "",
      items = function(self)
        return table.keys2(CameraMovementTypes, nil, "")
      end
    },
    {
      category = "Camera",
      id = "interpolation",
      name = "Interpolation",
      editor = "combo",
      default = "linear",
      items = function(self)
        return table.keys2(CameraInterpolationTypes)
      end
    },
    {
      category = "Camera",
      id = "duration",
      name = "Duration",
      editor = "number",
      default = 1000
    },
    {
      category = "Camera",
      id = "buttonsSrc",
      editor = "buttons",
      default = false,
      buttons = {
        {name = "View Start", func = "ViewStart"},
        {name = "Set Start", func = "SetStart"}
      }
    },
    {
      category = "Camera",
      id = "cam_lookat",
      editor = "point",
      default = false,
      cam_prop = true
    },
    {
      category = "Camera",
      id = "cam_pos",
      editor = "point",
      default = false,
      cam_prop = true
    },
    {
      category = "Camera",
      id = "buttonsDest",
      editor = "buttons",
      default = false,
      buttons = {
        {name = "View Dest", func = "ViewDest"},
        {name = "Set Dest", func = "SetDest"}
      }
    },
    {
      category = "Camera",
      id = "cam_dest_lookat",
      editor = "point",
      default = false,
      cam_prop = true
    },
    {
      category = "Camera",
      id = "cam_dest_pos",
      editor = "point",
      default = false,
      cam_prop = true
    },
    {
      category = "Camera",
      id = "cam_type",
      editor = "choice",
      default = "Max",
      items = function(self)
        return GetCameraTypesItems
      end
    },
    {
      category = "Camera",
      id = "fovx",
      editor = "number",
      default = 4200,
      cam_prop = true
    },
    {
      category = "Camera",
      id = "zoom",
      editor = "number",
      default = 2000,
      cam_prop = true
    },
    {
      category = "Camera",
      id = "lightmodel",
      name = "Light Model",
      help = "Specify a light model, or leave as 'false' to restore the previous one.",
      editor = "preset_id",
      default = false,
      preset_class = "LightmodelPreset"
    },
    {
      category = "Camera",
      id = "interface",
      name = "Interface in Screenshots",
      help = "Check this to include game interface in the screenshots",
      editor = "bool",
      default = false
    },
    {
      category = "Camera",
      id = "cam_props",
      editor = "prop_table",
      default = false,
      cam_prop = true,
      indent = "",
      lines = 1,
      max_lines = 20
    },
    {
      category = "Camera",
      id = "camera_properties",
      name = "Camera Properties",
      editor = "prop_table",
      default = false,
      no_edit = true,
      indent = "",
      lines = 1,
      max_lines = 20
    },
    {
      category = "Functions",
      id = "beginFunc",
      name = "Begin() Function",
      editor = "func",
      default = function(self)
      end
    },
    {
      category = "Functions",
      id = "endFunc",
      name = "End() Function",
      editor = "func",
      default = function(self)
      end
    }
  },
  GlobalMap = "PredefinedCameras",
  EditorMenubarName = "Camera Editor",
  EditorIcon = "CommonAssets/UI/Icons/outline video.png",
  EditorMenubar = "Map",
  EditorCustomActions = {
    {
      FuncName = "OpenShowcase",
      Icon = "CommonAssets/UI/Ged/play",
      Menubar = "Actions",
      Name = "ShowcaseUI",
      Rollover = "Showcase UI <newline>Toggles \"Show Case\" interface showing all cameras from a group, sorted by order",
      Toolbar = "main"
    },
    {
      FuncName = "GedOpCreateCameraDest",
      Icon = "CommonAssets/UI/Ged/create_camera_destination",
      Menubar = "Actions",
      Name = "CameraDest",
      Rollover = "Create Camera Destination",
      Toolbar = "main"
    },
    {
      FuncName = "GedOpUpdateCamera",
      Icon = "CommonAssets/UI/Ged/update_current_camera",
      Menubar = "Actions",
      Name = "UpdateCamera",
      Rollover = "Update Camera",
      Toolbar = "main"
    },
    {
      FuncName = "GedOpViewMovement",
      Icon = "CommonAssets/UI/Ged/preview",
      IsToggledFuncName = "GedOpIsViewMovementToggled",
      Menubar = "Actions",
      Name = "ViewMovement",
      Rollover = "View Movement",
      Toolbar = "main"
    },
    {
      FuncName = "GedOpUnlockCamera",
      Icon = "CommonAssets/UI/Ged/unlock_camera",
      Menubar = "Actions",
      Name = "UnlockCamera",
      Rollover = "Unlock Camera",
      Toolbar = "main"
    },
    {
      FuncName = "GedOpMaxCamera",
      Icon = "CommonAssets/UI/Ged/max_camera",
      Menubar = "Camera",
      Name = "MaxCamera",
      Rollover = "Max Camera",
      Toolbar = "main"
    },
    {
      FuncName = "GedOpRTSCamera",
      Icon = "CommonAssets/UI/Ged/rts_camera",
      Menubar = "Camera",
      Name = "RTSCamera",
      Rollover = "RTS Camera",
      Toolbar = "main"
    },
    {
      FuncName = "GedOpTacCamera",
      Icon = "CommonAssets/UI/Ged/tac_camera",
      Menubar = "Camera",
      Name = "TacCamera",
      Rollover = "Tac Camera",
      Toolbar = "main"
    },
    {
      FuncName = "GedOpCreateReferenceImages",
      Icon = "CommonAssets/UI/Ged/create_reference_images",
      Menubar = "Actions",
      Name = "CreateReferenceImages",
      Rollover = "Create Reference Images(used during Night Build Game Tests)",
      Toolbar = "main"
    },
    {
      FuncName = "GedOpTakeScreenshots",
      Icon = "CommonAssets/UI/Ged/camera",
      Menubar = "Actions",
      Name = "TakeScreenshot",
      Rollover = "Takes screenshot of the selected camera(s)",
      Toolbar = "main"
    },
    {
      FuncName = "GedPrgPresetToggleStrips",
      Icon = "CommonAssets/UI/Ged/explorer",
      IsToggledFuncName = "GedPrgPresetBlackStripsVisible",
      Menubar = "Actions",
      Name = "ToggleBlackStrips",
      Rollover = "Toggle black strips (Alt-T)",
      Shortcut = "Alt-T",
      SortKey = "strips",
      Toolbar = "main"
    }
  }
}
function Camera:ApplyProperties(dont_lock, should_fade, ged)
  if (self.SavedGame or "") ~= "" then
    if (SavegameMeta or empty_table).savename ~= self.SavedGame and (not ged or ged:WaitQuestion("Load Game", "Load camera save?", "Yes", "No") == "ok") then
      LoadGame(self.SavedGame)
    end
  elseif (self.map or "") ~= "" and GetMapName() ~= self.map then
    if ged then
      if ged:WaitQuestion("Change Map", "Change camera map?", "Yes", "No") == "ok" then
        ChangeMap(self.map)
      else
        return
      end
    else
      ChangeMap(self.map)
    end
  end
  SetCamera(self.cam_pos, self.cam_lookat, self.cam_type, self.zoom, self.cam_props, self.fovx)
  if self.locked and not dont_lock then
    LockCamera("CameraPreset")
  else
    UnlockCamera("CameraPreset")
  end
  if should_fade and self.fade_in > 0 then
    local fade_in = should_fade and self.fade_in or 0
    local fade = OpenDialog("Fade")
    fade.idFade:SetVisible(true, "instant")
    if should_fade then
      WaitResourceManagerRequests(1000, 1)
    end
    fade.idFade.FadeOutTime = should_fade and self.fade_in or 0
    fade.idFade:SetVisible(false)
  end
  if self.movement ~= "" then
    local camera1 = {
      pos = self.cam_pos,
      lookat = self.cam_lookat
    }
    local camera2 = {
      pos = self.cam_dest_pos,
      lookat = self.cam_dest_lookat
    }
    InterpolateCameraMaxWakeup(camera1, camera2, self.duration, nil, self.interpolation, self.movement)
  end
  if self.lightmodel then
    SetLightmodel(1, self.lightmodel)
  end
  self:beginFunc()
  if should_fade and self.fade_in > 0 then
    local fade_in = should_fade and self.fade_in or 0
    if self.movement == "" then
      Sleep(fade_in)
    elseif fade_in > self.duration then
      Sleep(fade_in - self.duration)
    end
  end
end
function Camera:RevertProperties(should_fade)
  if should_fade and self.fade_out > 0 then
    local fade_out = should_fade and self.fade_out or 0
    local fade = GetDialog("Fade")
    if fade then
      fade.idFade:SetVisible(false, "instant")
      fade.idFade.FadeInTime = fade_out
      fade.idFade:SetVisible(true)
      Sleep(fade_out)
    end
  end
  CloseDialog("Fade")
  self:endFunc()
end
function Camera:QueryProperties()
  local cam_pos, cam_lookat, cam_type, zoom, cam_props, fovx = GetCamera()
  if cam_type ~= "Max" then
    self.movement = ""
  end
  self.cam_pos = cam_pos
  self.cam_lookat = cam_lookat
  self.cam_type = cam_type
  self.zoom = zoom
  self.cam_props = cam_props
  self.locked = camera.IsLocked()
  self.fovx = fovx
  self.map = GetMapName()
  GedObjectModified(self)
end
function Camera:PostLoad()
  Preset.PostLoad(self)
  local cam_props = self.camera_properties or empty_table
  for _, prop in ipairs(self:GetProperties()) do
    if prop.cam_prop then
      local value = cam_props[prop.id]
      if value ~= nil then
        self[prop.id] = value
      end
    end
  end
  self.camera_properties = nil
end
function Camera:SetStart()
  local cam_pos, cam_lookat = GetCamera()
  self:SetProperty("cam_pos", cam_pos)
  self:SetProperty("cam_lookat", cam_lookat)
  ObjModified(self)
end
function Camera:ViewStart()
  SetCamera(self.cam_pos, self.cam_lookat, self.cam_type, self.zoom, self.cam_props, self.fovx)
end
function Camera:SetDest()
  local cam_pos, cam_lookat = GetCamera()
  self:SetProperty("cam_dest_pos", cam_pos)
  self:SetProperty("cam_dest_lookat", cam_lookat)
  self:SetProperty("cam_type", "Max")
  ObjModified(self)
end
function Camera:ViewDest(camera)
  local pos = self.cam_dest_pos or self.cam_pos
  local lookat = self.cam_dest_lookat or self.cam_lookat
  SetCamera(pos, lookat, self.cam_type, self.zoom, self.cam_props, self.fovx)
end
function Camera:GetEditorView()
  if tonumber(self.order) then
    return Untranslated("<u(id)> <color 0 200 0><u(Comment)>(Showcase: #<u(order)>)</color>")
  else
    return Untranslated("<u(id)> <color 0 200 0><u(Comment)></color>")
  end
end
function Camera:OnEditorNew(parent, ged, is_paste)
  self.order = (#Presets.Camera[self.group] or 0) + 1
  self:SetId(self:GenerateUniquePresetId("Camera_" .. self.order))
  self:QueryProperties()
end
DefineClass.CommonTags = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef"
}
DefineClass.DisplayPreset = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "General",
      id = "display_name",
      name = "Display Name",
      editor = "text",
      default = "",
      translate = true
    },
    {
      category = "General",
      id = "display_name_caps",
      name = "Display Name Caps",
      editor = "text",
      default = "",
      translate = true
    },
    {
      category = "General",
      id = "description",
      name = "Description",
      editor = "text",
      default = "",
      translate = true,
      lines = 3,
      max_lines = 20
    },
    {
      category = "General",
      id = "description_gamepad",
      name = "Gamepad description",
      editor = "text",
      default = "",
      translate = true,
      wordwrap = true,
      lines = 3,
      max_lines = 20
    },
    {
      category = "General",
      id = "flavor_text",
      name = "Flavor text",
      editor = "text",
      default = "",
      translate = true,
      lines = 3,
      max_lines = 20
    },
    {
      category = "General",
      id = "new_in",
      name = "New in update",
      help = "Update showing this preset with a \"New!\" tag",
      editor = "text",
      default = "",
      no_edit = function(self)
        return not self.NewFeatureTag
      end
    }
  },
  AltFormat = "<EditorViewPresetPrefix><display_name><EditorViewPresetPostfix><color 0 128 0><opt(u(Comment),' ','')><color 128 128 128><opt(u(save_in),' - ','')>",
  EditorMenubarName = false,
  __hierarchy_cache = true,
  DescriptionFlavor = T(334322641039, "<description><newline><newline><flavor><flavor_text></flavor>"),
  NewFeatureTag = T(820790154429, "<em>NEW!</em> ")
}
function DisplayPreset:GetDisplayName()
  if self.new_in == config.NewFeaturesUpdate and self.NewFeatureTag then
    return self.NewFeatureTag .. self.display_name
  else
    return self.display_name
  end
end
function DisplayPreset:GetDisplayNameCaps()
  if self.new_in == config.NewFeaturesUpdate and self.NewFeatureTag then
    return self.NewFeatureTag .. self.display_name_caps
  else
    return self.display_name_caps
  end
end
function DisplayPreset:GetDescription()
  local description = self.description
  if GetUIStyleGamepad() and self.description_gamepad ~= "" then
    description = self.description_gamepad
  end
  if self.flavor_text == "" or not self.DescriptionFlavor then
    return description
  else
    return T({
      self.DescriptionFlavor,
      self,
      description = description
    })
  end
end
function DisplayPreset:OnEditorNew()
  self.new_in = config.NewFeaturesUpdate or nil
end
function DisplayPresetCombo(class, filter, ...)
  local params = pack_params(...)
  return function()
    return ForEachPreset(class, function(preset, group, items, filter, params)
      if not filter or filter(preset, unpack_params(params)) then
        items[#items + 1] = {
          value = preset.id,
          text = preset:GetDisplayName()
        }
      end
    end, {}, filter, params)
  end
end
DefineClass.GameDifficultyDef = {
  __parents = {
    "MsgReactionsPreset",
    "DisplayPreset"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "effects",
      name = "Effects on NewMapLoaded",
      editor = "nested_list",
      default = false,
      base_class = "Effect",
      all_descendants = true,
      auto_expand = true
    }
  },
  HasGroups = false,
  HasSortKey = true,
  HasParameters = true,
  GlobalMap = "GameDifficulties",
  EditorMenubarName = "Game Difficulty",
  EditorIcon = "CommonAssets/UI/Icons/bullet list.png",
  EditorMenubar = "Editors.Lists"
}
DefineModItemPreset("GameDifficultyDef", {
  EditorName = "Game difficulty",
  EditorSubmenu = "Gameplay"
})
function GetGameDifficulty()
  local game = Game
  return game and game.game_difficulty
end
function OnMsg.NewMapLoaded()
  if not mapdata.GameLogic or not Game then
    return
  end
  local difficulty = GameDifficulties[GetGameDifficulty()]
  ExecuteEffectList(difficulty and difficulty.effects, Game)
end
function AddDifficultyLootConditions()
  ForEachPreset("GameDifficultyDef", function(preset, group)
    local difficulty = preset.id
    LootCondition["Difficulty " .. difficulty] = function()
      return (Game and Game.game_difficulty) == difficulty
    end
  end)
end
OnMsg.PresetSave = AddDifficultyLootConditions
OnMsg.DataLoaded = AddDifficultyLootConditions
DefineClass.GameRuleDef = {
  __parents = {
    "MsgReactionsPreset",
    "DisplayPreset"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "General",
      id = "init_as_active",
      name = "Active by default",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "exclusionlist",
      name = "Exclusion List",
      help = "List of other game rules that are not compatible with this one. If this rule is active the player won't be able to enable the rules in the exclusion list.",
      editor = "preset_id_list",
      default = {},
      preset_class = "GameRuleDef",
      item_default = ""
    },
    {
      id = "effects",
      name = "Effects on NewMapLoaded",
      editor = "nested_list",
      default = false,
      base_class = "Effect",
      all_descendants = true
    }
  },
  HasGroups = false,
  HasSortKey = true,
  HasParameters = true,
  GlobalMap = "GameRuleDefs",
  EditorMenubarName = "Game Rules",
  EditorIcon = "CommonAssets/UI/Icons/bullet list.png",
  EditorMenubar = "Editors.Lists"
}
DefineModItemPreset("GameRuleDef", {EditorName = "Game rule", EditorSubmenu = "Gameplay"})
function GameRuleDef:IsCompatible(active_rules)
  local exclusions = table.invert(self.exclusionlist or empty_table)
  local id = self.id
  for rule_id in pairs(active_rules) do
    if exclusions[rule_id] or table.find(GameRuleDefs[rule_id].exclusionlist or empty_table, id) then
      return false
    end
  end
  return true
end
function IsGameRuleActive(rule_id)
  local game = Game
  return (game and game.game_rules or empty_table)[rule_id]
end
function OnMsg.NewMapLoaded()
  if not mapdata.GameLogic or not Game then
    return
  end
  ForEachPreset("GameRuleDef", function(rule)
    if IsGameRuleActive(rule.id) then
      ExecuteEffectList(rule.effects, Game)
    end
  end)
end
DefineClass.GameStateDef = {
  __parents = {
    "DisplayPreset"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "ShowInFilter",
      name = "Show in filters",
      editor = "bool",
      default = true
    },
    {
      id = "PlayFX",
      name = "Play FX",
      editor = "bool",
      default = true
    },
    {
      id = "MapState",
      name = "Is map state",
      help = "Map states are removed when exiting a map",
      editor = "bool",
      default = true
    },
    {
      id = "PersistInSaveGame",
      name = "Persist in save game",
      editor = "bool",
      default = false
    },
    {
      id = "Gossip",
      name = "Gossip",
      help = "Send gossip on state change",
      editor = "bool",
      default = false
    },
    {
      id = "GroupExclusive",
      name = "Exclusive for the group",
      help = "When set, removes any other game states from the same group",
      editor = "bool",
      default = false
    },
    {
      id = "Color",
      name = "Color",
      help = "Used for easier visual identification of the game state in editors",
      editor = "color",
      default = 4278190080
    },
    {
      id = "Icon",
      name = "Icon",
      editor = "ui_image",
      default = false
    },
    {
      id = "AutoSet",
      name = "Auto set",
      help = "State is recalculated on every GameStateChange",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      category = "Debug",
      id = "CurrentState",
      name = "Current state",
      editor = "bool",
      default = false,
      dont_save = true
    }
  },
  HasSortKey = true,
  GlobalMap = "GameStateDefs",
  EditorMenubarName = "Game States",
  EditorMenubar = "Editors.Lists",
  EditorViewPresetPostfix = Untranslated("<select(AutoSet,'',' [autoset]')><select(CurrentState,'',' [on]')>")
}
function GameStateDef:GetCurrentState()
  return GameState[self.id]
end
function GameStateDef:SetCurrentState(state)
  return ChangeGameState(self.id, state)
end
function GameStateDef:OnDataUpdated()
  RebuildAutoSetGameStates()
end
function OnMsg.GameStateChanged(changed)
  local fx
  for state, active in pairs(changed) do
    local def = GameStateDefs[state]
    if def and def.PlayFX then
      fx = fx or {}
      fx[#fx + 1] = state
      fx[state] = active
    end
  end
  if not fx then
    return
  end
  table.sort(fx)
  CreateGameTimeThread(function(fx)
    for _, state in ipairs(fx) do
      if fx[state] then
        PlayFX(state, "start")
      else
        PlayFX(state, "end")
      end
    end
  end, fx)
end
function OnMsg.GatherFXActions(list)
  ForEachPreset("GameStateDef", function(state, group, list)
    if state.PlayFX then
      list[#list + 1] = state.id
    end
  end, list)
end
function GetGameStateFilter()
  return ForEachPreset("GameStateDef", function(state, group, items)
    if state.ShowInFilter then
      items[#items + 1] = state.id
    end
  end, {})
end
function OnMsg.DoneMap()
  local map_states = ForEachPreset("GameStateDef", function(state, group, map_states, GameState)
    if state.MapState and GameState[state.id] then
      map_states[state.id] = false
    end
  end, {}, GameState)
  ChangeGameState(map_states)
end
function OnMsg.PersistSave(data)
  local persisted_gamestate = {}
  ForEachPreset("GameStateDef", function(state, group, persisted_gamestate, GameState)
    if state.PersistInSaveGame and GameState[state.id] then
      persisted_gamestate[state.id] = true
    end
  end, persisted_gamestate, GameState)
  if next(persisted_gamestate) then
    data.GameState = persisted_gamestate
  end
end
function OnMsg.PersistLoad(data)
  local persisted_gamestate = data.GameState or empty_table
  ForEachPreset("GameStateDef", function(state, group, persisted_gamestate, GameState)
    if state.PersistInSaveGame then
      GameState[state.id] = persisted_gamestate[state.id] or false
    end
  end, persisted_gamestate, GameState)
end
DefineClass.LootDef = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Loot",
      id = "loot",
      name = "Loot",
      editor = "choice",
      default = "random",
      items = function(self)
        return {
          "random",
          "all",
          "first",
          "cycle",
          "each then last"
        }
      end
    },
    {
      category = "Test",
      id = "TestDlcs",
      name = "Test dlcs",
      editor = "set",
      default = set(),
      dont_save = true,
      items = function(self)
        return DlcComboItems()
      end
    },
    {
      category = "Test",
      id = "TestConditions",
      name = "Loot conditions",
      editor = "set",
      default = set(),
      dont_save = true,
      items = function(self)
        return table.keys2(LootCondition, true)
      end
    },
    {
      category = "Test",
      id = "TestGameConditions",
      name = "Test Additional Conditions",
      help = [[
If not set the additional conditions are ignored during testing. 
If set, the additional conditions are evaluated against the current state of the game. Therefore test results can change when the current game state changes.]],
      editor = "bool",
      default = false
    },
    {
      category = "Test",
      id = "TestFile",
      name = "Output CSV",
      editor = "text",
      default = "svnProject/items.csv",
      dont_save = true,
      buttons = {
        {
          name = "Write",
          func = "WriteChancesCSV"
        }
      }
    },
    {
      category = "Test",
      id = "TestResults",
      name = "Test results",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true,
      lines = 1,
      max_lines = 30
    }
  },
  GlobalMap = "LootDefs",
  ContainerClass = "LootDefEntry",
  EditorMenubarName = "Loot Tables",
  EditorShortcut = "Ctrl-L",
  EditorIcon = "CommonAssets/UI/Icons/currency dollar finance money payment.png",
  EditorView = Untranslated("<if(eq(loot,'all'))><color 255 128 64></if><id><color 0 128 0><opt(u(Comment),' - ','')>"),
  EditorPreview = Untranslated("<Preview>")
}
DefineModItemPreset("LootDef", {
  EditorName = "Loot definition",
  EditorSubmenu = "Gameplay"
})
function LootDef:GenerateLootSeed(init_seed, looter, looted)
  local loot, seed = self.loot
  if loot == "cycle" or loot == "each then last" then
    seed = init_seed == -1 and InteractionRand(nil, "Loot", looter, looted) or init_seed + 1
    if loot == "each then last" then
      seed = Min(seed, #self) or seed
    end
  else
    seed = InteractionRand(nil, "Loot", looter, looted)
  end
  return seed
end
function LootDef:GenerateLoot(looter, looted, seed, items, modifiers, amount_modifier)
  local rand
  NetUpdateHash("LootDef:GenerateLoot", seed)
  local loot
  seed = seed or self:GenerateLootSeed(nil, looter, looted)
  if self.loot == "random" then
    local weight, none_weight = 0, 0
    for _, entry in ipairs(self) do
      if entry:TestConditions(looter, looted) then
        if entry.class == "LootEntryNoLoot" then
          none_weight = none_weight + entry.weight
        else
          weight = weight + entry.weight
        end
      end
    end
    rand, seed = BraidRandom(seed, weight + none_weight)
    if rand >= weight then
      return
    end
    for _, entry in ipairs(self) do
      if entry.class ~= "LootEntryNoLoot" and entry:TestConditions(looter, looted) then
        rand = rand - entry.weight
        if rand < 0 then
          loot = entry:GenerateLoot(looter, looted, seed, items, modifiers, amount_modifier)
          break
        end
      end
    end
  elseif self.loot == "all" then
    local loot
    for _, entry in ipairs(self) do
      rand, seed = BraidRandom(seed)
      if entry:TestConditions(looter, looted) then
        local entry_loot = entry:GenerateLoot(looter, looted, seed, items, modifiers, amount_modifier)
        loot = loot or entry_loot
      end
    end
  elseif self.loot == "first" then
    for _, entry in ipairs(self) do
      if entry:TestConditions(looter, looted) then
        loot = entry:GenerateLoot(looter, looted, seed, items, modifiers, amount_modifier)
        break
      end
    end
  elseif self.loot == "cycle" then
    local start_idx = 1 + seed % #self
    local idx = start_idx
    local entry = self[idx]
    local entry_ok = entry:TestConditions(looter, looted)
    while not entry_ok do
      idx = idx < #self and idx + 1 or 1
      entry = self[idx]
      entry_ok = idx ~= start_idx and entry:TestConditions(looter, looted)
    end
    if entry_ok then
      loot = entry:GenerateLoot(looter, looted, seed, items, modifiers, amount_modifier)
    end
  elseif seed < #self then
    for idx = seed, #self do
      local entry = self[idx]
      if entry:TestConditions(looter, looted) then
        loot = entry:GenerateLoot(looter, looted, seed, items, modifiers, amount_modifier)
        break
      end
    end
  else
    for idx = #self, 1, -1 do
      local entry = self[idx]
      if entry:TestConditions(looter, looted) then
        loot = entry:GenerateLoot(looter, looted, seed, items, modifiers, amount_modifier)
        break
      end
    end
  end
  local loot_items = {}
  for _, item in ipairs(items) do
    table.insert(loot_items, item.class)
  end
  NetGossip("GenerateLoot", GameTime(), loot_items, GetCurrentPlaytime(), Game and Game.CampaignTime)
  return loot
end
function LootDef:ListChances(items, env, chance, amount_modifier)
  if self.loot == "random" then
    local weight = 0
    for _, entry in ipairs(self) do
      if entry:ListChancesTest(env) then
        weight = weight + entry.weight
      end
    end
    if weight <= 0 then
      return
    end
    for _, entry in ipairs(self) do
      if entry.class ~= "LootEntryNoLoot" and entry:ListChancesTest(env) then
        entry:ListChances(items, env, chance * entry.weight / weight, amount_modifier)
      end
    end
  elseif self.loot == "all" then
    for _, entry in ipairs(self) do
      if entry:ListChancesTest(env) then
        entry:ListChances(items, env, chance, amount_modifier)
      end
    end
  else
    for _, entry in ipairs(self) do
      if entry:ListChancesTest(env) then
        return entry:ListChances(items, env, chance, amount_modifier)
      end
    end
  end
end
function LootDef:SetTestDlcs(v)
  LootTestDlcs = v
end
function LootDef:GetTestDlcs()
  return LootTestDlcs
end
function LootDef:SetTestConditions(v)
  LootTestConditions = v
end
function LootDef:GetTestConditions()
  return LootTestConditions
end
function LootDef:SetTestFile(v)
  LootTestFile = v
end
function LootDef:GetTestFile()
  return LootTestFile
end
function LootDef:WriteChancesCSV(root)
  local item_list = root:GetTestItems()
  SaveCSV(LootTestFile, item_list, nil, {"Chance (%)", "Item"})
end
function LootDef:GetTestItems()
  local env = {
    dlcs = {
      [""] = true
    },
    conditions = {
      [""] = true
    }
  }
  for v in pairs(LootTestDlcs) do
    env.dlcs[v] = true
  end
  for v in pairs(LootTestConditions) do
    env.conditions[v] = true
  end
  env.game_conditions = self.TestGameConditions
  local items = {}
  self:ListChances(items, env, 1.0)
  local item_list = {}
  for item, chance in pairs(items) do
    if 1.0E-9 < chance then
      item_list[#item_list + 1] = {chance, item}
    end
  end
  table.sort(item_list, function(a, b)
    if a[1] == b[1] then
      return a[2] < b[2]
    end
    return a[1] > b[1]
  end)
  return item_list
end
function LootDef:GetTestResults()
  local item_list = self:GetTestItems()
  local nothing = 1.0
  for i, pair in ipairs(item_list) do
    item_list[i] = string.format("%6.02f%%      %s", pair[1] * 100, pair[2])
    nothing = nothing - pair[1]
  end
  if 1.0E-4 < nothing then
    item_list[#item_list + 1] = string.format("%6.02f%%      Nothing", nothing * 100)
  end
  return table.concat(item_list, "\n")
end
function LootDef:GetPreview()
  local texts = {}
  for _, entry in ipairs(self) do
    texts[#texts + 1] = entry:GetEditorPreview()
  end
  return table.concat(texts, "; ")
end
LootTestDlcs = {}
LootTestConditions = {}
LootTestFile = "svnProject/items.csv"
if config.Mods then
  AppendClass.ModItemLootDef = {
    properties = {
      {id = "TestDlcs"},
      {
        id = "TestConditions"
      },
      {
        id = "TestGameConditions"
      },
      {id = "TestFile"},
      {
        id = "TestResults"
      }
    }
  }
end
DefineClass.LootDefEntry = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Conditions",
      id = "disable",
      name = "Disable",
      editor = "bool",
      default = false
    },
    {
      category = "Conditions",
      id = "comment",
      name = "Comment",
      editor = "text",
      default = false
    },
    {
      category = "Conditions",
      id = "weight",
      name = "Weight",
      editor = "number",
      default = 1000,
      scale = 1000,
      min = 0,
      max = 1000000000
    },
    {
      category = "Conditions",
      id = "dlc",
      name = "Require dlc",
      editor = "choice",
      default = "",
      items = function(self)
        return DlcComboItems()
      end
    },
    {
      category = "Conditions",
      id = "negate",
      name = "Negate loot condition",
      editor = "bool",
      default = false
    },
    {
      category = "Conditions",
      id = "condition",
      name = "Loot condition",
      help = "Loot specific conditions (defined in LootConditions) such as game difficulty. These can be manipulated in Test section to simulate expected loot results.",
      editor = "choice",
      default = "",
      items = function(self)
        return table.keys2(LootCondition, true)
      end
    },
    {
      category = "Conditions",
      id = "game_conditions",
      name = "Additional conditions",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    }
  },
  StoreAsTable = true,
  EditorView = Untranslated("<tab 0><if(disable)>*** </if><FormatAsFloat(weight,1000)><tab 50><dlc><tab 170><if(negate)>!</if><condition><tab 300><EntryView><color 0 128 0><opt(u(comment),'<tab 600>','')>"),
  EntryView = Untranslated("<class>")
}
function LootDefEntry:GetEditorPreview()
  local text = T({
    self.EntryView,
    self
  })
  local txt
  if self.weight ~= 1000 then
    txt = (txt or "(") .. Untranslated("w:" .. self.weight)
  end
  if self.dlc ~= "" then
    txt = (txt or "(") .. Untranslated(" d:" .. self.dlc)
  end
  local condition_texts = {}
  if self.condition ~= "" then
    condition_texts[#condition_texts + 1] = Untranslated((self.negate and " !" or " ") .. self.condition)
  end
  for _, condition in ipairs(self.game_conditions) do
    condition_texts[#condition_texts + 1] = Untranslated(_InternalTranslate(condition:GetEditorView(), condition, false))
  end
  if next(condition_texts) then
    txt = (txt or "(") .. table.concat(condition_texts, ";")
  end
  if txt then
    text = text .. txt .. Untranslated(")")
  end
  return text
end
function LootDefEntry:TestConditions(looter, looted)
  if self.disable then
    return
  end
  if not IsDlcAvailable(self.dlc) then
    return false
  end
  local res = LootCondition[self.condition](looter, looted)
  if self.negate then
    res = not res
  end
  res = res and EvalConditionList(self.game_conditions, looter, looted)
  return res
end
function LootDefEntry:GenerateLoot(looter, looted, seed, items, modifiers, amount_modifier)
end
function LootDefEntry:ListChancesTest(env)
  if self.disable or not env.dlcs[self.dlc] then
    return
  end
  local res = env.conditions[self.condition]
  if self.negate then
    res = not res
  end
  if env.game_conditions and res then
    res = EvalConditionList(self.game_conditions)
  end
  return res
end
function LootDefEntry:ListChances(items, env, chance, amount_modifier)
end
LootCondition = rawget(_G, "LootCondition") or {
  [""] = function(looter, looted)
    return true
  end
}
setmetatable(LootCondition, {
  __index = function()
    return empty_func
  end
})
DefineClass.LootEntryLootDef = {
  __parents = {
    "LootDefEntry"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Loot",
      id = "loot_def",
      name = "Loot def",
      editor = "preset_id",
      default = false,
      preset_class = "LootDef"
    },
    {
      category = "Loot",
      id = "amount_modifier",
      name = "Amount modifier",
      help = "Modifies the amount of resources generated from the loot",
      editor = "number",
      default = 1000000,
      scale = 1000000,
      step = 100000,
      min = 1000,
      max = 1000000000
    }
  },
  EntryView = Untranslated("<loot_def> <if(not_eq(amount_modifier,1000000))>x<FormatAsFloat(amount_modifier,1000000,3,true)></if>")
}
function LootEntryLootDef:GenerateLoot(looter, looted, seed, items, modifiers, amount_modifier)
  local loot_def = LootDefs[self.loot_def]
  if not loot_def then
    return
  end
  return loot_def:GenerateLoot(looter, looted, seed, items, modifiers, MulDivRound(amount_modifier or 1000000, self.amount_modifier, 1000000))
end
function LootEntryLootDef:ListChances(items, env, chance, amount_modifier)
  local loot_def = LootDefs[self.loot_def]
  if not loot_def then
    return
  end
  local nesting = env.nesting or 0
  if 100 < nesting then
    local item = "LootDef: " .. self.loot_def
    items[item] = (items[item] or 0.0) + chance
    return
  end
  env.nesting = nesting + 1
  loot_def:ListChances(items, env, chance, MulDivRound(amount_modifier or 1000000, self.amount_modifier, 1000000))
  env.nesting = nesting
end
function LootEntryLootDef:GetError()
  local loot_def = GetParentTableOfKindNoCheck(self, "LootDef")
  if loot_def and self.loot_def == loot_def.id then
    return "Recursive LootDef!"
  end
end
DefineClass.LootEntryNoLoot = {
  __parents = {
    "LootDefEntry"
  },
  __generated_by_class = "ClassDef",
  EntryView = Untranslated("<color 192 0 0 >No loot")
}
function LootEntryNoLoot:ListChances(items, env, chance, amount_modifier)
end
function LootEntryNoLoot:GenerateLoot(self, looter, looted, seed, items, modifiers, amount_modifier)
end
DefineClass.NoisePreset = {
  __parents = {
    "Preset",
    "PerlinNoise"
  },
  __generated_by_class = "PresetDef",
  GlobalMap = "NoisePresets",
  EditorMenubarName = "Noise Editor",
  EditorIcon = "CommonAssets/UI/Icons/bell message new notification sign.png",
  EditorMenubar = "Map"
}
DefineClass.ObjMaterial = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "invulnerable",
      name = "Invulnerable",
      editor = "bool",
      default = false
    },
    {
      id = "impenetrable",
      name = "Impenetrable",
      editor = "bool",
      default = false
    },
    {
      id = "is_prop",
      name = "Prop Material",
      editor = "bool",
      default = false
    },
    {
      id = "max_hp",
      name = "Max HP",
      editor = "number",
      default = 100
    },
    {
      id = "breakdown_defense",
      name = "Breakdown Defense",
      help = "If the material is attached to a door, this defense is added to the break difficulty.",
      editor = "number",
      default = 30
    },
    {
      id = "destruction_propagation_strength",
      name = "Destruction Propagation Strength",
      help = "If the material is attached to a door, this defense is added to the break difficulty.",
      editor = "number",
      default = 0
    },
    {
      id = "FXTarget",
      name = "FX Target",
      editor = "text",
      default = false
    },
    {
      id = "noise_on_hit",
      name = "Noise On Hit",
      editor = "number",
      default = 0,
      min = 0
    },
    {
      id = "noise_on_break",
      name = "Noise On Break",
      editor = "number",
      default = 0,
      min = 0
    }
  },
  GlobalMap = "ObjMaterials",
  EditorMenubarName = "ObjMaterial Editor",
  FilterClass = "ObjMaterialFilter"
}
DefineClass.ObjMaterialFilter = {
  __parents = {"GedFilter"},
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "invulnerable",
      name = "Invulnerable",
      editor = "set",
      default = false,
      max_items_in_set = 1,
      items = function(self)
        return {"true", "false"}
      end
    },
    {
      id = "impenetrable",
      name = "Impenetrable",
      editor = "set",
      default = false,
      max_items_in_set = 1,
      items = function(self)
        return {"true", "false"}
      end
    },
    {
      id = "is_prop",
      name = "Prop Material",
      editor = "set",
      default = false,
      max_items_in_set = 1,
      items = function(self)
        return {"true", "false"}
      end
    }
  }
}
function ObjMaterialFilter:FilterObject(obj)
  local filter = function(prop)
    local filter, value = self[prop], obj[prop]
    return filter and (filter["true"] and not value or filter["false"] and value)
  end
  return not filter("invulnerable") and not filter("impenetrable") and not filter("is_prop")
end
DefineClass.PhotoFilterPreset = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "General",
      id = "displayName",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      category = "General",
      id = "desc",
      name = "Description",
      editor = "text",
      default = false,
      translate = true
    },
    {
      category = "General",
      id = "shader_file",
      name = "Shader Filename",
      editor = "browse",
      default = "",
      folder = "Shaders/",
      filter = "FX files|*.fx"
    },
    {
      category = "General",
      id = "shader_pass",
      name = "Shader Pass",
      editor = "text",
      default = "Generic"
    },
    {
      category = "General",
      id = "texture1",
      name = "Texture 1",
      editor = "browse",
      default = "",
      filter = "Image files|*.tga"
    },
    {
      category = "General",
      id = "texture2",
      name = "Texture 2",
      editor = "browse",
      default = "",
      filter = "Image files|*.tga"
    },
    {
      category = "General",
      id = "activate",
      name = "Run on activation",
      editor = "func",
      default = function(self)
      end
    },
    {
      category = "General",
      id = "deactivate",
      name = "Run on deactivation",
      editor = "func",
      default = function(self)
      end
    }
  },
  HasSortKey = true,
  GlobalMap = "PhotoFilterPresetMap",
  EditorMenubarName = "Photo Filters",
  EditorIcon = "CommonAssets/UI/Icons/camera digital image media photo photography picture.png",
  EditorMenubar = "Editors.Other"
}
function PhotoFilterPreset:GetShaderDescriptor()
  return {
    shader = self.shader_file,
    pass = self.shader_pass,
    tex1 = self.texture1,
    tex2 = self.texture2,
    activate = self.activate,
    deactivate = self.deactivate
  }
end
DefineClass.RadioStationPreset = {
  __parents = {
    "DisplayPreset"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "General",
      id = "Folder",
      name = "Folder",
      editor = "browse",
      default = "Music",
      folder = "Music",
      filter = "folder"
    },
    {
      category = "General",
      id = "SilenceDuration",
      name = "Silence between tracks",
      editor = "number",
      default = 1000,
      scale = "sec"
    },
    {
      category = "General",
      id = "Volume",
      name = "Volume",
      help = "Volume to play at each new track",
      editor = "number",
      default = false
    },
    {
      category = "General",
      id = "FadeOutTime",
      name = "Fade Out Time",
      help = "Time to fade out to a new volume",
      editor = "number",
      default = false,
      no_edit = function(self)
        return not self.Volume
      end,
      scale = "sec"
    },
    {
      category = "General",
      id = "FadeOutVolume",
      name = "FadeOutVolume",
      help = "Volume to fade out to after the fade out time",
      editor = "number",
      default = false,
      no_edit = function(self)
        return not self.FadeOutTime
      end
    },
    {
      category = "General",
      id = "Mode",
      name = "Mode",
      help = "Tracks play randomly by default but if \"list\" mode is set they play one after another",
      editor = "choice",
      default = false,
      items = function(self)
        return {"list"}
      end
    }
  },
  HasSortKey = true,
  GlobalMap = "RadioStationPresets",
  EditorMenubarName = "Radio Stations",
  EditorIcon = "CommonAssets/UI/Icons/notes.png",
  EditorMenubar = "Editors.Audio",
  EditorCustomActions = {
    {
      FuncName = "TestPlay",
      Icon = "CommonAssets/UI/Ged/play",
      Name = "Play",
      Toolbar = "main"
    }
  }
}
DefineModItemPreset("RadioStationPreset", {
  EditorName = "Radio station",
  EditorSubmenu = "Other"
})
function RadioStationPreset:TestPlay()
  StartRadioStation(self.id)
end
function RadioStationPreset:Play()
  local playlist = self:GetPlaylist()
  Playlists.Radio = playlist
  if not Music or Music.Playlist == "Radio" then
    SetMusicPlaylist("Radio", true, "force")
  end
end
function RadioStationPreset:GetPlaylist()
  local playlist = PlaylistCreate(self.Folder)
  playlist.SilenceDuration = self.SilenceDuration
  playlist.Volume = self.Volume
  playlist.FadeOutTime = self.FadeOutTime
  playlist.FadeOutVolume = self.FadeOutVolume
  return playlist
end
if FirstLoad then
  ActiveRadioStation = false
  ActiveRadioStationThread = false
  ActiveRadioStationStart = RealTime()
end
function StartRadioStation(station_id, delay, force)
  local station = RadioStationPresets[station_id or false] or RadioStationPresets[GetDefaultRadioStation() or false]
  station_id = station and station.id or false
  if force or ActiveRadioStation ~= station_id and mapdata and mapdata.GameLogic then
    DbgMusicPrint(string.format("Start radio '%s' with %d delay%s", station_id, delay or 0, force and "[forced]" or ""))
    if ActiveRadioStation and config.Radio then
      local session_duration = (RealTime() - ActiveRadioStationStart) / 1000
      Msg("RadioStationSession", ActiveRadioStation, session_duration)
      NetGossip("RadioStationSession", ActiveRadioStation, session_duration)
    end
    ActiveRadioStation = station_id
    ActiveRadioStationStart = RealTime()
    DeleteThread(ActiveRadioStationThread)
    ActiveRadioStationThread = CreateRealTimeThread(function(station)
      Sleep(delay or 0)
      if station then
        station:Play()
      end
      ActiveRadioStationThread = false
    end, station)
    Msg("RadioStationPlay", station_id, station)
  end
end
function OnMsg.QuitGame()
  if config.Radio then
    StartRadioStation(false)
  end
end
function OnMsg.LoadGame()
  if config.Radio then
    StartRadioStation(GetAccountStorageOptionValue("RadioStation"))
  end
end
function OnMsg.NewMapLoaded()
  if config.Radio then
    StartRadioStation(GetAccountStorageOptionValue("RadioStation"))
  end
end
function GetDefaultRadioStation()
  return table.get(const, "Music", "DefaultRadioStation") or ""
end
if rawget(_G, "ModItemRadioStationPreset") then
  local properties = ModItemRadioStationPreset.properties
  if not properties then
    local properties = {}
    ModItemRadioStationPreset.properties = properties
  end
  local org_prop = table.find_value(RadioStationPreset.properties, "id", "Folder")
  local prop = table.copy(org_prop, "deep")
  prop.default = "RadioStations"
  table.insert(properties, prop)
  local oldOnEditorNew = ModItemRadioStationPreset.OnEditorNew or empty_func
  function ModItemRadioStationPreset:OnEditorNew(...)
    local radio_stations_path = self.mod.content_path .. "RadioStations/"
    local radio_stations_os_path, err = ConvertToOSPath(radio_stations_path)
    AsyncCreatePath(radio_stations_os_path)
    self:SetProperty("Folder", radio_stations_os_path)
    return oldOnEditorNew(self, ...)
  end
end
DefineClass.RoofTypes = {
  __parents = {"ListPreset"},
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
      id = "default_inclination",
      name = "Default Inclination",
      editor = "number",
      default = 1200,
      scale = "deg",
      slider = true,
      min = 0,
      max = 2700
    }
  }
}
DefineClass.RoomDecalData = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef"
}
DefineClass.TODOPreset = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  TODOItems = {
    "Implement",
    "Review",
    "Test"
  },
  EditorMenubarName = false
}
DefineClass.TagsProperty = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "General",
      id = "tags",
      name = "Tags",
      editor = "set",
      default = false,
      buttons = {
        {
          name = "Edit",
          func = "OpenTagsEditor"
        }
      },
      items = function(self)
        return PresetsCombo(self.TagsListItem, "Default")
      end
    }
  },
  TagsListItem = "CommonTags"
}
function TagsProperty:HasTag(tag)
  return (self.tags or empty_table)[tag] and true or false
end
function TagsProperty:OpenTagsEditor()
  g_Classes[self.TagsListItem]:OpenEditor()
end
DefineClass.TerrainGrass = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Classes",
      editor = "string_list",
      default = {},
      item_default = "",
      items = function(self)
        return ClassDescendantsCombo("Grass")
      end
    },
    {
      id = "SizeFrom",
      name = "Size From",
      editor = "number",
      default = 100,
      min = 50,
      max = 200
    },
    {
      id = "SizeTo",
      name = "Size To",
      editor = "number",
      default = 100,
      min = 50,
      max = 200
    },
    {
      id = "Weight",
      name = "Weight",
      editor = "number",
      default = 100,
      min = 0,
      max = 100
    },
    {
      id = "NoiseWeight",
      name = "NoiseWeight",
      help = "Weight of a random spatial noise modification to density",
      editor = "number",
      default = 0,
      min = -1000,
      max = 1000
    },
    {
      id = "TiltWithTerrain",
      name = "TiltWithTerrain",
      help = "Orient with terrain normal",
      editor = "bool",
      default = false
    },
    {
      id = "PlaceOnWater",
      name = "PlaceOnWater",
      help = "Place on water surface",
      editor = "bool",
      default = false
    },
    {
      id = "ColorVarFrom",
      name = "Color Variation From",
      editor = "color",
      default = 4284769380
    },
    {
      id = "ColorVarTo",
      name = "Color Variation To",
      editor = "color",
      default = 4284769380
    }
  }
}
function TerrainGrass:GetEditorView()
  local classes = self:GetClassList() or {""}
  table.replace(classes, "", "No Grass")
  return table.concat(classes, ", ") .. " (" .. self.Weight .. ")"
end
function TerrainGrass:GetClassList()
  local classes = table.keys(table.invert(self.Classes or empty_table), true)
  return 0 < #classes and classes
end
DefineClass.TerrainProps = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "TerrainName",
      name = "Terrain Name",
      editor = "choice",
      default = false,
      items = function(self)
        return GetTerrainNamesCombo()
      end
    },
    {
      id = "TerrainIndex",
      name = "Terrain Index",
      editor = "number",
      default = false,
      dont_save = true,
      read_only = true
    },
    {
      id = "TerrainPreview",
      name = "Terrain Preview",
      editor = "image",
      default = false,
      dont_save = true,
      read_only = true,
      img_size = 100,
      img_box = 1,
      base_color_map = true
    }
  }
}
function TerrainProps:GetTerrainPreview()
  return GetTerrainTexturePreview(self.TerrainName)
end
function TerrainProps:GetTerrainIndex()
  return GetTerrainTextureIndex(self.TerrainName)
end
DefineClass.TestCombatFilter = {
  __parents = {"GedFilter"},
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "ShowInCheats",
      name = "Shown In Cheats",
      help = "Filters depending if shown in cheats or not",
      editor = "choice",
      default = "",
      items = function(self)
        return {
          "",
          "true",
          "false"
        }
      end
    }
  }
}
function TestCombatFilter:FilterObject(obj)
  if self.ShowInCheats ~= "" and obj.show_in_cheats ~= (self.ShowInCheats == "true") then
    return false
  end
  return true
end
DefineClass.TextStyle = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Text",
      id = "TextFont",
      name = "Font",
      editor = "text",
      default = T(202962508484, "droid, 12"),
      translate = true
    },
    {
      category = "Text",
      id = "TextColor",
      name = "Color",
      editor = "color",
      default = 4280295456
    },
    {
      category = "Text",
      id = "RolloverTextColor",
      name = "Rollover color",
      editor = "color",
      default = 4278190080
    },
    {
      category = "Text",
      id = "DisabledTextColor",
      name = "Disabled color",
      editor = "color",
      default = 2149589024
    },
    {
      category = "Text",
      id = "DisabledRolloverTextColor",
      name = "Disabled rollover color",
      editor = "color",
      default = 2147483648
    },
    {
      category = "Text",
      id = "ShadowType",
      name = "Shadow type",
      editor = "choice",
      default = "shadow",
      items = function(self)
        return {
          "shadow",
          "extrude",
          "outline",
          "glow"
        }
      end
    },
    {
      category = "Text",
      id = "ShadowSize",
      name = "Shadow size",
      editor = "number",
      default = 0
    },
    {
      category = "Text",
      id = "ShadowColor",
      name = "Shadow color",
      editor = "color",
      default = 805306368
    },
    {
      category = "Text",
      id = "ShadowDir",
      name = "Shadow dir",
      editor = "point",
      default = point(1, 1)
    },
    {
      id = "DarkMode",
      editor = "preset_id",
      default = false,
      preset_class = "TextStyle"
    },
    {
      category = "Text",
      id = "DisabledShadowColor",
      name = "Disabled shadow color",
      editor = "color",
      default = 805306368
    }
  },
  HasSortKey = true,
  GlobalMap = "TextStyles",
  EditorMenubarName = "Text styles",
  EditorShortcut = "Ctrl-Alt-T",
  EditorIcon = "CommonAssets/UI/Icons/detail list view.png",
  EditorMenubar = "Editors.UI",
  EditorPreview = Untranslated("<Preview>")
}
DefineModItemPreset("TextStyle", {EditorName = "Text Style", EditorSubmenu = "Assets"})
function TextStyle:GetFontIdHeightBaseline(scale)
  local cache = TextStyleCache[self.id]
  if not cache then
    cache = {}
    TextStyleCache[self.id] = cache
  end
  scale = scale or 1000
  if cache[scale] then
    return unpack_params(cache[scale])
  end
  local font = _InternalTranslate(self.TextFont) or _InternalTranslate(TextStyle.TextFont)
  font = font:gsub("%d+", function(size)
    return Max(MulDivRound(tonumber(size) or 1, scale, 1000), 1)
  end)
  font = GetProjectConvertedFont(font)
  if g_FontReplaceMap then
    local font_name = string.match(font, "([^,]+),")
    if font_name then
      if g_FontReplaceMap[font_name] then
        font_name = g_FontReplaceMap[font_name]
        font = font:gsub("[^,]+,", font_name .. ",")
      else
        for replace, with in pairs(g_FontReplaceMap) do
          if string.find(replace, font_name) then
            font_name = g_FontReplaceMap[replace]
            font = font:gsub("[^,]+,", font_name .. ",")
            break
          end
        end
      end
    end
  end
  local id = UIL.GetFontID(font)
  if not id or id < 0 then
    print("once", "[WARNING] Invalid font", font, "in text style", self.id)
    return -1, 0, 0
  end
  local _, height = UIL.MeasureText("AQj", id)
  local baseline = height * 8 / 10
  cache[scale] = {
    id,
    height,
    baseline
  }
  return id, height, baseline
end
function TextStyle:GetPreview()
  return string.format("<style %s><%s></style>", self.id, _InternalTranslate(self.TextFont, nil, false))
end
TextStyleCache = {}
function ClearTextStyleCache()
  TextStyleCache = {}
end
OnMsg.EngineOptionsSaved = ClearTextStyleCache
OnMsg.ClassesBuilt = ClearTextStyleCache
OnMsg.DataLoaded = ClearTextStyleCache
OnMsg.DataReload = ClearTextStyleCache
function LoadTextStyles()
  local old_text_styles = Presets.TextStyle
  Presets.TextStyle = {}
  TextStyles = {}
  LoadPresets("CommonLua/Data/TextStyle.lua")
  ForEachLib("Data/TextStyle.lua", function(lib, path)
    LoadPresets(path)
  end)
  LoadPresets("Data/TextStyle.lua")
  for _, dlc_folder in ipairs(DlcFolders or empty_table) do
    LoadPresets(dlc_folder .. "/Presets/TextStyle.lua")
  end
  TextStyle:SortPresets()
  for _, group in ipairs(Presets.TextStyle) do
    for _, preset in ipairs(group) do
      preset:PostLoad()
    end
  end
  if Platform.developer and not Platform.ged then
    LoadCollapsedPresetGroups()
  end
  GedRebindRoot(old_text_styles, Presets.TextStyle)
end
if FirstLoad or ReloadForDlc then
  OnMsg.ClassesBuilt = LoadTextStyles
  OnMsg.DataLoaded = LoadTextStyles
end
