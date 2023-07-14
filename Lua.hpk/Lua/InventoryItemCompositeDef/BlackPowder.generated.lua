UndefineClass("BlackPowder")
DefineClass.BlackPowder = {
  __parents = {
    "ExplosiveSubstance"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "ExplosiveSubstance",
  Repairable = false,
  Icon = "UI/Icons/Items/black_powder",
  DisplayName = T(435852653453, "Gunpowder"),
  DisplayNamePlural = T(459792256454, "Gunpowder"),
  AdditionalHint = T(460628985464, "<bullet_point> Used in Craft Ammo and Craft Explosives operations"),
  UnitStat = "Explosives",
  CenterUnitDamageMod = 130,
  CenterObjDamageMod = 200,
  CenterAppliedEffects = {"Bleeding"},
  AreaOfEffect = 4,
  AreaObjDamageMod = 200,
  AreaAppliedEffects = {"Bleeding"},
  PenetrationClass = 4,
  BurnGround = false,
  DeathType = "BlowUp"
}
