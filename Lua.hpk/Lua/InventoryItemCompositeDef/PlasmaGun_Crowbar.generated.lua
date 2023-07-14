UndefineClass("PlasmaGun_Crowbar")
DefineClass.PlasmaGun_Crowbar = {
  __parents = {
    "CrowbarBase"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "CrowbarBase",
  RepairCost = 120,
  ScrapParts = 4,
  Icon = "UI/Icons/Items/plasma_gun_crowbar",
  DisplayName = T(507871191066, "Plasma Gun Crowbar"),
  DisplayNamePlural = T(593438446878, "Plasma Gun Crowbars"),
  AdditionalHint = T(209695381987, [[
<bullet_point> Shoots deadly plasma bolts while in perfect vacuum. Otherwise works as a crowbar
<bullet_point> Breaks locks of doors and containers (based on Strength)
<bullet_point> Bonus to skill checks for breaking locks
<bullet_point> May damage the contents of containers
<bullet_point> Loses Condition after each use
<bullet_point> Can be repaired
<bullet_point> Used automatically from the Inventory]]),
  is_valuable = true,
  skillCheckPenalty = -15
}
