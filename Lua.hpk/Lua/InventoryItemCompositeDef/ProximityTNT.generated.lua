UndefineClass("ProximityTNT")
DefineClass.ProximityTNT = {
  __parents = {
    "ThrowableTrapItem"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "ThrowableTrapItem",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Items/proximity_tnt",
  ItemType = "Grenade",
  DisplayName = T(352304274009, "Proximity TNT"),
  DisplayNamePlural = T(750897797734, "Proximity TNT"),
  AdditionalHint = T(693212144213, [[
<bullet_point> Explodes when an enemy enters a small area around it
<bullet_point> High mishap chance]]),
  UnitStat = "Explosives",
  Cost = 1500,
  MinMishapChance = 2,
  MaxMishapChance = 30,
  MaxMishapRange = 6,
  AttackAP = 4000,
  BaseRange = 3,
  ThrowMaxRange = 12,
  CanBounce = false,
  Noise = 30,
  Entity = "Explosive_TNT",
  ActionIcon = "UI/Icons/Hud/throw_proximity_explosive",
  TriggerType = "Proximity"
}
