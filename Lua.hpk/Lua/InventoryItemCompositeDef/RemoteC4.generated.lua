UndefineClass("RemoteC4")
DefineClass.RemoteC4 = {
  __parents = {
    "ThrowableTrapItem"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "ThrowableTrapItem",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Items/remote_c4",
  ItemType = "Grenade",
  DisplayName = T(989026888388, "Remote C4"),
  DisplayNamePlural = T(373405573691, "Remote C4"),
  AdditionalHint = T(874798636252, "<bullet_point> Explodes when triggered by a remote Detonator switch"),
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
  ActionIcon = "UI/Icons/Hud/throw_remote_explosive",
  TriggerType = "Remote",
  ExplosiveType = "C4"
}
