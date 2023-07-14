UndefineClass("_50BMG_HE")
DefineClass._50BMG_HE = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/50bmg_he",
  DisplayName = T(638878429442, ".50 Explosive"),
  DisplayNamePlural = T(784235316318, ".50 Explosive"),
  colorStyle = "AmmoHPColor",
  Description = T(974086720946, ".50 Ammo for Machine Guns, Snipers and Handguns."),
  AdditionalHint = T(642232526717, [[
<bullet_point> No armor penetration
<bullet_point> High Crit chance]]),
  MaxStacks = 500,
  Caliber = "50BMG",
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {
      mod_add = -4,
      target_prop = "PenetrationClass"
    })
  }
}
