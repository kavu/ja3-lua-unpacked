UndefineClass("_40mmFragGrenade")
DefineClass._40mmFragGrenade = {
  __parents = {"Ordnance"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ordnance",
  Icon = "UI/Icons/Items/40mm_frag_grenade",
  DisplayName = T(551384656328, "40 mm HE"),
  DisplayNamePlural = T(922038247898, "40 mm HE"),
  Description = T(997055293212, "40 mm ordnance ammo for Grenade Launchers."),
  AdditionalHint = T(838736661240, "<bullet_point> Inflicts <em>Bleeding</em> in the epicenter"),
  CenterUnitDamageMod = 130,
  CenterObjDamageMod = 500,
  CenterAppliedEffects = {"Bleeding"},
  AreaObjDamageMod = 500,
  PenetrationClass = 4,
  DeathType = "BlowUp",
  Caliber = "40mmGrenade",
  BaseDamage = 40,
  Entity = "Weapon_MilkorMGL_Shell"
}
