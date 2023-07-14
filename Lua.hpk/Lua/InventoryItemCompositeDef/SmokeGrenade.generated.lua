UndefineClass("SmokeGrenade")
DefineClass.SmokeGrenade = {
  __parents = {"Grenade"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Grenade",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Weapons/SmokeGrenade",
  ItemType = "Throwables",
  DisplayName = T(672761107292, "Smoke Grenade"),
  DisplayNamePlural = T(783603654199, "Smoke Grenades"),
  AdditionalHint = T(112062042147, [[
<bullet_point> Ranged attacks passing through gas become <em>grazing</em> hits
<bullet_point> No damage
<bullet_point> Almost silent]]),
  UnitStat = "Explosives",
  Cost = 1500,
  MinMishapChance = -2,
  MaxMishapChance = 18,
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
  aoeType = "smoke",
  Entity = "Weapon_SmokeGrenade_Test",
  ActionIcon = "UI/Icons/Hud/smoke_grenade"
}
