UndefineClass("Super_HE_Grenade")
DefineClass.Super_HE_Grenade = {
  __parents = {"Grenade"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Grenade",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Weapons/HEGrenade",
  ItemType = "Grenade",
  DisplayName = T(966208141903, "Demo Charge"),
  DisplayNamePlural = T(580167933429, "Demo Charges"),
  UnitStat = "Explosives",
  Cost = 1500,
  MinMishapChance = -2,
  MaxMishapChance = 18,
  MaxMishapRange = 6,
  CenterObjDamageMod = 500,
  AreaObjDamageMod = 500,
  DeathType = "BlowUp",
  BaseDamage = 100,
  Entity = "Weapon_FragGrenadeM67"
}
