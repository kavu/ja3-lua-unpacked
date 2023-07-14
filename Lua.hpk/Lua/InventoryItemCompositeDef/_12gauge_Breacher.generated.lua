UndefineClass("_12gauge_Breacher")
DefineClass._12gauge_Breacher = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/12_gauge_bullets_breacher",
  DisplayName = T(838899636996, "12-gauge Breacher"),
  DisplayNamePlural = T(644219397636, "12-gauge Breacher"),
  colorStyle = "AmmoAPColor",
  Description = T(641022773748, "12-gauge ammo for Shotguns."),
  AdditionalHint = T(109230359975, [[
<bullet_point> Very short range
<bullet_point> Wide attack cone
<bullet_point> Improved armor penetration
<bullet_point> Prevents Grazing hits due to opponents Taking Cover
<bullet_point> Inflicts <em>Suppressed</em>]]),
  MaxStacks = 500,
  Caliber = "12gauge",
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 1,
      target_prop = "IgnoreCoverReduction"
    }),
    PlaceObj("CaliberModification", {
      mod_mul = 500,
      target_prop = "WeaponRange"
    }),
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "PenetrationClass"
    }),
    PlaceObj("CaliberModification", {
      mod_mul = 2000,
      target_prop = "ObjDamageMod"
    }),
    PlaceObj("CaliberModification", {
      mod_mul = 1700,
      target_prop = "BuckshotConeAngle"
    }),
    PlaceObj("CaliberModification", {
      mod_mul = 1700,
      target_prop = "OverwatchAngle"
    })
  },
  AppliedEffects = {"Suppressed"}
}
