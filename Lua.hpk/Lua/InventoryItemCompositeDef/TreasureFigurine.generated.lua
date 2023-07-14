UndefineClass("TreasureFigurine")
DefineClass.TreasureFigurine = {
  __parents = {"Valuables"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Valuables",
  Repairable = false,
  Icon = "UI/Icons/Items/treasure_figurine",
  DisplayName = T(569787140093, "Ancient Figurine"),
  DisplayNamePlural = T(247060384639, "Ancient Figurines"),
  Description = T(113142181839, "Presents unrealistic matriarchal beauty standards that oppress women and translate into an appalling gender disparity."),
  AdditionalHint = T(846725836365, [[
<bullet_point> Can be cashed in for Money
<bullet_point> A piece of Grand Chien's glorious past]]),
  is_valuable = true,
  Cost = 3000,
  MaxStacks = 1
}
