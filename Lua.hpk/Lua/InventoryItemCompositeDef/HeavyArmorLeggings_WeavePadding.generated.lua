UndefineClass("HeavyArmorLeggings_WeavePadding")
DefineClass.HeavyArmorLeggings_WeavePadding = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/heavy_leggings",
  SubIcon = "UI/Icons/Items/padded",
  DisplayName = T(900851966356, "Heavy Armor Leggings"),
  DisplayNamePlural = T(383152125619, "Heavy Armor Leggings"),
  AdditionalHint = T(496237475449, [[
<bullet_point> Damage reduction improved by Weave Padding
<bullet_point> Cumbersome (no Free Move)]]),
  Cumbersome = true,
  is_valuable = true,
  Slot = "Legs",
  PenetrationClass = 4,
  AdditionalReduction = 50,
  ProtectedBodyParts = set("Groin", "Legs")
}
