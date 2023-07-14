UndefineClass("PostApoHelmet")
DefineClass.PostApoHelmet = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 40,
  ScrapParts = 2,
  Icon = "UI/Icons/Items/post_apo_helmet",
  DisplayName = T(632051696391, "Shiny and Chrome Helmet"),
  DisplayNamePlural = T(382736672530, "Shiny and Chrome Helmets"),
  AdditionalHint = T(357454576944, [[
<bullet_point> Breaks VERY often
<bullet_point> Mad to the Max]]),
  is_valuable = true,
  Slot = "Head",
  PenetrationClass = 4,
  AdditionalReduction = 40,
  ProtectedBodyParts = set("Head")
}
