UndefineClass("ShamanHelmet")
DefineClass.ShamanHelmet = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 4,
  ScrapParts = 6,
  Icon = "UI/Icons/Items/shaman_helmet",
  DisplayName = T(710411844643, "Deathsquad Helmet"),
  DisplayNamePlural = T(722747917523, "Deathsquad Helmets"),
  AdditionalHint = T(265230607158, "<bullet_point> Can't be combined with weave or ceramics"),
  is_valuable = true,
  Slot = "Head",
  PenetrationClass = 4,
  AdditionalReduction = 40,
  ProtectedBodyParts = set("Head")
}
