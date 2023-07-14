UndefineClass("MetaviraShot")
DefineClass.MetaviraShot = {
  __parents = {"MiscItem"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MiscItem",
  Repairable = false,
  Icon = "UI/Icons/Items/metvira_shot",
  DisplayName = T(704109326715, "Metaviron"),
  DisplayNamePlural = T(736601384762, "Metaviron"),
  Description = T(288596816028, "Miracle cure derived from the sap of the Fallow trees indigenous to the island of Metavira"),
  AdditionalHint = T(532971264222, [[
<bullet_point> Used through the Item Menu
<bullet_point> Single use
<bullet_point> Fully restores lost HP
<bullet_point> Cures all Wounds
]]),
  is_valuable = true,
  effect_moment = "on_use",
  Effects = {
    PlaceObj("HealWounds", {}),
    PlaceObj("RestoreHealth", {})
  },
  action_name = T(509524872124, "USE"),
  destroy_item = true
}
