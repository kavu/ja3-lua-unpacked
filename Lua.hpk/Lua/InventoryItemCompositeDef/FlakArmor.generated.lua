UndefineClass("FlakArmor")
DefineClass.FlakArmor = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/flak_armor",
  DisplayName = T(562131155592, "Flak Armor"),
  DisplayNamePlural = T(259150406513, "Flak Armors"),
  PenetrationClass = 2,
  AdditionalReduction = 20,
  ProtectedBodyParts = set("Arms", "Torso")
}
