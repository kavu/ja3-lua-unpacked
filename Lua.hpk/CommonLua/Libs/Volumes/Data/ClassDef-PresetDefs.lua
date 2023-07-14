PlaceObj("ClassAsGroupPresetDef", {
  DefModItem = true,
  DefModItemName = "Floor material",
  DefModItemSubmenu = "Buildings",
  DefParentClassList = {
    "SlabMaterialsBase"
  },
  GroupPresetClass = "SlabPreset",
  id = "FloorSlabMaterials",
  save_in = "Libs/Volumes",
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_t_subvariants",
    "name",
    "Broken T Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_b_subvariants",
    "name",
    "Broken B Subvariants",
    "help",
    "Note that only walls have B subvariants. Floors do not.",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_r_subvariants",
    "name",
    "Broken R Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_rb_subvariants",
    "name",
    "Broken RB Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attaches_r_subvariants",
    "name",
    "Broken Attaches R Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attaches_t_subvariants",
    "name",
    "Broken Attaches T Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attaches_b_subvariants",
    "name",
    "Broken Attaches B Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  })
})
PlaceObj("ClassAsGroupPresetDef", {
  DefModItem = true,
  DefModItemName = "Roof material",
  DefModItemSubmenu = "Buildings",
  DefParentClassList = {
    "SlabMaterialsBase"
  },
  GroupPresetClass = "SlabPreset",
  group = "PresetDefs",
  id = "RoofSlabMaterials",
  save_in = "Libs/Volumes",
  PlaceObj("PropertyDefText", {
    "id",
    "EntitySet",
    "translate",
    false
  }),
  PlaceObj("PropertyDefNumber", {
    "id",
    "roof_additional_height",
    "name",
    "Roof Additional Height",
    "default",
    0,
    "scale",
    "m",
    "slider",
    true,
    "min",
    0,
    "max",
    700
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_t_subvariants",
    "name",
    "Broken T Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_b_subvariants",
    "name",
    "Broken B Subvariants",
    "help",
    "Note that only walls have B subvariants. Floors do not.",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_r_subvariants",
    "name",
    "Broken R Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_rb_subvariants",
    "name",
    "Broken RB Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_rt_subvariants",
    "name",
    "Broken RT Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attaches_r_subvariants",
    "name",
    "Broken Attaches R Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attaches_t_subvariants",
    "name",
    "Broken Attaches T Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attaches_b_subvariants",
    "name",
    "Broken Attaches B Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "eave_subvariants",
    "name",
    "Eave Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attaches_eave_r_subvariants",
    "name",
    "Broken Eave Attaches R Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "rake_subvariants",
    "name",
    "Rake Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attaches_rake_t_subvariants",
    "name",
    "Broken Rake Attaches T Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attaches_rake_b_subvariants",
    "name",
    "Broken Rake Attaches B Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "ridge_subvariants",
    "name",
    "Ridge Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attaches_ridge_r_subvariants",
    "name",
    "Broken Ridge Attaches R Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "gable_subvariants",
    "name",
    "Gable Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attaches_gable_r_subvariants",
    "name",
    "Broken Gable Attaches R Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "rake_ridge_subvariants",
    "name",
    "RakeRidge Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "rake_eave_subvariants",
    "name",
    "RakeEave Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "rake_gable_subvariants",
    "name",
    "RakeGable Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  })
})
PlaceObj("ClassAsGroupPresetDef", {
  DefModItem = true,
  DefModItemName = "Shelter material",
  DefModItemSubmenu = "Buildings",
  DefParentClassList = {
    "SlabMaterialsBase"
  },
  GroupPresetClass = "SlabPreset",
  group = "PresetDefs",
  id = "ShelterSlabMaterials",
  save_in = "Libs/Volumes"
})
PlaceObj("ClassAsGroupPresetDef", {
  GroupPresetClass = "SlabPreset",
  id = "SlabIndoorMaterials",
  save_in = "Libs/Volumes",
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "subvariants",
    "name",
    "Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "corner_subvariants",
    "name",
    "Corner Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_t_subvariants",
    "name",
    "Broken T Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_b_subvariants",
    "name",
    "Broken B Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_r_subvariants",
    "name",
    "Broken R Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attach_attaches_t_subvariants",
    "name",
    "Broken Attach Attaches T Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attach_attaches_b_subvariants",
    "name",
    "Broken Attach Attaches B Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attach_attaches_r_subvariants",
    "name",
    "Broken Attach Attaches R Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefText", {
    "id",
    "display_name",
    "name",
    "Display Name"
  })
})
PlaceObj("ClassAsGroupPresetDef", {
  DefModItem = true,
  DefModItemName = "Slab material",
  DefModItemSubmenu = "Buildings",
  DefParentClassList = {
    "SlabMaterialsBase"
  },
  GroupPresetClass = "SlabPreset",
  id = "SlabMaterials",
  save_in = "Libs/Volumes",
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "corner_subvariants",
    "name",
    "Corner Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_t_subvariants",
    "name",
    "Broken T Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_b_subvariants",
    "name",
    "Broken B Subvariants",
    "help",
    "Note that only walls have B subvariants. Floors do not.",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_r_subvariants",
    "name",
    "Broken R Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_rb_subvariants",
    "name",
    "Broken RB Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attaches_t_subvariants",
    "name",
    "Broken Attaches T Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attaches_b_subvariants",
    "name",
    "Broken Attaches B Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "broken_attaches_r_subvariants",
    "name",
    "Broken Attaches R Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNumber", {
    "id",
    "max_voxel_xy",
    "name",
    "Max Voxel XY",
    "help",
    "A room wall can only be this long when using this material.",
    "default",
    -1,
    "min",
    -1
  }),
  PlaceObj("PropertyDefNumber", {
    "id",
    "max_voxel_height",
    "name",
    "Max Voxel Height",
    "help",
    "A room wall can only be this high when using this material.",
    "default",
    -1,
    "min",
    -1
  }),
  PlaceObj("PropertyDefNumber", {
    "id",
    "max_voxel_depth",
    "name",
    "Max Voxel Depth",
    "help",
    "A room base can only be this high above ground when using this material.",
    "default",
    -1,
    "min",
    -1
  }),
  PlaceObj("PropertyDefNumber", {
    "id",
    "max_voxel_area",
    "name",
    "Max Voxel Area",
    "help",
    "A room can only have an area as big or smaller than this when using this material.",
    "default",
    -1,
    "min",
    -1
  }),
  PlaceObj("PropertyDefNumber", {
    "id",
    "foundation_requirement",
    "name",
    "Foundation Requirement",
    "help",
    "Determines how many rooms can stack on top of each other.",
    "default",
    -1,
    "min",
    -1
  }),
  PlaceObj("PropertyDefBool", {
    "id",
    "is_symmetric",
    "name",
    "Is Symmetric"
  }),
  PlaceObj("PropertyDefBool", {
    "id",
    "is_small",
    "name",
    "Is Small",
    "default",
    true
  })
})
PlaceObj("ClassAsGroupPresetDef", {
  GroupPresetClass = "SlabPreset",
  id = "SlabMaterialsBase",
  save_in = "Libs/Volumes",
  PlaceObj("PropertyDefPresetId", {
    "id",
    "obj_material",
    "name",
    "ObjMaterial",
    "help",
    "Combat material",
    "extra_code",
    "no_edit = function(self) return g_Classes.ConstructionSite end",
    "preset_class",
    "ObjMaterial"
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "subvariants",
    "name",
    "Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedList", {
    "category",
    "Subvariants",
    "id",
    "damaged_subvariants",
    "name",
    "Damaged Subvariants",
    "base_class",
    "SlabMaterialSubvariant",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNestedObj", {
    "id",
    "repair_cost",
    "name",
    "Repair Cost",
    "help",
    "The repair cost per slab",
    "extra_code",
    "no_edit = function() return not g_Classes.ConstructionCost end",
    "base_class",
    "ConstructionCost",
    "inclusive",
    true
  }),
  PlaceObj("PropertyDefNumber", {
    "id",
    "repair_points",
    "name",
    "Repair Points",
    "help",
    "Repair work costs (40 sec = 1h)",
    "default",
    0,
    "scale",
    "sec",
    "min",
    -1
  }),
  PlaceObj("PropertyDefNumber", {
    "id",
    "health",
    "name",
    "Health",
    "help",
    "Room max health is calculated on the base of it's slabs health",
    "default",
    0,
    "scale",
    1000
  }),
  PlaceObj("PropertyDefNumber", {
    "id",
    "strength",
    "name",
    "Material Strength",
    "help",
    "When walls are on top of each other, the wall with most strength is the one visible.",
    "default",
    -1,
    "min",
    -1
  }),
  PlaceObj("PropertyDefText", {
    "id",
    "display_name",
    "name",
    "Display Name"
  }),
  PlaceObj("PropertyDefSet", {
    "id",
    "mat_props",
    "name",
    "Material Props",
    "items",
    function(self)
      return const.SlabMaterialProps
    end
  }),
  PlaceObj("PropertyDefNumber", {
    "id",
    "max_voxel_xy",
    "name",
    "Max Voxel XY",
    "help",
    "A room wall can only be this long when using this material.",
    "default",
    16,
    "min",
    1,
    "max",
    16
  }),
  PlaceObj("PropertyDefBool", {
    "id",
    "use_damaged",
    "name",
    "Use Damaged Subvariants",
    "help",
    "When destroyed will only replace ent with damaged subvariant;"
  }),
  PlaceObj("PropertyDefBool", {
    "id",
    "use_damaged_first_floor",
    "name",
    "Use Damaged Subvariant For First Floor Only",
    "help",
    "When destroyed will only replace ent with damaged subvariant, if on first floor, else behave as normal;"
  })
})
PlaceObj("ClassAsGroupPresetDef", {
  GroupPresetClass = "SlabPreset",
  id = "SlabVariants",
  save_in = "Libs/Volumes"
})
PlaceObj("ClassAsGroupPresetDef", {
  DefModItem = true,
  DefModItemName = "Stairs material",
  DefModItemSubmenu = "Buildings",
  DefParentClassList = {
    "SlabMaterialsBase"
  },
  GroupPresetClass = "SlabPreset",
  group = "PresetDefs",
  id = "StairsSlabMaterials",
  save_in = "Libs/Volumes"
})
