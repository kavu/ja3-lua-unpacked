UndefineClass("_12gauge_Saltshot")
DefineClass._12gauge_Saltshot = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/12_gauge_bullets_saltshot",
  DisplayName = T(267395126102, "12-gauge Saltshot"),
  DisplayNamePlural = T(598926526992, "12-gauge Saltshot"),
  colorStyle = "AmmoTracerColor",
  Description = T(865200495495, "12-gauge ammo for Shotguns."),
  AdditionalHint = T(331667140330, [[
<bullet_point> Low damage
<bullet_point> Shorter range
<bullet_point> Wide attack cone
<bullet_point> Inflicts <em>Inaccurate</em>]]),
  MaxStacks = 500,
  Caliber = "12gauge",
  Modifications = {
    PlaceObj("CaliberModification", {mod_mul = 500, target_prop = "Damage"}),
    PlaceObj("CaliberModification", {
      mod_mul = 1700,
      target_prop = "BuckshotConeAngle"
    }),
    PlaceObj("CaliberModification", {
      mod_add = -2,
      target_prop = "WeaponRange"
    }),
    PlaceObj("CaliberModification", {
      mod_mul = 1700,
      target_prop = "OverwatchAngle"
    })
  },
  AppliedEffects = {"Inaccurate"}
}
