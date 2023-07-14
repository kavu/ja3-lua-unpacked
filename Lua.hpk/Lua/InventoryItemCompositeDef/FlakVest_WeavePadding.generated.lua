UndefineClass("FlakVest_WeavePadding")
DefineClass.FlakVest_WeavePadding = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/flak_vest",
  SubIcon = "UI/Icons/Items/padded",
  DisplayName = T(286438919370, "Flak Vest"),
  DisplayNamePlural = T(207946126397, "Flak Vests"),
  Description = "",
  AdditionalHint = T(995525860723, "<bullet_point> Damage reduction improved by Weave Padding"),
  PenetrationClass = 2,
  AdditionalReduction = 30,
  ProtectedBodyParts = set("Torso")
}
