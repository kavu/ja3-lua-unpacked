UndefineClass("Warhead_Frag")
DefineClass.Warhead_Frag = {
  __parents = {"Ordnance"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ordnance",
  Icon = "UI/Icons/Items/warhead_frag",
  DisplayName = T(341598730187, "HE Rocket"),
  DisplayNamePlural = T(736624913078, "HE Rockets"),
  Description = T(604680579328, "Ordnance ammo for Rocket Launchers."),
  AdditionalHint = T(699837764540, "<bullet_point> Inflicts Suppressed in the epicenter"),
  CenterUnitDamageMod = 130,
  CenterObjDamageMod = 500,
  CenterAppliedEffects = {"Suppressed"},
  AreaOfEffect = 2,
  AreaObjDamageMod = 500,
  DeathType = "BlowUp",
  Caliber = "Warhead",
  BaseDamage = 50,
  Noise = 30
}
