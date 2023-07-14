UndefineClass("HeavyArmorLeggings")
DefineClass.HeavyArmorLeggings = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/heavy_leggings",
  DisplayName = T(958514093547, "Heavy Armor Leggings"),
  DisplayNamePlural = T(661354623638, "Heavy Armor Leggings"),
  AdditionalHint = T(928481891307, "<bullet_point> Cumbersome (no Free Move)"),
  Cumbersome = true,
  is_valuable = true,
  Slot = "Legs",
  PenetrationClass = 4,
  AdditionalReduction = 40,
  ProtectedBodyParts = set("Groin", "Legs")
}
