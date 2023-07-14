UndefineClass("RemotePETN")
DefineClass.RemotePETN = {
  __parents = {
    "ThrowableTrapItem"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "ThrowableTrapItem",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Items/remote_petn",
  ItemType = "Grenade",
  DisplayName = T(979387484103, "Remote PETN"),
  DisplayNamePlural = T(707430118983, "Remote PETN"),
  AdditionalHint = T(720306300310, "<bullet_point> Explodes when triggered by a remote Detonator switch"),
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
  ActionIcon = "UI/Icons/Hud/throw_remote_explosive",
  TriggerType = "Remote",
  ExplosiveType = "PETN"
}
