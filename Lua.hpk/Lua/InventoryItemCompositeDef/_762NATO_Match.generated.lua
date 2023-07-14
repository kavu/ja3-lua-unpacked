UndefineClass("_762NATO_Match")
DefineClass._762NATO_Match = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_nato_bullets_match",
  DisplayName = T(519353641191, "7.62 mm NATO Match"),
  DisplayNamePlural = T(900333933922, "7.62 mm NATO Match"),
  colorStyle = "AmmoMatchColor",
  Description = T(411071812202, "7.62 NATO ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(898089454154, "<bullet_point> Increased bonus from Aiming"),
  MaxStacks = 500,
  Caliber = "762NATO",
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "AimAccuracy"
    })
  }
}
