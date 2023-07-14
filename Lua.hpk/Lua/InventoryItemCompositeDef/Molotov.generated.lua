UndefineClass("Molotov")
DefineClass.Molotov = {
  __parents = {"Grenade"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Grenade",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Weapons/Molotov",
  ItemType = "GrenadeFire",
  DisplayName = T(665252694789, "Molotov Cocktail"),
  DisplayNamePlural = T(110648742476, "Molotov Cocktails"),
  AdditionalHint = T(646137175112, [[
<bullet_point> Sets an area on fire and inflicts <em>Burning</em>
<bullet_point> High mishap chance]]),
  UnitStat = "Explosives",
  Cost = 1500,
  MinMishapChance = 2,
  MaxMishapChance = 30,
  MaxMishapRange = 6,
  CenterUnitDamageMod = 0,
  CenterObjDamageMod = 0,
  AreaOfEffect = 2,
  AreaUnitDamageMod = 0,
  AreaObjDamageMod = 0,
  PenetrationClass = 1,
  BaseDamage = 0,
  Scatter = 4,
  CanBounce = false,
  Noise = 0,
  aoeType = "fire",
  Entity = "Weapon_MolotovCocktail",
  ActionIcon = "UI/Icons/Hud/molotov"
}
