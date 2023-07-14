UndefineClass("_9mm_HP")
DefineClass._9mm_HP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/9mm_bullets_hollow_point",
  DisplayName = T(266966643839, "9 mm Hollow Point"),
  DisplayNamePlural = T(560775721611, "9 mm Hollow Point"),
  colorStyle = "AmmoHPColor",
  Description = T(839153279981, "9 mm ammo for Handguns and SMGs."),
  AdditionalHint = T(264921787121, [[
<bullet_point> No armor penetration
<bullet_point> High Crit chance
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "9mm",
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {
      mod_add = -4,
      target_prop = "PenetrationClass"
    })
  },
  AppliedEffects = {"Bleeding"}
}
