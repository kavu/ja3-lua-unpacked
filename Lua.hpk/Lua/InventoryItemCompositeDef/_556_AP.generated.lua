UndefineClass("_556_AP")
DefineClass._556_AP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/556_nato_bullets_armor_piercing",
  DisplayName = T(350757861829, "5.56 mm Armor Piercing"),
  DisplayNamePlural = T(684111621521, "5.56 mm Armor Piercing"),
  colorStyle = "AmmoAPColor",
  Description = T(259826736002, "5.56 Ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(850324784601, "<bullet_point> Improved armor penetration"),
  MaxStacks = 500,
  Caliber = "556",
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "PenetrationClass"
    })
  }
}
