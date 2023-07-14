UndefineClass("PickupTruck")
DefineClass.PickupTruck = {
  __parents = {"Grenade"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Grenade",
  Repairable = false,
  Reliability = 100,
  CenterUnitDamageMod = 130,
  CenterObjDamageMod = 500,
  AreaOfEffect = 4,
  AreaObjDamageMod = 500,
  DeathType = "BlowUp",
  BaseDamage = 32,
  CanBounce = false,
  Entity = "MilitaryCamp_Grenade_01"
}
