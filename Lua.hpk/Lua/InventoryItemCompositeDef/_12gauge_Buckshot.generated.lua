UndefineClass("_12gauge_Buckshot")
DefineClass._12gauge_Buckshot = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/12_gauge_bullets_buckshot",
  DisplayName = T(252069434763, "12-gauge Buckshot"),
  DisplayNamePlural = T(227315315032, "12-gauge Buckshot"),
  colorStyle = "AmmoBasicColor",
  Description = T(505402985632, "12-gauge ammo for Shotguns."),
  AdditionalHint = T(104397963477, "<bullet_point> Inflicts <em>Bleeding</em>"),
  MaxStacks = 500,
  Caliber = "12gauge",
  Modifications = {},
  AppliedEffects = {"Bleeding"}
}
