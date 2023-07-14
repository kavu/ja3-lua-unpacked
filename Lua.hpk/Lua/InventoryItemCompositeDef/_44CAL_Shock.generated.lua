UndefineClass("_44CAL_Shock")
DefineClass._44CAL_Shock = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/44_cal_bullets_shock",
  DisplayName = T(183749046877, ".44 Shock"),
  DisplayNamePlural = T(299199326767, ".44 Shock"),
  colorStyle = "AmmoHPColor",
  Description = T(661797428567, ".44 Ammo for Revolvers and Rifles."),
  AdditionalHint = T(628229272101, [[
<bullet_point> Reduced range
<bullet_point> High Crit chance
<bullet_point> Hit enemies are <em>Exposed</em> and lose the benefits of Cover
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "44CAL",
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {
      mod_add = -4,
      target_prop = "WeaponRange"
    })
  },
  AppliedEffects = {"Exposed", "Bleeding"}
}
