UndefineClass("ToxicGasGrenade")
DefineClass.ToxicGasGrenade = {
  __parents = {"Grenade"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Grenade",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Weapons/ToxicGrenade",
  ItemType = "GrenadeGas",
  DisplayName = T(964873952747, "Mustard Gas Grenade"),
  DisplayNamePlural = T(321416953052, "Mustard Gas Grenades"),
  AdditionalHint = T(277464468866, [[
<bullet_point> Inflicts <em>Choking</em>
<bullet_point> Ranged attacks passing through gas become grazing hits
<bullet_point> High mishap chance
<bullet_point> Almost silent]]),
  UnitStat = "Explosives",
  Cost = 1500,
  MinMishapChance = 2,
  MaxMishapChance = 30,
  MaxMishapRange = 6,
  CenterUnitDamageMod = 0,
  CenterObjDamageMod = 0,
  AreaUnitDamageMod = 0,
  AreaObjDamageMod = 0,
  PenetrationClass = 3,
  BaseDamage = 0,
  Scatter = 4,
  AttackAP = 4000,
  Noise = 0,
  aoeType = "toxicgas",
  Entity = "Weapon_MolotovCocktail",
  ActionIcon = "UI/Icons/Hud/toxic_grenade"
}
