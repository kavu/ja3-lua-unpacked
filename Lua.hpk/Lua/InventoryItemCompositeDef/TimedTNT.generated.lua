UndefineClass("TimedTNT")
DefineClass.TimedTNT = {
  __parents = {
    "ThrowableTrapItem"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "ThrowableTrapItem",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Items/timed_tnt",
  ItemType = "Grenade",
  DisplayName = T(172654624200, "Timed TNT"),
  DisplayNamePlural = T(452046444287, "Timed TNT"),
  AdditionalHint = T(842716232815, [[
<bullet_point> Explodes after 1 turn (or 5 seconds out of combat)
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
  ActionIcon = "UI/Icons/Hud/throw_timed_explosives",
  TriggerType = "Timed"
}
