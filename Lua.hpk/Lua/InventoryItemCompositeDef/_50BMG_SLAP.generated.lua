UndefineClass("_50BMG_SLAP")
DefineClass._50BMG_SLAP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/50bmg_slap",
  DisplayName = T(328537436087, ".50 SLAP"),
  DisplayNamePlural = T(152196917983, ".50 SLAP"),
  colorStyle = "AmmoAPColor",
  Description = T(189786149121, ".50 Ammo for Machine Guns, Snipers and Handguns."),
  AdditionalHint = T(424614747022, [[
<bullet_point> Improved armor penetration
<bullet_point> Slightly higher Crit chance]]),
  MaxStacks = 500,
  Caliber = "50BMG",
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 1,
      target_prop = "PenetrationClass"
    }),
    PlaceObj("CaliberModification", {mod_add = 15, target_prop = "CritChance"})
  }
}
