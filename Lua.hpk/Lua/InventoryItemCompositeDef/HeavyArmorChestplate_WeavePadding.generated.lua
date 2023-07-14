UndefineClass("HeavyArmorChestplate_WeavePadding")
DefineClass.HeavyArmorChestplate_WeavePadding = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/heavy_vest",
  SubIcon = "UI/Icons/Items/padded",
  DisplayName = T(413722923124, "Heavy Vest"),
  DisplayNamePlural = T(403645732222, "Heavy Vests"),
  AdditionalHint = T(209137598743, [[
<bullet_point> Damage reduction improved by Weave Padding
<bullet_point> Cumbersome (no Free Move)]]),
  Cumbersome = true,
  is_valuable = true,
  PenetrationClass = 4,
  AdditionalReduction = 50,
  ProtectedBodyParts = set("Torso")
}
