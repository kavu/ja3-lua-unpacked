UndefineClass("_44CAL_AP")
DefineClass._44CAL_AP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/44_cal_bullets_armor_piercing",
  DisplayName = T(336715778820, ".44 Armor Piercing"),
  DisplayNamePlural = T(653298577431, ".44 Armor Piercing"),
  colorStyle = "AmmoAPColor",
  Description = T(933559598531, ".44 Ammo for Revolvers and Rifles."),
  AdditionalHint = T(850324784601, "<bullet_point> Improved armor penetration"),
  MaxStacks = 500,
  Caliber = "44CAL",
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "PenetrationClass"
    })
  }
}
