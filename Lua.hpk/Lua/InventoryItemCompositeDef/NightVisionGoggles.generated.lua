UndefineClass("NightVisionGoggles")
DefineClass.NightVisionGoggles = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 12,
  ScrapParts = 2,
  Icon = "UI/Icons/Items/night_vision",
  DisplayName = T(263962000489, "Night Vision Goggles"),
  DisplayNamePlural = T(940518526415, "Night Vision Goggles"),
  AdditionalHint = T(544752534188, [[
<bullet_point> Reduced penalties to Accuracy at Night and in underground Sectors
<bullet_point> Does not stack with the Night Ops perk
<bullet_point> Can't be combined with weave or ceramics]]),
  Slot = "Head",
  DamageReduction = 0,
  AdditionalReduction = 0,
  ProtectedBodyParts = set("Head")
}
