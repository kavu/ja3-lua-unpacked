UndefineClass("_44CAL_Match")
DefineClass._44CAL_Match = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/44_cal_bullets_match",
  DisplayName = T(249943286285, ".44 Match"),
  DisplayNamePlural = T(987921160651, ".44 Match"),
  colorStyle = "AmmoMatchColor",
  Description = T(888766429002, ".44 Ammo for Revolvers and Rifles."),
  AdditionalHint = T(898089454154, "<bullet_point> Increased bonus from Aiming"),
  MaxStacks = 500,
  Caliber = "44CAL",
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "AimAccuracy"
    })
  }
}
