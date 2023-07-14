UndefineClass("ShamanTorso")
DefineClass.ShamanTorso = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 4,
  ScrapParts = 6,
  Icon = "UI/Icons/Items/shaman_armor",
  DisplayName = T(933844003190, "Deathsquad Armor"),
  DisplayNamePlural = T(345511615742, "Deathsquad Armors"),
  AdditionalHint = T(960658212530, "<bullet_point> Can't be combined with weave or ceramics"),
  is_valuable = true,
  PenetrationClass = 4,
  AdditionalReduction = 40,
  ProtectedBodyParts = set("Arms", "Torso")
}
