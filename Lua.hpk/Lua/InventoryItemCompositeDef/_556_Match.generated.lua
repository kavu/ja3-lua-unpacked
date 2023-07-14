UndefineClass("_556_Match")
DefineClass._556_Match = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/556_nato_bullets_match",
  DisplayName = T(122498717966, "5.56 mm Match"),
  DisplayNamePlural = T(844110421786, "5.56 mm Match"),
  colorStyle = "AmmoMatchColor",
  Description = T(526351062603, "5.56 Ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(898089454154, "<bullet_point> Increased bonus from Aiming"),
  MaxStacks = 500,
  Caliber = "556",
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "AimAccuracy"
    })
  }
}
