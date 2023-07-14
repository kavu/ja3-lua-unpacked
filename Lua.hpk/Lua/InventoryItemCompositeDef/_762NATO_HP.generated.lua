UndefineClass("_762NATO_HP")
DefineClass._762NATO_HP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_nato_bullets_hollow_point",
  DisplayName = T(669691454944, "7.62 mm NATO Hollow Point"),
  DisplayNamePlural = T(155427073305, "7.62 mm NATO Hollow Point"),
  colorStyle = "AmmoHPColor",
  Description = T(597109486171, "7.62 NATO ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(447573359889, [[
<bullet_point> No armor penetration
<bullet_point> High Crit chance
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "762NATO",
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {
      mod_add = -4,
      target_prop = "PenetrationClass"
    })
  },
  AppliedEffects = {"Bleeding"}
}
