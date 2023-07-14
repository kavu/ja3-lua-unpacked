UndefineClass("HeavyArmorTorso_CeramicPlates")
DefineClass.HeavyArmorTorso_CeramicPlates = {
  __parents = {
    "TransmutedArmor"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "TransmutedArmor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/heavy_armor",
  SubIcon = "UI/Icons/Items/plates",
  DisplayName = T(440500563664, "Heavy Armor"),
  DisplayNamePlural = T(958357023612, "Heavy Armors"),
  AdditionalHint = T(794060410743, [[
<bullet_point> Damage reduction improved by Ceramic Plates
<bullet_point> The ceramic plates will break after taking <GameColorG><RevertConditionCounter></GameColorG> hits
<bullet_point> Cumbersome (no Free Move)]]),
  Cumbersome = true,
  is_valuable = true,
  PenetrationClass = 4,
  DamageReduction = 40,
  AdditionalReduction = 40,
  ProtectedBodyParts = set("Arms", "Torso")
}
