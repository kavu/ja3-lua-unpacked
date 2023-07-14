UndefineClass("LightHelmet_WeavePadding")
DefineClass.LightHelmet_WeavePadding = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 8,
  ScrapParts = 2,
  Icon = "UI/Icons/Items/light_helmet",
  SubIcon = "UI/Icons/Items/padded",
  DisplayName = T(596025389397, "Light Helmet"),
  DisplayNamePlural = T(625172011883, "Light Helmets"),
  AdditionalHint = T(300309914804, "<bullet_point> Damage reduction improved by Weave Padding"),
  Slot = "Head",
  PenetrationClass = 2,
  AdditionalReduction = 30,
  ProtectedBodyParts = set("Head")
}
