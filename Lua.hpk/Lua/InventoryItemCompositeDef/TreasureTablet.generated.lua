UndefineClass("TreasureTablet")
DefineClass.TreasureTablet = {
  __parents = {"Valuables"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Valuables",
  Repairable = false,
  Icon = "UI/Icons/Items/treasure_clay_tablet",
  DisplayName = T(891257997779, "Ancient Clay Tablet"),
  DisplayNamePlural = T(639113935912, "Ancient Clay Tablets"),
  Description = T(825926118347, "Covered with hieroglyphs that contain words of indecipherable wisdom, or perhaps just the bill for a dinner paid 3250 years BCE. "),
  AdditionalHint = T(994839772197, [[
<bullet_point> Can be cashed in for Money
<bullet_point> A piece of Grand Chien's glorious past]]),
  is_valuable = true,
  Cost = 3000,
  MaxStacks = 1
}
