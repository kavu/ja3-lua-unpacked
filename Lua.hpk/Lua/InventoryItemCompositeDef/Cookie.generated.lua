UndefineClass("Cookie")
DefineClass.Cookie = {
  __parents = {"MiscItem"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MiscItem",
  Icon = "UI/Icons/Items/cookie",
  DisplayName = T(124351111212, "Biscuit"),
  DisplayNamePlural = T(982005397246, "Biscuits"),
  AdditionalHint = T(136230635254, [[
<bullet_point> Used through the Item Menu
<bullet_point> Single use
<bullet_point> Tasty and nutritious]]),
  MaxStacks = 20,
  effect_moment = "on_use",
  Effects = {
    PlaceObj("RechargeCDs", {}),
    PlaceObj("RestoreHealth", {amount = 5})
  },
  action_name = T(646507120531, "EAT"),
  destroy_item = true
}
