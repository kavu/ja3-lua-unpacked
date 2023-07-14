UndefineClass("TimedC4")
DefineClass.TimedC4 = {
  __parents = {
    "ThrowableTrapItem"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "ThrowableTrapItem",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Items/timed_c4",
  ItemType = "Grenade",
  DisplayName = T(354297860792, "Timed C4"),
  DisplayNamePlural = T(154016635958, "Timed C4"),
  AdditionalHint = T(639932937358, "<bullet_point> Explodes after 1 turn (or 5 seconds out of combat)"),
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
  ActionIcon = "UI/Icons/Hud/throw_timed_explosives",
  TriggerType = "Timed",
  ExplosiveType = "C4"
}
