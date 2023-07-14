UndefineClass("FlareStick")
DefineClass.FlareStick = {
  __parents = {"Flare"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Flare",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Weapons/FlareStick",
  ItemType = "Throwables",
  DisplayName = T(772865751298, "Flare Stick"),
  DisplayNamePlural = T(104150569773, "Flare Sticks"),
  AdditionalHint = T(677550446145, [[
<bullet_point> Illuminates a large area
<bullet_point> High mishap chance
<bullet_point> Silent]]),
  UnitStat = "Explosives",
  Cost = 1500,
  MinMishapChance = 10,
  MaxMishapChance = 50,
  MaxMishapRange = 6,
  CenterUnitDamageMod = 0,
  CenterObjDamageMod = 0,
  AreaOfEffect = 4,
  AreaUnitDamageMod = 0,
  AreaObjDamageMod = 0,
  PenetrationClass = 1,
  BaseDamage = 0,
  Scatter = 4,
  AttackAP = 4000,
  Noise = 0,
  Entity = "Weapon_MolotovCocktail",
  ActionIcon = "UI/Icons/Hud/flare"
}
