UndefineClass("_9mm_Tracer")
DefineClass._9mm_Tracer = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/9mm_bullets_tracer",
  DisplayName = T(388936410240, "9 mm Tracer"),
  DisplayNamePlural = T(576279361457, "9 mm Tracer"),
  colorStyle = "AmmoTracerColor",
  Description = T(605716564475, "9 mm ammo for Handguns and SMGs."),
  AdditionalHint = T(527792163999, "<bullet_point> Hit enemies are <em>Exposed</em> and lose the benefits of Cover"),
  MaxStacks = 500,
  Caliber = "9mm",
  AppliedEffects = {"Exposed"}
}
