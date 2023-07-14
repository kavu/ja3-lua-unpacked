DefineClass.FloorSlabMaterials = {
  __parents = {
    "SlabMaterialsBase"
  },
  __generated_by_class = "ClassAsGroupPresetDef",
  properties = {
    {
      category = "Subvariants",
      id = "broken_t_subvariants",
      name = "Broken T Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_b_subvariants",
      name = "Broken B Subvariants",
      help = "Note that only walls have B subvariants. Floors do not.",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_r_subvariants",
      name = "Broken R Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_rb_subvariants",
      name = "Broken RB Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attaches_r_subvariants",
      name = "Broken Attaches R Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attaches_t_subvariants",
      name = "Broken Attaches T Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attaches_b_subvariants",
      name = "Broken Attaches B Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    }
  },
  group = "FloorSlabMaterials"
}
DefineModItemPreset("FloorSlabMaterials", {
  EditorName = "Floor material",
  EditorSubmenu = "Buildings"
})
DefineClass.RoofSlabMaterials = {
  __parents = {
    "SlabMaterialsBase"
  },
  __generated_by_class = "ClassAsGroupPresetDef",
  properties = {
    {
      id = "EntitySet",
      editor = "text",
      default = false
    },
    {
      id = "roof_additional_height",
      name = "Roof Additional Height",
      editor = "number",
      default = 0,
      scale = "m",
      slider = true,
      min = 0,
      max = 700
    },
    {
      category = "Subvariants",
      id = "broken_t_subvariants",
      name = "Broken T Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_b_subvariants",
      name = "Broken B Subvariants",
      help = "Note that only walls have B subvariants. Floors do not.",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_r_subvariants",
      name = "Broken R Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_rb_subvariants",
      name = "Broken RB Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_rt_subvariants",
      name = "Broken RT Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attaches_r_subvariants",
      name = "Broken Attaches R Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attaches_t_subvariants",
      name = "Broken Attaches T Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attaches_b_subvariants",
      name = "Broken Attaches B Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "eave_subvariants",
      name = "Eave Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attaches_eave_r_subvariants",
      name = "Broken Eave Attaches R Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "rake_subvariants",
      name = "Rake Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attaches_rake_t_subvariants",
      name = "Broken Rake Attaches T Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attaches_rake_b_subvariants",
      name = "Broken Rake Attaches B Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "ridge_subvariants",
      name = "Ridge Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attaches_ridge_r_subvariants",
      name = "Broken Ridge Attaches R Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "gable_subvariants",
      name = "Gable Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attaches_gable_r_subvariants",
      name = "Broken Gable Attaches R Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "rake_ridge_subvariants",
      name = "RakeRidge Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "rake_eave_subvariants",
      name = "RakeEave Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "rake_gable_subvariants",
      name = "RakeGable Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    }
  },
  group = "RoofSlabMaterials"
}
DefineModItemPreset("RoofSlabMaterials", {
  EditorName = "Roof material",
  EditorSubmenu = "Buildings"
})
DefineClass.ShelterSlabMaterials = {
  __parents = {
    "SlabMaterialsBase"
  },
  __generated_by_class = "ClassAsGroupPresetDef",
  group = "ShelterSlabMaterials"
}
DefineModItemPreset("ShelterSlabMaterials", {
  EditorName = "Shelter material",
  EditorSubmenu = "Buildings"
})
DefineClass.SlabIndoorMaterials = {
  __parents = {"SlabPreset"},
  __generated_by_class = "ClassAsGroupPresetDef",
  properties = {
    {
      category = "Subvariants",
      id = "subvariants",
      name = "Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "corner_subvariants",
      name = "Corner Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_t_subvariants",
      name = "Broken T Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_b_subvariants",
      name = "Broken B Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_r_subvariants",
      name = "Broken R Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attach_attaches_t_subvariants",
      name = "Broken Attach Attaches T Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attach_attaches_b_subvariants",
      name = "Broken Attach Attaches B Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attach_attaches_r_subvariants",
      name = "Broken Attach Attaches R Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      id = "display_name",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    }
  },
  group = "SlabIndoorMaterials"
}
DefineClass.SlabMaterials = {
  __parents = {
    "SlabMaterialsBase"
  },
  __generated_by_class = "ClassAsGroupPresetDef",
  properties = {
    {
      category = "Subvariants",
      id = "corner_subvariants",
      name = "Corner Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_t_subvariants",
      name = "Broken T Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_b_subvariants",
      name = "Broken B Subvariants",
      help = "Note that only walls have B subvariants. Floors do not.",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_r_subvariants",
      name = "Broken R Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_rb_subvariants",
      name = "Broken RB Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attaches_t_subvariants",
      name = "Broken Attaches T Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attaches_b_subvariants",
      name = "Broken Attaches B Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "broken_attaches_r_subvariants",
      name = "Broken Attaches R Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      id = "max_voxel_xy",
      name = "Max Voxel XY",
      help = "A room wall can only be this long when using this material.",
      editor = "number",
      default = -1,
      min = -1
    },
    {
      id = "max_voxel_height",
      name = "Max Voxel Height",
      help = "A room wall can only be this high when using this material.",
      editor = "number",
      default = -1,
      min = -1
    },
    {
      id = "max_voxel_depth",
      name = "Max Voxel Depth",
      help = "A room base can only be this high above ground when using this material.",
      editor = "number",
      default = -1,
      min = -1
    },
    {
      id = "max_voxel_area",
      name = "Max Voxel Area",
      help = "A room can only have an area as big or smaller than this when using this material.",
      editor = "number",
      default = -1,
      min = -1
    },
    {
      id = "foundation_requirement",
      name = "Foundation Requirement",
      help = "Determines how many rooms can stack on top of each other.",
      editor = "number",
      default = -1,
      min = -1
    },
    {
      id = "is_symmetric",
      name = "Is Symmetric",
      editor = "bool",
      default = false
    },
    {
      id = "is_small",
      name = "Is Small",
      editor = "bool",
      default = true
    }
  },
  group = "SlabMaterials"
}
DefineModItemPreset("SlabMaterials", {
  EditorName = "Slab material",
  EditorSubmenu = "Buildings"
})
DefineClass.SlabMaterialsBase = {
  __parents = {"SlabPreset"},
  __generated_by_class = "ClassAsGroupPresetDef",
  properties = {
    {
      id = "obj_material",
      name = "ObjMaterial",
      help = "Combat material",
      editor = "preset_id",
      default = false,
      no_edit = function(self)
        return g_Classes.ConstructionSite
      end,
      preset_class = "ObjMaterial"
    },
    {
      category = "Subvariants",
      id = "subvariants",
      name = "Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      category = "Subvariants",
      id = "damaged_subvariants",
      name = "Damaged Subvariants",
      editor = "nested_list",
      default = false,
      base_class = "SlabMaterialSubvariant",
      inclusive = true
    },
    {
      id = "repair_cost",
      name = "Repair Cost",
      help = "The repair cost per slab",
      editor = "nested_obj",
      default = false,
      no_edit = function()
        return not g_Classes.ConstructionCost
      end,
      base_class = "ConstructionCost",
      inclusive = true
    },
    {
      id = "repair_points",
      name = "Repair Points",
      help = "Repair work costs (40 sec = 1h)",
      editor = "number",
      default = 0,
      scale = "sec",
      min = -1
    },
    {
      id = "health",
      name = "Health",
      help = "Room max health is calculated on the base of it's slabs health",
      editor = "number",
      default = 0,
      scale = 1000
    },
    {
      id = "strength",
      name = "Material Strength",
      help = "When walls are on top of each other, the wall with most strength is the one visible.",
      editor = "number",
      default = -1,
      min = -1
    },
    {
      id = "display_name",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "mat_props",
      name = "Material Props",
      editor = "set",
      default = false,
      items = function(self)
        return const.SlabMaterialProps
      end
    },
    {
      id = "max_voxel_xy",
      name = "Max Voxel XY",
      help = "A room wall can only be this long when using this material.",
      editor = "number",
      default = 16,
      min = 1,
      max = 16
    },
    {
      id = "use_damaged",
      name = "Use Damaged Subvariants",
      help = "When destroyed will only replace ent with damaged subvariant;",
      editor = "bool",
      default = false
    },
    {
      id = "use_damaged_first_floor",
      name = "Use Damaged Subvariant For First Floor Only",
      help = "When destroyed will only replace ent with damaged subvariant, if on first floor, else behave as normal;",
      editor = "bool",
      default = false
    }
  },
  group = "SlabMaterialsBase"
}
DefineClass.SlabVariants = {
  __parents = {"SlabPreset"},
  __generated_by_class = "ClassAsGroupPresetDef",
  group = "SlabVariants"
}
DefineClass.StairsSlabMaterials = {
  __parents = {
    "SlabMaterialsBase"
  },
  __generated_by_class = "ClassAsGroupPresetDef",
  group = "StairsSlabMaterials"
}
DefineModItemPreset("StairsSlabMaterials", {
  EditorName = "Stairs material",
  EditorSubmenu = "Buildings"
})
