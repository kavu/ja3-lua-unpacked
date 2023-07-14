UndefineClass("CamoArmor_Medium")
DefineClass.CamoArmor_Medium = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/camo_armor_medium",
  DisplayName = T(563558859870, "Medium Camo Armor"),
  DisplayNamePlural = T(475212621823, "Medium Camo Armors"),
  AdditionalHint = T(265860069213, [[
<bullet_point> Harder to detect by enemies
<bullet_point> Aiming is less effective against camouflaged targets
<bullet_point> Can't be combined with weave or ceramics]]),
  PenetrationClass = 3,
  AdditionalReduction = 30,
  ProtectedBodyParts = set("Torso"),
  Camouflage = true
}
