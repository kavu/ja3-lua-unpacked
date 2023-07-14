UndefineClass("HeavyArmorChestplate_CeramicPlates")
DefineClass.HeavyArmorChestplate_CeramicPlates = {
  __parents = {
    "TransmutedArmor"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "TransmutedArmor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/heavy_vest",
  SubIcon = "UI/Icons/Items/plates",
  DisplayName = T(409839949549, "Heavy Vest"),
  DisplayNamePlural = T(792099182547, "Heavy Vests"),
  AdditionalHint = T(852368073119, [[
<bullet_point> Damage reduction improved by Ceramic Plates
<bullet_point> The ceramic plates will break after taking <GameColorG><RevertConditionCounter></GameColorG> hits
<bullet_point> Cumbersome (no Free Move)]]),
  Cumbersome = true,
  is_valuable = true,
  PenetrationClass = 4,
  DamageReduction = 40,
  AdditionalReduction = 40,
  ProtectedBodyParts = set("Torso")
}
