UndefineClass("_9mm_AP")
DefineClass._9mm_AP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/9mm_bullets_armor_piercing",
  DisplayName = T(511863800683, "9 mm Armor Piercing"),
  DisplayNamePlural = T(543760141960, "9 mm Armor Piercing"),
  colorStyle = "AmmoAPColor",
  Description = T(909426327700, "9 mm ammo for Handguns and SMGs."),
  AdditionalHint = T(689365321555, "<bullet_point> Improved armor penetration"),
  MaxStacks = 500,
  Caliber = "9mm",
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "PenetrationClass"
    })
  }
}
