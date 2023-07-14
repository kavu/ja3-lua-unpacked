UndefineClass("FlakArmor_WeavePadding")
DefineClass.FlakArmor_WeavePadding = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/flak_armor",
  SubIcon = "UI/Icons/Items/padded",
  DisplayName = T(336822464699, "Flak Armor"),
  DisplayNamePlural = T(250499294314, "Flak Armors"),
  AdditionalHint = T(190251697819, "<bullet_point> Damage reduction improved by Weave Padding"),
  PenetrationClass = 2,
  AdditionalReduction = 30,
  ProtectedBodyParts = set("Arms", "Torso")
}
