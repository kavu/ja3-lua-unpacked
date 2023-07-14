UndefineClass("Lockpick")
DefineClass.Lockpick = {
  __parents = {
    "LockpickBase"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "LockpickBase",
  Repairable = false,
  ScrapParts = 2,
  Icon = "UI/Icons/Items/lockpick",
  DisplayName = T(363189070824, "Locksmith's Kit"),
  DisplayNamePlural = T(983215060783, "Locksmith's Kits"),
  AdditionalHint = T(336083124700, [[
<bullet_point> Unlocks doors and containers (based on Mechanical)
<bullet_point> Unskilled use may permanently damage the lock
<bullet_point> Loses Condition after each use
<bullet_point> Cannot be repaired
<bullet_point> Used automatically from the Inventory]]),
  UnitStat = "Mechanical"
}
