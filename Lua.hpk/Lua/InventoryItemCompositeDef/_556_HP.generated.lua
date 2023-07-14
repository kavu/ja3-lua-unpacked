UndefineClass("_556_HP")
DefineClass._556_HP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/556_nato_bullets_hollow_point",
  DisplayName = T(359801302480, "5.56 mm Hollow Point"),
  DisplayNamePlural = T(769486263588, "5.56 mm Hollow Point"),
  colorStyle = "AmmoHPColor",
  Description = T(271563525530, "5.56 Ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(333746477431, [[
<bullet_point> No armor penetration
<bullet_point> High Crit chance
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "556",
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {
      mod_add = -4,
      target_prop = "PenetrationClass"
    })
  },
  AppliedEffects = {"Bleeding"}
}
