UndefineClass("TearGasGrenade")
DefineClass.TearGasGrenade = {
  __parents = {"Grenade"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Grenade",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Weapons/TearGasGrenade",
  ItemType = "GrenadeGas",
  DisplayName = T(591872286262, "Tear Gas Grenade"),
  DisplayNamePlural = T(942175585447, "Tear Gas Grenades"),
  AdditionalHint = T(102232599134, [[
<bullet_point> Inflicts <em>Blinded</em>
<bullet_point> Ranged attacks passing through gas become <em>grazing</em> hits
<bullet_point> No damage
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
  PenetrationClass = 1,
  BaseDamage = 0,
  Scatter = 4,
  AttackAP = 4000,
  Noise = 0,
  aoeType = "teargas",
  Entity = "Weapon_MolotovCocktail",
  ActionIcon = "UI/Icons/Hud/tear_gas_grenade"
}
