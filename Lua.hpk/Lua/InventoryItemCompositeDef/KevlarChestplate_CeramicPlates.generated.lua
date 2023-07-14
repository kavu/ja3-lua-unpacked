UndefineClass("KevlarChestplate_CeramicPlates")
DefineClass.KevlarChestplate_CeramicPlates = {
  __parents = {
    "TransmutedArmor"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "TransmutedArmor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/kevlar_vest",
  SubIcon = "UI/Icons/Items/plates",
  DisplayName = T(449111663620, "Kevlar Vest"),
  DisplayNamePlural = T(667447460358, "Kevlar Vests"),
  AdditionalHint = T(534597878720, [[
<bullet_point> Damage reduction improved by Ceramic Plates
<bullet_point> The ceramic plates will break after taking <GameColorG><RevertConditionCounter></GameColorG> hits]]),
  PenetrationClass = 3,
  DamageReduction = 40,
  AdditionalReduction = 30,
  ProtectedBodyParts = set("Torso")
}
