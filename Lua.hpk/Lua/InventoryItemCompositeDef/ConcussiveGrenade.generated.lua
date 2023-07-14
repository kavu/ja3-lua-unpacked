UndefineClass("ConcussiveGrenade")
DefineClass.ConcussiveGrenade = {
  __parents = {"Grenade"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Grenade",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Weapons/ConcussiveGrenade",
  ItemType = "Grenade",
  DisplayName = T(893674710968, "Flashbang"),
  DisplayNamePlural = T(904754847701, "Flashbangs"),
  AdditionalHint = T(168495550375, [[
<bullet_point> Causes <em>Suppressed</em>
<bullet_point> Reduces target Energy (once per battle)
<bullet_point> Knocks down units in the center of the explosion
<bullet_point> Almost silent]]),
  UnitStat = "Explosives",
  Cost = 1500,
  MinMishapChance = -2,
  MaxMishapChance = 18,
  MaxMishapRange = 6,
  CenterUnitDamageMod = 0,
  CenterObjDamageMod = 0,
  CenterAppliedEffects = {
    "Suppressed",
    "IncreaseTiredness",
    "KnockDown"
  },
  AreaUnitDamageMod = 0,
  AreaObjDamageMod = 0,
  AreaAppliedEffects = {
    "Suppressed",
    "IncreaseTiredness"
  },
  PenetrationClass = 1,
  BurnGround = false,
  BaseDamage = 0,
  Scatter = 4,
  AttackAP = 4000,
  Noise = 0,
  Entity = "Weapon_StunGrenadeM84",
  ActionIcon = "UI/Icons/Hud/concussive_grenade"
}
