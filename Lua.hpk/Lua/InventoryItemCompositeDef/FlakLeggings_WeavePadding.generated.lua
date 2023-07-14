UndefineClass("FlakLeggings_WeavePadding")
DefineClass.FlakLeggings_WeavePadding = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/flak_leggings",
  SubIcon = "UI/Icons/Items/padded",
  DisplayName = T(567301828854, "Flak Leggings"),
  DisplayNamePlural = T(579822006608, "Flak Leggings"),
  Description = "",
  AdditionalHint = T(129717268097, "<bullet_point> Damage reduction improved by Weave Padding"),
  Slot = "Legs",
  PenetrationClass = 2,
  AdditionalReduction = 30,
  ProtectedBodyParts = set("Groin", "Legs")
}
