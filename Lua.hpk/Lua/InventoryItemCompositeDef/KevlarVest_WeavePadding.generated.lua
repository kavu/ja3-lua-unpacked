UndefineClass("KevlarVest_WeavePadding")
DefineClass.KevlarVest_WeavePadding = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/kevlar_armor",
  SubIcon = "UI/Icons/Items/padded",
  DisplayName = T(143391465564, "Kevlar Armor"),
  DisplayNamePlural = T(828774839698, "Kevlar Armors"),
  AdditionalHint = T(165127353917, "<bullet_point> Damage reduction improved by Weave Padding"),
  PenetrationClass = 3,
  AdditionalReduction = 40,
  ProtectedBodyParts = set("Arms", "Torso")
}
