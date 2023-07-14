UndefineClass("KevlarChestplate_WeavePadding")
DefineClass.KevlarChestplate_WeavePadding = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/kevlar_vest",
  SubIcon = "UI/Icons/Items/padded",
  DisplayName = T(672086153382, "Kevlar Vest"),
  DisplayNamePlural = T(534763739172, "Kevlar Vests"),
  AdditionalHint = T(223210776003, "<bullet_point> Damage reduction improved by Weave Padding"),
  PenetrationClass = 3,
  AdditionalReduction = 40,
  ProtectedBodyParts = set("Torso")
}
