UndefineClass("TreasureMask")
DefineClass.TreasureMask = {
  __parents = {"Valuables"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Valuables",
  Repairable = false,
  Icon = "UI/Icons/Items/treasure_bronze_mask",
  DisplayName = T(490807427490, "Ancient Bronze Mask"),
  DisplayNamePlural = T(157840265642, "Ancient Bronze Masks"),
  Description = T(130508320836, "Putting it on makes you want to say \"Sssssmokin'!\" for no apparent reason."),
  AdditionalHint = T(333517418519, [[
<bullet_point> Can be cashed in for Money
<bullet_point> A piece of Grand Chien's glorious past]]),
  is_valuable = true,
  Cost = 3000,
  MaxStacks = 1
}
