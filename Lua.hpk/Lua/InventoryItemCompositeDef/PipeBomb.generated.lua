UndefineClass("PipeBomb")
DefineClass.PipeBomb = {
  __parents = {
    "ThrowableTrapItem"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "ThrowableTrapItem",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Weapons/PipeBomb",
  ItemType = "Grenade",
  DisplayName = T(642346688869, "Pipe Bomb"),
  DisplayNamePlural = T(494920208733, "Pipe Bombs"),
  AdditionalHint = T(155469163103, [[
<bullet_point> Explodes after 1 turn (or 5 seconds out of combat)
<bullet_point> High mishap chance
<bullet_point> Inflicts Bleeding]]),
  UnitStat = "Explosives",
  Cost = 1500,
  MinMishapChance = 2,
  MaxMishapChance = 30,
  MaxMishapRange = 6,
  CenterUnitDamageMod = 130,
  CenterAppliedEffects = {"Bleeding"},
  AttackAP = 3000,
  BaseRange = 3,
  ThrowMaxRange = 12,
  Entity = "Explosive_TNT",
  ActionIcon = "UI/Icons/Hud/pipe_bomb",
  TriggerType = "Timed",
  ExplosiveType = "BlackPowder"
}
