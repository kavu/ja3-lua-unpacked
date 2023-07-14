UndefineClass("PETN")
DefineClass.PETN = {
  __parents = {
    "ExplosiveSubstance"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "ExplosiveSubstance",
  Repairable = false,
  Icon = "UI/Icons/Items/petn",
  DisplayName = T(840692162750, "PETN"),
  DisplayNamePlural = T(916343361606, "PETN"),
  Description = T(186864246396, "A powerful plastic explosive substance used in major demolition and military high-grade explosives."),
  AdditionalHint = T(556435194541, "<bullet_point> Combine with a Detonator type to create an Explosive"),
  UnitStat = "Explosives",
  CenterUnitDamageMod = 130,
  CenterObjDamageMod = 500,
  AreaOfEffect = 4,
  AreaObjDamageMod = 500,
  DeathType = "BlowUp",
  BaseDamage = 50
}
