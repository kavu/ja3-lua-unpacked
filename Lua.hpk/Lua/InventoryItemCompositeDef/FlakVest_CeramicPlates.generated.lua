UndefineClass("FlakVest_CeramicPlates")
DefineClass.FlakVest_CeramicPlates = {
  __parents = {
    "TransmutedArmor"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "TransmutedArmor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/flak_vest",
  SubIcon = "UI/Icons/Items/plates",
  DisplayName = T(204904790371, "Flak Vest"),
  DisplayNamePlural = T(915485818265, "Flak Vests"),
  AdditionalHint = T(512514284052, [[
<bullet_point> Damage reduction improved by Ceramic Plates
<bullet_point> The ceramic plates will break after taking <GameColorG><RevertConditionCounter></GameColorG> hits]]),
  PenetrationClass = 2,
  DamageReduction = 40,
  AdditionalReduction = 20,
  ProtectedBodyParts = set("Torso")
}
