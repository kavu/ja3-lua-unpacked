UndefineClass("C4")
DefineClass.C4 = {
  __parents = {
    "ExplosiveSubstance"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "ExplosiveSubstance",
  Repairable = false,
  Icon = "UI/Icons/Items/c4",
  DisplayName = T(884288319918, "C4"),
  DisplayNamePlural = T(187809961564, "C4"),
  AdditionalHint = T(687203079309, "<bullet_point> Combine with a Detonator to create an explosive"),
  UnitStat = "Explosives",
  CenterUnitDamageMod = 130,
  CenterObjDamageMod = 500,
  AreaOfEffect = 2,
  AreaObjDamageMod = 500,
  DeathType = "BlowUp",
  BaseDamage = 35,
  Noise = 30
}
