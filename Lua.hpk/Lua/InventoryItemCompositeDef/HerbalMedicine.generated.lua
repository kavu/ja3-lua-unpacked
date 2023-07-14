UndefineClass("HerbalMedicine")
DefineClass.HerbalMedicine = {
  __parents = {"MiscItem"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MiscItem",
  Icon = "UI/Icons/Items/herbal_medicine",
  DisplayName = T(603680939283, "Herbal Medicine"),
  DisplayNamePlural = T(722930256983, "Herbal Medicine"),
  AdditionalHint = T(976799203017, [[
<bullet_point> Used through the Item Menu
<bullet_point> Single use
<bullet_point> Grants high Grit
<bullet_point> Unpredictable side effects
<bullet_point> All natural]]),
  MaxStacks = 20,
  effect_moment = "on_use",
  Effects = {
    PlaceObj("UnitAddGrit", {}),
    PlaceObj("ChangeTiredness", {delta = -1}),
    PlaceObj("ConditionalEffect", {
      "Conditions",
      {
        PlaceObj("CheckRandom", {Chance = 15})
      },
      "Effects",
      {
        PlaceObj("UnitGrantAP", {})
      }
    }),
    PlaceObj("ConditionalEffect", {
      "Conditions",
      {
        PlaceObj("CheckRandom", {Chance = 15})
      },
      "Effects",
      {
        PlaceObj("UnitAddStatusEffect", {Status = "Berserk"})
      }
    })
  },
  action_name = T(679583097578, "APPLY"),
  destroy_item = true
}
