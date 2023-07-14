UndefineClass("_9mm_Match")
DefineClass._9mm_Match = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/9mm_bullets_match",
  DisplayName = T(423815928188, "9 mm Match"),
  DisplayNamePlural = T(106653528434, "9 mm Match"),
  colorStyle = "AmmoMatchColor",
  Description = T(539464011742, "9 mm ammo for Handguns and SMGs."),
  AdditionalHint = T(169874693254, "<bullet_point> Increased bonus from Aiming"),
  MaxStacks = 500,
  Caliber = "9mm",
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "AimAccuracy"
    })
  }
}
