UndefineClass("TimedPETN")
DefineClass.TimedPETN = {
  __parents = {
    "ThrowableTrapItem"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "ThrowableTrapItem",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Items/timed_petn",
  ItemType = "Grenade",
  DisplayName = T(743182716778, "Timed PETN"),
  DisplayNamePlural = T(920764985514, "Timed PETN"),
  AdditionalHint = T(628013763895, "<bullet_point> Explodes after 1 turn (or 5 seconds out of combat)"),
  UnitStat = "Explosives",
  Cost = 1500,
  MinMishapChance = -2,
  MaxMishapChance = 18,
  MaxMishapRange = 6,
  AttackAP = 4000,
  BaseRange = 3,
  ThrowMaxRange = 12,
  CanBounce = false,
  Noise = 30,
  Entity = "Explosive_PETN",
  ActionIcon = "UI/Icons/Hud/throw_timed_explosives",
  TriggerType = "Timed",
  ExplosiveType = "PETN"
}
