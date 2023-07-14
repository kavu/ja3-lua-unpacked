UndefineClass("CamoArmor_Light")
DefineClass.CamoArmor_Light = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 6,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/camo_armor_light",
  DisplayName = T(623928157955, "Light Camo Armor"),
  DisplayNamePlural = T(728180263372, "Light Camo Armors"),
  AdditionalHint = T(990395288798, [[
<bullet_point> Harder to detect by enemies
<bullet_point> Aiming is less effective against camouflaged targets
<bullet_point> Can't be combined with weave or ceramics]]),
  PenetrationClass = 2,
  AdditionalReduction = 20,
  ProtectedBodyParts = set("Torso"),
  Camouflage = true
}
