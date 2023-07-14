UndefineClass("RemoteTNT")
DefineClass.RemoteTNT = {
  __parents = {
    "ThrowableTrapItem"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "ThrowableTrapItem",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Items/remote_tnt",
  ItemType = "Grenade",
  DisplayName = T(814310721881, "Remote TNT"),
  DisplayNamePlural = T(850557903938, "Remote TNT"),
  AdditionalHint = T(934007885412, [[
<bullet_point> Explodes when triggered by a remote Detonator switch
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
  ActionIcon = "UI/Icons/Hud/throw_remote_explosive",
  TriggerType = "Remote"
}
