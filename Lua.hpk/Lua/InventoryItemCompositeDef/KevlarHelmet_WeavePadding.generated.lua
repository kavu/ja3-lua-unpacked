UndefineClass("KevlarHelmet_WeavePadding")
DefineClass.KevlarHelmet_WeavePadding = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 2,
  Icon = "UI/Icons/Items/kevlar_helmet",
  SubIcon = "UI/Icons/Items/padded",
  DisplayName = T(801641960244, "Kevlar Helmet"),
  DisplayNamePlural = T(690130372665, "Kevlar Helmets"),
  AdditionalHint = T(932897515225, "<bullet_point> Damage reduction improved by Weave Padding"),
  Slot = "Head",
  PenetrationClass = 3,
  AdditionalReduction = 40,
  ProtectedBodyParts = set("Head")
}
