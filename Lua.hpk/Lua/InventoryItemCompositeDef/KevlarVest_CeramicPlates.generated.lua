UndefineClass("KevlarVest_CeramicPlates")
DefineClass.KevlarVest_CeramicPlates = {
  __parents = {
    "TransmutedArmor"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "TransmutedArmor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/kevlar_armor",
  SubIcon = "UI/Icons/Items/plates",
  DisplayName = T(982997486407, "Kevlar Armor"),
  DisplayNamePlural = T(430963369197, "Kevlar Armors"),
  AdditionalHint = T(815941281345, [[
<bullet_point> Damage reduction improved by Ceramic Plates
<bullet_point> The ceramic plates will break after taking <GameColorG><RevertConditionCounter></GameColorG> hits]]),
  PenetrationClass = 3,
  DamageReduction = 40,
  AdditionalReduction = 30,
  ProtectedBodyParts = set("Arms", "Torso")
}
