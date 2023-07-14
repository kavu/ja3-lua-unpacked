UndefineClass("HeavyArmorHelmet_WeavePadding")
DefineClass.HeavyArmorHelmet_WeavePadding = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 2,
  Icon = "UI/Icons/Items/heavy_helmet",
  SubIcon = "UI/Icons/Items/padded",
  DisplayName = T(239964731641, "Heavy Armor Helmet"),
  DisplayNamePlural = T(115190536445, "Heavy Armor Helmets"),
  AdditionalHint = T(935401603197, [[
<bullet_point> Damage reduction improved by Weave Padding
<bullet_point> Cumbersome (no Free Move)]]),
  Cumbersome = true,
  is_valuable = true,
  Slot = "Head",
  PenetrationClass = 4,
  AdditionalReduction = 50,
  ProtectedBodyParts = set("Head")
}
