UndefineClass("Infected_HardenedSkin")
DefineClass.Infected_HardenedSkin = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  RepairCost = 1000,
  Repairable = false,
  Degradation = 0,
  ScrapParts = 3,
  Icon = "UI/Icons/Items/kevlar_vest",
  DisplayName = T(963293413235, "Resilience"),
  DisplayNamePlural = T(466287168405, "Resilience"),
  Description = "",
  AdditionalHint = "",
  Cost = 700,
  PenetrationClass = 3,
  DamageReduction = 0,
  AdditionalReduction = 50,
  ProtectedBodyParts = set("Arms", "Groin", "Legs", "Torso")
}
