UndefineClass("HeavyArmorChestplate")
DefineClass.HeavyArmorChestplate = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/heavy_vest",
  DisplayName = T(410197513169, "Heavy Vest"),
  DisplayNamePlural = T(458596493579, "Heavy Vests"),
  AdditionalHint = T(875130045840, "<bullet_point> Cumbersome (no Free Move)"),
  Cumbersome = true,
  is_valuable = true,
  PenetrationClass = 4,
  AdditionalReduction = 40,
  ProtectedBodyParts = set("Torso")
}
