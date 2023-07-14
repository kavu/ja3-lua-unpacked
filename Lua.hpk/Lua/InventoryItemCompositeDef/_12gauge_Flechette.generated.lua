UndefineClass("_12gauge_Flechette")
DefineClass._12gauge_Flechette = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/12_gauge_bullets_flechette",
  DisplayName = T(812367261617, "12-gauge Sabot"),
  DisplayNamePlural = T(125497062275, "12-gauge Sabot"),
  colorStyle = "AmmoMatchColor",
  Description = T(732291740225, "12-gauge ammo for Shotguns."),
  AdditionalHint = T(114102212532, [[
<bullet_point> Longer range
<bullet_point> Narrow attack cone
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "12gauge",
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_mul = 500,
      target_prop = "BuckshotConeAngle"
    }),
    PlaceObj("CaliberModification", {
      mod_mul = 500,
      target_prop = "OverwatchAngle"
    }),
    PlaceObj("CaliberModification", {
      mod_add = 4,
      target_prop = "WeaponRange"
    })
  },
  AppliedEffects = {"Bleeding"}
}
