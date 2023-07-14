UndefineClass("HeavyArmorTorso_WeavePadding")
DefineClass.HeavyArmorTorso_WeavePadding = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/heavy_armor",
  SubIcon = "UI/Icons/Items/padded",
  DisplayName = T(947371172255, "Heavy Armor"),
  DisplayNamePlural = T(634699187749, "Heavy Armors"),
  AdditionalHint = T(963784109704, [[
<bullet_point> Damage reduction improved by Weave Padding
<bullet_point> Cumbersome (no Free Move)]]),
  Cumbersome = true,
  is_valuable = true,
  PenetrationClass = 4,
  AdditionalReduction = 50,
  ProtectedBodyParts = set("Arms", "Torso")
}
