UndefineClass("Crowbar")
DefineClass.Crowbar = {
  __parents = {
    "CrowbarBase"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "CrowbarBase",
  Repairable = false,
  ScrapParts = 2,
  Icon = "UI/Icons/Items/crowbar",
  DisplayName = T(851337385387, "Crowbar"),
  DisplayNamePlural = T(855121960280, "Crowbars"),
  AdditionalHint = T(199918214524, [[
<bullet_point> Breaks locks of doors and containers (based on Strength)
<bullet_point> May damage the contents of containers
<bullet_point> Loses Condition after each use
<bullet_point> Cannot be repaired
<bullet_point> Used automatically from the Inventory]]),
  UnitStat = "Strength"
}
