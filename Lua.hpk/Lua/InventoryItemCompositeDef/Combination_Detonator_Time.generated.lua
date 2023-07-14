UndefineClass("Combination_Detonator_Time")
DefineClass.Combination_Detonator_Time = {
  __parents = {"MiscItem"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MiscItem",
  Repairable = false,
  Icon = "UI/Icons/Items/combination_detonator_time",
  DisplayName = T(678463828027, "Time Detonator"),
  DisplayNamePlural = T(118344798272, "Time Detonators"),
  Description = T(719759920498, "Allows a <em>Set Explosive</em> to detonate after a chosen amount of time has passed."),
  AdditionalHint = T(847210825755, [[
<bullet_point> Can be combined with TNT, C4, and PETN
<bullet_point> Timed explosives detonate after 1 turn (or 5 seconds out of combat)]])
}
