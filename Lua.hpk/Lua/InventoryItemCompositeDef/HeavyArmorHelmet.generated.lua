UndefineClass("HeavyArmorHelmet")
DefineClass.HeavyArmorHelmet = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 2,
  Icon = "UI/Icons/Items/heavy_helmet",
  DisplayName = T(674090196987, "Heavy Armor Helmet"),
  DisplayNamePlural = T(934219027606, "Heavy Armor Helmets"),
  AdditionalHint = T(583324262326, "<bullet_point> Cumbersome (no Free Move)"),
  Cumbersome = true,
  is_valuable = true,
  Slot = "Head",
  PenetrationClass = 4,
  AdditionalReduction = 40,
  ProtectedBodyParts = set("Head")
}
