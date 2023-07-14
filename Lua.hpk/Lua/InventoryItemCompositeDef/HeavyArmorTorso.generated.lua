UndefineClass("HeavyArmorTorso")
DefineClass.HeavyArmorTorso = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/heavy_armor",
  DisplayName = T(269180326225, "Heavy Armor"),
  DisplayNamePlural = T(167239210459, "Heavy Armors"),
  AdditionalHint = T(243929025325, "<bullet_point> Cumbersome (no Free Move)"),
  Cumbersome = true,
  is_valuable = true,
  PenetrationClass = 4,
  AdditionalReduction = 40,
  ProtectedBodyParts = set("Arms", "Torso")
}
