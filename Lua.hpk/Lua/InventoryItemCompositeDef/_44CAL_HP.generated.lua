UndefineClass("_44CAL_HP")
DefineClass._44CAL_HP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/44_cal_bullets_hollow_point",
  DisplayName = T(977456132570, ".44 Hollow Point"),
  DisplayNamePlural = T(731855162750, ".44 Hollow Point"),
  colorStyle = "AmmoHPColor",
  Description = T(835810395897, ".44 Ammo for Revolvers and Rifles."),
  AdditionalHint = T(201599652663, [[
<bullet_point> High Crit chance
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "44CAL",
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"})
  },
  AppliedEffects = {"Bleeding"}
}
