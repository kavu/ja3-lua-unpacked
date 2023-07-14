UndefineClass("_9mm_Shock")
DefineClass._9mm_Shock = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/9mm_bullets_shock",
  DisplayName = T(527113359889, "9 mm Shock"),
  DisplayNamePlural = T(592944604182, "9 mm Shock"),
  colorStyle = "AmmoMatchColor",
  Description = T(923881615835, "9 mm ammo for Handguns and SMGs."),
  AdditionalHint = T(205583625720, [[
<bullet_point> Reduced range
<bullet_point> No armor penetration
<bullet_point> High Crit chance
<bullet_point> Hit enemies are <em>Exposed</em> and lose the benefits of Cover
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "9mm",
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {
      mod_add = -4,
      target_prop = "PenetrationClass"
    }),
    PlaceObj("CaliberModification", {
      mod_add = -4,
      target_prop = "WeaponRange"
    })
  },
  AppliedEffects = {"Exposed", "Bleeding"}
}
