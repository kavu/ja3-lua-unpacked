UndefineClass("SkillMag_Dexterity")
DefineClass.SkillMag_Dexterity = {
  __parents = {"MiscItem"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MiscItem",
  Repairable = false,
  Icon = "UI/Icons/Items/mag_sleight_of_hand",
  DisplayName = T(742728199089, "Sleight of Hand"),
  DisplayNamePlural = T(201148125710, "Sleight of Hand"),
  Description = T(469561072760, "Much better read than Daily Prestidigitation."),
  AdditionalHint = T(684823166353, [[
<bullet_point> Used through the Item Menu
<bullet_point> Single use
<bullet_point> Increases Dexterity]]),
  UnitStat = "Dexterity",
  is_valuable = true,
  effect_moment = "on_use",
  Effects = {
    PlaceObj("UnitStatBoost", {Amount = 1, Stat = "Dexterity"})
  },
  action_name = T(161343355015, "READ"),
  destroy_item = true
}
