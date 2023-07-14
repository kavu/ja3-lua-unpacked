UndefineClass("Personal_Vicki_CustomTools")
DefineClass.Personal_Vicki_CustomTools = {
  __parents = {
    "LockpickBase"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "LockpickBase",
  RepairCost = 120,
  Icon = "UI/Icons/Items/vicki_lockpick",
  DisplayName = T(124312301509, "Vicki's Locksmith Kit"),
  DisplayNamePlural = T(609821932113, "Vicki's Locksmith Kit"),
  AdditionalHint = T(144173216875, [[
<bullet_point> Unlocks doors and containers (based on Mechanical)
<bullet_point> Bonus to skill checks for picking locks
<bullet_point> Loses Condition after each use
<bullet_point> Can be repaired
<bullet_point> Used automatically from the Inventory]]),
  UnitStat = "Mechanical",
  locked = true,
  skillCheckPenalty = -10
}
