DefineClass.AmmoProperties = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Caliber",
      id = "Caliber",
      editor = "combo",
      default = false,
      template = true,
      items = function(self)
        return PresetGroupCombo("Caliber", "Default")
      end
    },
    {
      category = "Caliber",
      id = "MaxStacks",
      name = "Max Stacks",
      help = "Ammo can stack up to that number.",
      editor = "number",
      default = 10,
      template = true,
      slider = true,
      min = 1,
      max = 10000
    },
    {
      id = "Modifications",
      editor = "nested_list",
      default = false,
      template = true,
      base_class = "CaliberModification",
      inclusive = true
    },
    {
      category = "Combat",
      id = "AppliedEffects",
      name = "Applied Effects",
      editor = "preset_id_list",
      default = {},
      template = true,
      preset_class = "CharacterEffectCompositeDef",
      preset_group = "Default",
      item_default = ""
    }
  }
}
DefineClass.ArmorProperties = {
  __parents = {
    "ItemWithCondition"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Slot",
      editor = "combo",
      default = "Torso",
      template = true,
      items = function(self)
        return {
          "Head",
          "Torso",
          "Legs"
        }
      end
    },
    {
      category = "Combat",
      id = "PenetrationClass",
      editor = "number",
      default = 1,
      template = true,
      name = function(self)
        return "Penetration Class: " .. (PenetrationClassIds[self.PenetrationClass] or "")
      end,
      slider = true,
      min = 1,
      max = 5,
      modifiable = true
    },
    {
      category = "Combat",
      id = "DamageReduction",
      name = "Damage Reduction (Base)",
      help = "How much damage the armor absorbs when the attack lands in an area covered by the armor.",
      editor = "number",
      default = 10,
      template = true,
      scale = "%",
      slider = true,
      min = 0,
      max = 100
    },
    {
      category = "Combat",
      id = "AdditionalReduction",
      name = "Damage Reduction (Additional)",
      help = "Additional damage reduction applied when the effective Penetration Class of the attack is lower than the Penetration Class of the armor protecting the hit body part.",
      editor = "number",
      default = 10,
      template = true,
      scale = "%",
      slider = true,
      min = 0,
      max = 100
    },
    {
      category = "Combat",
      id = "ProtectedBodyParts",
      name = "Protected Body Parts",
      editor = "set",
      default = false,
      template = true,
      items = function(self)
        return PresetGroupCombo("TargetBodyPart", "Default")
      end
    },
    {
      category = "Combat",
      id = "Camouflage",
      editor = "bool",
      default = false,
      template = true
    }
  }
}
DefineClass.CapacityItemProperties = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "MaxCapacity",
      name = "Max Capacity",
      editor = "number",
      default = 1000,
      template = true,
      min = 0,
      max = 10000
    },
    {
      id = "capacity",
      editor = "number",
      default = false,
      no_edit = true,
      template = true,
      min = 0,
      max = 10000
    },
    {
      id = "deplete_progress",
      editor = "number",
      default = 0,
      no_edit = true,
      template = true,
      min = 0,
      max = 10000
    },
    {
      id = "Deplete",
      editor = "func",
      default = function(self, amount, holder)
        self.capacity = self.capacity or self.MaxCapacity
        AddScaledProgress(self, "deplete_progress", "capacity", -amount)
        if self.capacity == 0 then
          local container_slot_name = GetContainerInventorySlotName(holder)
          local item = holder:RemoveItem(container_slot_name, self)
          if item then
            DoneObject(item)
            return true
          end
        end
      end,
      dont_save = true,
      no_edit = true,
      params = "self, amount, holder"
    },
    {
      id = "IsDepleted",
      editor = "func",
      default = function(self)
        return (self.capacity or self.MaxCapacity) <= 0
      end,
      dont_save = true,
      no_edit = true
    }
  }
}
DefineClass.ExplosiveProperties = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Explosion",
      id = "CenterUnitDamageMod",
      name = "Unit Damage Modifier (Center)",
      help = "modifier applied to damage when damaging units in the central tile of the explosion",
      editor = "number",
      default = 100,
      template = true,
      scale = "%",
      min = 0,
      max = 500
    },
    {
      category = "Explosion",
      id = "CenterObjDamageMod",
      name = "Object Damage Modifier (Center)",
      help = "modifier applied to damage when damaging objects in the central tile of the explosion",
      editor = "number",
      default = 100,
      template = true,
      scale = "%",
      min = 0,
      max = 500
    },
    {
      category = "Explosion",
      id = "CenterAppliedEffects",
      name = "Applied Effects (Center)",
      help = "status effects applied in the central tile of the explosion",
      editor = "preset_id_list",
      default = {},
      template = true,
      preset_class = "CharacterEffectCompositeDef",
      preset_group = "Default",
      item_default = ""
    },
    {
      category = "Explosion",
      id = "AreaOfEffect",
      name = "Area of Effect",
      help = "the blast range (radius) in number of tiles",
      editor = "number",
      default = 3,
      template = true,
      min = 0,
      max = 20,
      modifiable = true
    },
    {
      category = "Explosion",
      id = "CenterAreaOfEffect",
      name = "Central Area of Effect",
      help = "the central blast area radius in number of tiles",
      editor = "number",
      default = 1,
      template = true,
      min = 1,
      max = 20,
      modifiable = true
    },
    {
      category = "Explosion",
      id = "AreaUnitDamageMod",
      name = "Unit Damage Modifier (Area)",
      help = "modifier applied to damage when damaging units outside the central tile of the explosion",
      editor = "number",
      default = 100,
      template = true,
      scale = "%",
      min = 0,
      max = 500
    },
    {
      category = "Explosion",
      id = "AreaObjDamageMod",
      name = "Object Damage Modifier (Area)",
      help = "modifier applied to damage when damaging objects outside the central tile of the explosion",
      editor = "number",
      default = 100,
      template = true,
      scale = "%",
      min = 0,
      max = 500,
      modifiable = true
    },
    {
      category = "Explosion",
      id = "AreaAppliedEffects",
      name = "Applied Effects (Area)",
      help = "status effects applied outside the central tile of the explosion",
      editor = "preset_id_list",
      default = {},
      template = true,
      preset_class = "CharacterEffectCompositeDef",
      preset_group = "Default",
      item_default = ""
    },
    {
      category = "Explosion",
      id = "PenetrationClass",
      editor = "number",
      default = 5,
      template = true,
      name = function(self)
        return "Penetration Class: " .. (PenetrationClassIds[self.PenetrationClass] or "")
      end,
      slider = true,
      min = 1,
      max = 5,
      modifiable = true
    },
    {
      category = "Explosion",
      id = "coneShaped",
      name = "Cone Shaped",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "Explosion",
      id = "coneAngle",
      name = "Cone Angle",
      help = "The angle of the bigger cone arc",
      editor = "number",
      default = 30,
      no_edit = function(self)
        return not self.coneShaped
      end,
      template = true,
      min = 1,
      max = 360
    },
    {
      category = "Explosion",
      id = "BurnGround",
      editor = "bool",
      default = true,
      template = true
    },
    {
      category = "Explosion",
      id = "DeathType",
      editor = "choice",
      default = "Normal",
      template = true,
      items = function(self)
        return {"Normal", "BlowUp"}
      end
    },
    {
      id = "dbg_explosion_buttons",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Set Debug Explosion Source",
          func = "DbgSetExplosionType"
        }
      },
      template = true
    }
  }
}
DefineClass.FirearmProperties = {
  __parents = {
    "ItemWithCondition"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Caliber",
      id = "Caliber",
      editor = "combo",
      default = false,
      template = true,
      items = function(self)
        return PresetGroupCombo("Caliber", "Default")
      end
    },
    {
      category = "General",
      id = "btnAddAmmo",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Add Ammo To Current Unit",
          func = "UIPlaceInInventoryAmmo"
        }
      },
      template = true
    },
    {
      category = "Caliber",
      id = "Damage",
      help = "Damage of the firearm",
      editor = "number",
      default = 0,
      template = true,
      min = 0,
      max = 1000,
      modifiable = true
    },
    {
      category = "Caliber",
      id = "ObjDamageMod",
      name = "Objects damage modifier",
      help = "Multiplicative damage modifier against objects (non-units)",
      editor = "number",
      default = 100,
      template = true,
      scale = "%",
      min = 0,
      max = 1000,
      modifiable = true
    },
    {
      category = "Caliber",
      id = "AimAccuracy",
      name = "Aim Accuracy",
      help = "Base chance to hit increase per aim action",
      editor = "number",
      default = 2,
      template = true,
      scale = "%",
      min = 1,
      modifiable = true
    },
    {
      category = "Caliber",
      id = "CritChance",
      name = "Crit Chance",
      help = "Base chance to cause a critical hit which deals more damage.",
      editor = "number",
      default = 0,
      template = true,
      scale = "%",
      slider = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Caliber",
      id = "CritChanceScaled",
      name = "Crit Chance (Scaled)",
      help = "Additional chance to cause a critical hit (scaled by level, specified number is at merc level 10)",
      editor = "number",
      default = 10,
      template = true,
      scale = "%",
      slider = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Caliber",
      id = "MagazineSize",
      name = "Magazine Size",
      help = "Number of bullets in a single clip",
      editor = "number",
      default = 1,
      template = true,
      min = 1,
      max = 1000,
      modifiable = true
    },
    {
      category = "Caliber",
      id = "PenetrationClass",
      editor = "number",
      default = 1,
      template = true,
      name = function(self)
        return "Penetration Class: " .. (PenetrationClassIds[self.PenetrationClass] or "")
      end,
      slider = true,
      min = 1,
      max = 5,
      modifiable = true
    },
    {
      category = "Caliber",
      id = "IgnoreCoverReduction",
      name = "Ignore Cover Reduction",
      help = "If > 0 attacks with this weapon will ignore the damage reduction that would normally apply for targets in cover.",
      editor = "number",
      default = 0,
      template = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Caliber",
      id = "WeaponRange",
      name = "Range",
      help = "Range at which the penalty of the gun is 100.",
      editor = "number",
      default = 20,
      template = true,
      slider = true,
      min = 1,
      max = 200,
      modifiable = true
    },
    {
      category = "Caliber",
      id = "PointBlankRange",
      name = "Point Blank Range",
      help = "attacks get bonus CTH in point-blank range",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "Caliber",
      id = "OverwatchAngle",
      name = "Overwatch Angle",
      help = "overwatch area cone angle",
      editor = "number",
      default = 2400,
      template = true,
      no_edit = function(self)
        return self.PreparedAttackType ~= "Overwatch" and self.PreparedAttackType ~= "Both" and self.PreparedAttackType ~= "Machine Gun"
      end,
      scale = "deg",
      slider = true,
      min = 1,
      max = 5400,
      modifiable = true
    },
    {
      category = "Caliber",
      id = "BuckshotConeAngle",
      name = "Buckshot Cone Angle",
      editor = "number",
      default = 1600,
      template = true,
      no_edit = function(self)
        return not table.find(self.AvailableAttacks, "Buckshot")
      end,
      scale = "deg",
      min = 60,
      max = 7200,
      modifiable = true
    },
    {
      category = "Caliber",
      id = "BuckshotFalloffDamage",
      name = "Buckshot Falloff Damage",
      help = "what percent of nominal damage is the attack dealing at max range (cone length)",
      editor = "number",
      default = 25,
      template = true,
      no_edit = function(self)
        return not table.find(self.AvailableAttacks, "Buckshot")
      end,
      scale = "%",
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Caliber",
      id = "BuckshotFalloffStart",
      name = "Buckshot Falloff Start",
      help = "at what percent of the max distance (cone length) does the damage falloff start",
      editor = "number",
      default = 50,
      template = true,
      no_edit = function(self)
        return not table.find(self.AvailableAttacks, "Buckshot")
      end,
      scale = "%",
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Caliber",
      id = "Noise",
      name = "Noise Range",
      help = "Range (in tiles) in which the weapon alerts unaware enemies when firing.",
      editor = "number",
      default = 20,
      template = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Caliber",
      id = "RangePenalty",
      name = "Range Penalty",
      editor = "accuracy_chart",
      default = "",
      dont_save = true,
      template = true
    },
    {
      category = "General",
      id = "HandSlot",
      help = "One-haneded or two-handed weapon.",
      editor = "combo",
      default = "OneHanded",
      template = true,
      items = function(self)
        return {"OneHanded", "TwoHanded"}
      end
    },
    {
      category = "Body & Components",
      id = "Entity",
      editor = "combo",
      default = false,
      template = true,
      items = function(self)
        return GetWeaponEntities
      end
    },
    {
      category = "Body & Components",
      id = "fxClass",
      name = "FX Class",
      help = "use to override the default fx class of this weapon",
      editor = "combo",
      default = "",
      template = true,
      items = function(self)
        return ItemTemplatesCombo("FirearmProperties")
      end
    },
    {
      category = "Body & Components",
      id = "ComponentSlots",
      editor = "nested_list",
      default = false,
      template = true,
      base_class = "WeaponComponentSlot",
      inclusive = true
    },
    {
      category = "Body & Components",
      id = "Color",
      editor = "combo",
      default = "Olive",
      template = true,
      items = function(self)
        return Presets.WeaponColor.Default
      end
    },
    {
      category = "Body & Components",
      id = "BaseDifficulty",
      help = "Base difficulty value compared against the \"Mechanical\" skill.",
      editor = "number",
      default = false,
      template = true,
      min = 0,
      max = 10000000,
      modifiable = true
    },
    {
      category = "Body & Components",
      id = "HolsterSlot",
      help = "By default Two Handed weapons go on shoulders, One Handed go to legs",
      editor = "combo",
      default = "",
      template = true,
      items = function(self)
        return {
          "",
          "Shoulder",
          "Leg"
        }
      end
    },
    {
      category = "Body & Components",
      id = "ModifyRightHandGrip",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "General",
      id = "PreparedAttackType",
      name = "Prepared Attack Type",
      editor = "choice",
      default = "Overwatch",
      template = true,
      items = function(self)
        return {
          "Overwatch",
          "Pin Down",
          "None",
          "Both",
          "Machine Gun"
        }
      end
    },
    {
      category = "General",
      id = "AvailableAttacks",
      name = "Available Attacks",
      editor = "preset_id_list",
      default = {},
      template = true,
      preset_class = "CombatAction",
      preset_group = "WeaponAttacks",
      item_default = ""
    },
    {
      category = "ActionPoints",
      id = "ShootAP",
      name = "Shoot",
      help = "Action points needed to shoot a single shot",
      editor = "number",
      default = 1000,
      template = true,
      scale = "AP",
      min = 1000,
      max = 50000,
      modifiable = true
    },
    {
      category = "ActionPoints",
      id = "ReloadAP",
      name = "Reload",
      help = "Action points needed to reload the gun",
      editor = "number",
      default = 1000,
      template = true,
      scale = "AP",
      min = 1000,
      max = 50000,
      modifiable = true
    },
    {
      category = "ActionPoints",
      id = "MaxAimActions",
      name = "Max Aim Actions",
      help = "Max number of aim actions allowed",
      editor = "number",
      default = 3,
      min = 0,
      max = 5,
      modifiable = true
    },
    {
      category = "Debug",
      id = "SetRange",
      name = "Range",
      editor = "number",
      default = 10,
      dont_save = true,
      template = true,
      slider = true,
      min = 0,
      max = 50
    },
    {
      category = "Debug",
      id = "DPS",
      editor = "number",
      default = false,
      dont_save = true,
      read_only = true,
      template = true,
      min = 0,
      max = 1000
    }
  }
}
function FirearmProperties:GetDPS()
  return self:GetProperty("Damage") * Max(0, GetRangeAccuracy(self, self:GetProperty("SetRange") * const.SlabSizeX)) / 100
end
DefineClass.GrenadeProperties = {
  __parents = {
    "ItemWithCondition",
    "MishapProperties",
    "ExplosiveProperties"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Combat",
      id = "BaseDamage",
      name = "Base Damage",
      editor = "number",
      default = 20,
      template = true,
      min = 0,
      max = 200
    },
    {
      category = "Combat",
      id = "Scatter",
      help = "area in which the grenade may scatter defined as a radius in tiles.",
      editor = "number",
      default = 3,
      template = true,
      min = 0,
      max = 20
    },
    {
      category = "Combat",
      id = "AttackAP",
      name = "Attack AP",
      help = "AP to throw the greanade",
      editor = "number",
      default = 6000,
      template = true,
      scale = "AP",
      step = 1000,
      slider = true,
      min = 1000,
      max = 15000
    },
    {
      category = "Combat",
      id = "BaseRange",
      name = "Throw Range (Min)",
      help = "Number of tiles that this grenade can be thrown by a unit with 0 Strength.",
      editor = "number",
      default = 5,
      template = true,
      min = -10,
      max = 30
    },
    {
      category = "Combat",
      id = "ThrowMaxRange",
      name = "Throw Range (Max)",
      help = "Number of tiles that this grenade can be thrown by a unit with 100 Strength.",
      editor = "number",
      default = 15,
      template = true,
      min = -10,
      max = 30
    },
    {
      category = "Combat",
      id = "CanBounce",
      editor = "bool",
      default = true,
      template = true
    },
    {
      category = "Combat",
      id = "InaccurateMinOffset",
      name = "Min Offset (Inaccurate Throw)",
      help = "Minimum distance to the target point for inaccurate throws, at 10 tiles",
      editor = "number",
      default = 1000,
      template = true,
      scale = "m",
      min = 1,
      max = 20000
    },
    {
      category = "Combat",
      id = "InaccurateMaxOffset",
      name = "Max Offset (Inaccurate Throw)",
      help = "Maximum distance to the target point for inaccurate throws, at 10 tiles",
      editor = "number",
      default = 5000,
      template = true,
      scale = "m",
      min = 1,
      max = 20000
    },
    {
      category = "Combat",
      id = "IgnoreCoverReduction",
      name = "Ignore Cover Reduction",
      help = "If > 0 attacks with this weapon will ignore the damage reduction that would normally apply for targets in cover.",
      editor = "number",
      default = 0,
      template = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Combat",
      id = "Noise",
      name = "Noise",
      help = "Range (in tiles) in which the explosion alerts unaware enemies.",
      editor = "number",
      default = 20,
      template = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Combat",
      id = "ThrowNoise",
      name = "Throw Noise",
      help = "Range (in tiles) in which items that do not explode immediately can still alert enemies when they land.",
      editor = "number",
      default = 3,
      template = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Combat",
      id = "aoeType",
      name = "AOE Type",
      help = "additional effect that happens after the explosion (optional)",
      editor = "choice",
      default = "none",
      template = true,
      items = function(self)
        return {
          "none",
          "fire",
          "smoke",
          "teargas",
          "toxicgas"
        }
      end
    },
    {
      category = "General",
      id = "Entity",
      editor = "choice",
      default = false,
      read_only = true,
      no_edit = true,
      template = true,
      items = function(self)
        return ClassDescendantsCombo("GrenadeVisual")
      end
    },
    {
      category = "General",
      id = "ActionIcon",
      name = "Throw Action Icon",
      editor = "ui_image",
      default = false,
      template = true
    }
  }
}
DefineClass.HeavyWeaponProperties = {
  __parents = {
    "ItemWithCondition",
    "MishapProperties"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Caliber",
      id = "Caliber",
      editor = "combo",
      default = false,
      template = true,
      items = function(self)
        return PresetGroupCombo("Caliber", "Default")
      end
    },
    {
      category = "Combat",
      id = "AttackAP",
      name = "Attack AP",
      help = "AP to throw the greanade",
      editor = "number",
      default = 6000,
      template = true,
      scale = "AP",
      step = 1000,
      slider = true,
      min = 1000,
      max = 15000
    },
    {
      category = "Combat",
      id = "BombardRadius",
      help = "defines the radius (in tiles) of the zone where the bombard ordnance can fall",
      editor = "number",
      default = 4,
      template = true,
      min = 0,
      max = 10,
      modifiable = true
    },
    {
      category = "Body & Components",
      id = "ComponentSlots",
      editor = "nested_list",
      default = false,
      template = true,
      base_class = "WeaponComponentSlot",
      inclusive = true
    },
    {
      category = "Body & Components",
      id = "Entity",
      editor = "combo",
      default = false,
      template = true,
      items = function(self)
        return GetWeaponEntities
      end
    }
  }
}
DefineClass.InventoryItemProperties = {
  __parents = {
    "ItemWithCondition"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "General",
      id = "Icon",
      editor = "ui_image",
      default = "",
      template = true,
      image_preview_size = 400
    },
    {
      category = "General",
      id = "SubIcon",
      help = "A small icon on the bootom left side of the item's icon",
      editor = "ui_image",
      default = "",
      template = true,
      image_preview_size = 30
    },
    {
      category = "General",
      id = "ItemType",
      editor = "preset_id",
      default = false,
      template = true,
      preset_class = "WeaponType"
    },
    {
      category = "General",
      id = "DisplayName",
      name = "Display Name",
      editor = "text",
      default = false,
      template = true,
      translate = true
    },
    {
      category = "General",
      id = "DisplayNamePlural",
      name = "Display Name Plural",
      editor = "text",
      default = false,
      template = true,
      translate = true
    },
    {
      category = "General",
      id = "colorStyle",
      name = "Color Style",
      editor = "preset_id",
      default = false,
      template = true,
      preset_class = "TextStyle"
    },
    {
      category = "General",
      id = "Description",
      editor = "text",
      default = false,
      template = true,
      translate = true,
      lines = 1,
      max_lines = 3
    },
    {
      category = "General",
      id = "AdditionalHint",
      name = "Additional Hint",
      help = "Additional keywords text to add to item's rollover hint. Added after the autogenerated keyswors for weapons.",
      editor = "text",
      default = false,
      template = true,
      translate = true,
      lines = 1,
      max_lines = 10
    },
    {
      category = "General",
      id = "LargeItem",
      name = "Large",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "General",
      id = "Cumbersome",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "General",
      id = "UnitStat",
      name = "Unit Stat",
      help = "Unit Properties stat.",
      editor = "choice",
      default = false,
      template = true,
      items = function(self)
        return GetUnitStatsCombo()
      end
    },
    {
      category = "General",
      id = "is_valuable",
      name = "Valuable Item",
      help = "Is valuable item.",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "General",
      id = "btnAddItem",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Add To Current Unit",
          func = "UIPlaceInInventory"
        }
      },
      template = true
    },
    {
      category = "General",
      id = "Cost",
      help = "How much this item costs to buy in $",
      editor = "number",
      default = 1000,
      template = true,
      min = 0,
      max = 10000000,
      modifiable = true
    },
    {
      category = "General",
      id = "locked",
      name = "Locked",
      help = "Locked items cannot be moved from their slot. They also disappear when the bearer dies.",
      editor = "bool",
      default = false,
      template = true
    },
    {
      id = "owner",
      name = "Owner",
      help = "The item owner if any.",
      editor = "text",
      default = false
    },
    {
      id = "extra_tag",
      help = "Extra data to identify unique items. Note that for stacking items this will be wiped when they're stacked.",
      editor = "text",
      default = false
    },
    {
      id = "base_drop_chance",
      editor = "number",
      default = 5,
      read_only = true,
      no_edit = true
    },
    {
      id = "drop_chance",
      editor = "number",
      default = 0,
      read_only = true,
      no_edit = true
    },
    {
      id = "guaranteed_drop",
      editor = "bool",
      default = false,
      read_only = true,
      no_edit = true
    }
  }
}
function InventoryItemProperties:GetColoredName(plural)
  local style = TextStyles[self.colorStyle]
  if style then
    local r, g, b = GetRGB(style.TextColor)
    local colorTag = string.format("<color %i %i %i>", r, g, b)
    return T({
      236471449642,
      "<colorTag><name></color>",
      colorTag = colorTag,
      name = plural and self.DisplayNamePlural or self.DisplayName
    })
  else
    return plural and self.DisplayNamePlural or self.DisplayName
  end
end
function InventoryItemProperties:GetEquipCost()
  return const["Action Point Costs"].EquipItem
end
function InventoryItemProperties:GetUIWidth()
  return self.LargeItem and 2 or 1
end
function InventoryItemProperties:GetUIHeight()
  return 1
end
function InventoryItemProperties:GetRolloverType()
  return self.ItemType
end
DefineClass.ItemUpgradeProperties = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Slot",
      editor = "combo",
      default = "Modification",
      template = true,
      items = function(self)
        return {
          "Underslung",
          "Muzzle",
          "Sights",
          "Magazine",
          "Modification"
        }
      end
    }
  }
}
DefineClass.ItemWithCondition = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Condition",
      id = "Condition",
      help = "The overall condition of the item which is lowered when the item is fired/hit",
      editor = "number",
      default = 100,
      template = true,
      min = 0,
      max = 10000
    },
    {
      category = "Condition",
      id = "RepairCost",
      name = "Repair Cost",
      help = "How long it takes to repair the item using Mechanical skill. Each hour a mechanic contributes his/her skill towards repair. To increase Condition by 1 point the merc has to contribute this much points.",
      editor = "number",
      default = 80,
      template = true,
      min = 0,
      max = 1000
    },
    {
      category = "Condition",
      id = "Repairable",
      name = "Repairable",
      help = "Whether the item can be repaired",
      editor = "bool",
      default = true,
      template = true
    },
    {
      category = "Condition",
      id = "Reliability",
      help = "For guns. Percentage. How fast or slowly condition is lost when the gun is fired. High percentage means that the gun is more reliable.",
      editor = "number",
      default = 40,
      template = true,
      no_edit = function(self)
        local class = g_Classes[self.object_class or false]
        return not IsKindOf(class, "FirearmBase")
      end,
      slider = true,
      min = 0,
      max = 98,
      modifiable = true
    },
    {
      category = "Condition",
      id = "Degradation",
      help = "For armors. When the armor is hit how much of the damage is transfered as condition loss.",
      editor = "number",
      default = 50,
      template = true,
      no_edit = function(self)
        local class = g_Classes[self.object_class or false]
        return not IsKindOf(class, "Armor")
      end,
      slider = true,
      min = 0,
      max = 100
    },
    {
      category = "Condition",
      id = "repair_progress",
      editor = "number",
      default = 0,
      no_edit = true,
      template = true
    },
    {
      category = "Condition",
      id = "ScrapParts",
      name = "Scrap Parts",
      help = "The number for Parts that are given to the player when its scraped",
      editor = "number",
      default = 0,
      template = true,
      min = 0,
      max = 1000
    }
  }
}
function ItemWithCondition:GetScrapParts()
  return self.ScrapParts
end
function ItemWithCondition:AmountOfScrapPartsFromItem()
  local parts = self:GetScrapParts()
  if self.Condition and self.Condition < 50 then
    parts = parts / 2
  end
  return parts
end
DefineClass.MeleeWeaponProperties = {
  __parents = {
    "ItemWithCondition"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Combat",
      id = "BaseChanceToHit",
      name = "Base Chance To Hit",
      help = "Multiplies chance to hit finaly. Used to define differently accurate weapon types.",
      editor = "number",
      default = 90,
      template = true,
      slider = true,
      min = 0,
      max = 100
    },
    {
      category = "Combat",
      id = "CritChance",
      name = "Crit Chance",
      help = "Base chance to cause a critical hit which deals more damage.",
      editor = "number",
      default = 0,
      template = true,
      scale = "%",
      slider = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Combat",
      id = "CritChanceScaled",
      name = "Crit Chance (Scaled)",
      help = "Additional chance to cause a critical hit (scaled by level, specified number is at merc level 10)",
      editor = "number",
      default = 10,
      template = true,
      scale = "%",
      slider = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Combat",
      id = "BaseDamage",
      name = "Base Damage",
      help = "Melee weapon damage scales based on damage. This property defines the base cost.",
      editor = "number",
      default = 10,
      template = true,
      min = 0,
      max = 200
    },
    {
      category = "Combat",
      id = "AimAccuracy",
      name = "Aim Accuracy",
      help = "Base chance to hit increase per aim action",
      editor = "number",
      default = 2,
      template = true,
      scale = "%",
      min = 1,
      modifiable = true
    },
    {
      category = "Combat",
      id = "PenetrationClass",
      editor = "number",
      default = 1,
      template = true,
      name = function(self)
        return "Penetration Class: " .. (PenetrationClassIds[self.PenetrationClass] or "")
      end,
      slider = true,
      min = 1,
      max = 5,
      modifiable = true
    },
    {
      category = "Combat",
      id = "DamageMultiplier",
      name = "Damage Multiplier",
      help = "In %. Strength stat is multiplied by this percentage when multiplying melee damage",
      editor = "number",
      default = 200,
      template = true,
      scale = "%",
      min = 0,
      max = 1000
    },
    {
      category = "Combat",
      id = "IgnoreCoverReduction",
      name = "Ignore Cover Reduction",
      help = "If > 0 attacks with this weapon will ignore the damage reduction that would normally apply for targets in cover.",
      editor = "number",
      default = 0,
      template = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Combat",
      id = "CanThrow",
      name = "Can Throw",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "Combat",
      id = "WeaponRange",
      name = "Range",
      help = "Range at which the penalty of the gun is 100.",
      editor = "number",
      default = 8,
      template = true,
      no_edit = function(self)
        return not self.CanThrow
      end,
      slider = true,
      min = 1,
      max = 20,
      modifiable = true
    },
    {
      category = "Combat",
      id = "Charge",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "Combat",
      id = "IsUnarmed",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "Action Points",
      id = "AttackAP",
      name = "Attack",
      help = "Action Points needed to make a basic attack.",
      editor = "number",
      default = 5000,
      template = true,
      scale = "AP",
      min = 0,
      max = 30000
    },
    {
      category = "Action Points",
      id = "MaxAimActions",
      name = "Max Aim Actions",
      help = "Max number of allowed aim actions.",
      editor = "number",
      default = 2,
      template = true,
      min = 0,
      max = 4
    },
    {
      category = "Melee Weapon",
      id = "Noise",
      help = "How much noise the weapon makes when attacking.",
      editor = "number",
      default = 100,
      template = true,
      min = 0,
      max = 1000
    },
    {
      category = "Melee Weapon",
      id = "NeckAttackType",
      editor = "choice",
      default = "bleed",
      template = true,
      items = function(self)
        return {
          "choke",
          "bleed",
          "lethal"
        }
      end
    },
    {
      category = "Body & Components",
      id = "Entity",
      editor = "combo",
      default = false,
      template = true,
      items = function(self)
        return GetWeaponEntities
      end
    },
    {
      category = "Body & Components",
      id = "fxClass",
      name = "FX Class",
      help = "use to override the default fx class of this weapon",
      editor = "combo",
      default = "",
      template = true,
      items = function(self)
        return ItemTemplatesCombo("MeleeWeaponProperties")
      end
    },
    {
      category = "Body & Components",
      id = "HolsterSlot",
      help = "By default Two Handed weapons go on shoulders, One Handed go to legs",
      editor = "combo",
      default = "",
      template = true,
      items = function(self)
        return {
          "",
          "Shoulder",
          "Leg"
        }
      end
    }
  }
}
DefineClass.MiscItemProperties = {
  __parents = {
    "ItemWithCondition"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Execution",
      id = "effect_moment",
      name = "Effect moment",
      editor = "choice",
      default = false,
      template = true,
      items = function(self)
        return InventoryItemEffectMoments
      end
    },
    {
      category = "Execution",
      id = "Effects",
      help = "Effects that are executed when consuming an item.",
      editor = "nested_list",
      default = false,
      template = true,
      base_class = "Effect"
    },
    {
      category = "Execution",
      id = "action_name",
      name = "Name",
      help = "Action name",
      editor = "text",
      default = false,
      template = true,
      translate = true
    },
    {
      category = "Execution",
      id = "destroy_item",
      name = "Destroy item",
      help = "Destroy item after execution.",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "Execution",
      id = "APCost",
      name = "AP Cost",
      help = "How much does the item cost to use while in combat.",
      editor = "number",
      default = 2,
      template = true
    }
  }
}
DefineClass.OrdnanceProperties = {
  __parents = {
    "ExplosiveProperties"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Caliber",
      id = "Caliber",
      editor = "combo",
      default = false,
      template = true,
      items = function(self)
        return PresetGroupCombo("Caliber", "Default")
      end
    },
    {
      category = "Caliber",
      id = "MaxStacks",
      name = "Max Stacks",
      help = "Ammo can stack up to that number.",
      editor = "number",
      default = 10,
      template = true,
      slider = true,
      min = 1,
      max = 10000
    },
    {
      category = "Combat",
      id = "BaseDamage",
      name = "Base Damage",
      editor = "number",
      default = 20,
      template = true,
      min = 0
    },
    {
      category = "Combat",
      id = "Noise",
      name = "Noise",
      help = "Range (in tiles) in which the explosion alerts unaware enemies.",
      editor = "number",
      default = 20,
      template = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Combat",
      id = "aoeType",
      name = "AOE Type",
      help = "additional effect that happens after the explosion (optional)",
      editor = "choice",
      default = "none",
      template = true,
      items = function(self)
        return {
          "none",
          "fire",
          "smoke",
          "teargas",
          "toxicgas"
        }
      end
    },
    {
      category = "Combat",
      id = "CanBounce",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "General",
      id = "Entity",
      editor = "choice",
      default = false,
      read_only = true,
      no_edit = true,
      template = true,
      items = function(self)
        return ClassDescendantsCombo("GrenadeVisual")
      end
    }
  }
}
DefineClass.QuestItemProperties = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef"
}
DefineClass.StatBoostItemProperties = {
  __parents = {
    "ItemWithCondition"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Stat boost item",
      id = "stat",
      name = "Stat",
      editor = "choice",
      default = false,
      template = true,
      items = function(self)
        return GetUnitStatsCombo
      end
    },
    {
      category = "Stat boost item",
      id = "boost",
      name = "Boost value",
      editor = "number",
      default = false,
      template = true
    }
  }
}
DefineClass.TransmutedItemProperties = {
  __parents = {
    "ItemWithCondition"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "OriginalItemId",
      editor = "preset_id",
      default = false,
      preset_class = "InventoryItemCompositeDef"
    },
    {
      id = "RevertCondition",
      editor = "combo",
      default = false,
      items = function(self)
        return {"attacks", "damage"}
      end
    },
    {
      id = "RevertConditionCounter",
      editor = "number",
      default = false
    }
  }
}
function TransmutedItemProperties:MakeTransmutation(fromitem)
  local new_item, prev_item
  if fromitem == "revert" then
    new_item = PlaceInventoryItem(self.OriginalItemId)
    prev_item = self
  else
    new_item = self
    prev_item = fromitem
  end
  new_item.Condition = prev_item.Condition
  return new_item, prev_item
end
