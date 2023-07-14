UndefineClass("KevlarLeggings_WeavePadding")
DefineClass.KevlarLeggings_WeavePadding = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/kevlar_leggings",
  SubIcon = "UI/Icons/Items/padded",
  DisplayName = T(995619097583, "Kevlar Leggings"),
  DisplayNamePlural = T(297011337212, "Kevlar Leggings"),
  AdditionalHint = T(357999944878, "<bullet_point> Damage reduction improved by Weave Padding"),
  Slot = "Legs",
  PenetrationClass = 3,
  AdditionalReduction = 40,
  ProtectedBodyParts = set("Groin", "Legs")
}
