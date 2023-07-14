UndefineClass("_9mm_Subsonic")
DefineClass._9mm_Subsonic = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/9mm_bullets_subsonic",
  DisplayName = T(416825324724, "9 mm Subsonic"),
  DisplayNamePlural = T(676522769844, "9 mm Subsonic"),
  colorStyle = "AmmoMatchColor",
  Description = T(571319448676, "9 mm ammo for Handguns and SMGs."),
  AdditionalHint = T(368177980365, "<bullet_point> Less noisy"),
  MaxStacks = 500,
  Caliber = "9mm",
  Modifications = {
    PlaceObj("CaliberModification", {mod_mul = 500, target_prop = "Noise"})
  }
}
