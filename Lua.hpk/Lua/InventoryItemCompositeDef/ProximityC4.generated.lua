UndefineClass("ProximityC4")
DefineClass.ProximityC4 = {
  __parents = {
    "ThrowableTrapItem"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "ThrowableTrapItem",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Items/proximity_c4",
  ItemType = "Grenade",
  DisplayName = T(580256972785, "Proximity C4"),
  DisplayNamePlural = T(612553480509, "Proximity C4"),
  AdditionalHint = T(503191302862, "<bullet_point> Explodes when an enemy enters a small area around it"),
  UnitStat = "Explosives",
  Cost = 1500,
  MinMishapChance = -2,
  MaxMishapChance = 18,
  MaxMishapRange = 6,
  AttackAP = 4000,
  BaseRange = 3,
  ThrowMaxRange = 12,
  CanBounce = false,
  IgnoreCoverReduction = 1,
  Noise = 30,
  Entity = "Explosive_C4",
  ActionIcon = "UI/Icons/Hud/throw_proximity_explosive",
  TriggerType = "Proximity",
  ExplosiveType = "C4"
}
