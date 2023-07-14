UndefineClass("FlakArmor_CeramicPlates")
DefineClass.FlakArmor_CeramicPlates = {
  __parents = {
    "TransmutedArmor"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "TransmutedArmor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/flak_armor",
  SubIcon = "UI/Icons/Items/plates",
  DisplayName = T(977066896029, "Flak Armor"),
  DisplayNamePlural = T(195720969644, "Flak Armors"),
  AdditionalHint = T(800327779807, [[
<bullet_point> Damage reduction improved by Ceramic Plates
<bullet_point> The ceramic plates will break after taking <GameColorG><RevertConditionCounter></GameColorG> hits]]),
  PenetrationClass = 2,
  DamageReduction = 40,
  AdditionalReduction = 20,
  ProtectedBodyParts = set("Arms", "Torso")
}
