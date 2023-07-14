UndefineClass("ShamanLeggings")
DefineClass.ShamanLeggings = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 4,
  ScrapParts = 6,
  Icon = "UI/Icons/Items/shaman_leggings",
  DisplayName = T(186726197901, "Deathsquad Leggings"),
  DisplayNamePlural = T(652262649255, "Deathsquad Leggings"),
  AdditionalHint = T(526436429985, "<bullet_point> Can't be combined with weave or ceramics"),
  is_valuable = true,
  Slot = "Legs",
  PenetrationClass = 4,
  AdditionalReduction = 40,
  ProtectedBodyParts = set("Groin", "Legs")
}
