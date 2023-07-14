UndefineClass("Medkit")
DefineClass.Medkit = {
  __parents = {"Medicine"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Medicine",
  Repairable = false,
  ScrapParts = 1,
  Icon = "UI/Icons/Items/medkit",
  DisplayName = T(999601948111, "Med Kit"),
  DisplayNamePlural = T(221861569054, "Med Kits"),
  AdditionalHint = T(543852992075, [[
<bullet_point> Restores lost HP and stabilizes dying characters
<bullet_point> Required to use Bandage
<bullet_point> Bandage heals 25% more HP
<bullet_point> Loses Condition after each use but can be refilled with Meds
<bullet_point> Used automatically from the Inventory]]),
  UnitStat = "Medical",
  max_meds_parts = 12
}
