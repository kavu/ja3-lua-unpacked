UndefineClass("_762NATO_Tracer")
DefineClass._762NATO_Tracer = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_nato_bullets_tracer",
  DisplayName = T(236045674209, "7.62 mm NATO Tracer"),
  DisplayNamePlural = T(365178345438, "7.62 mm NATO Tracer"),
  colorStyle = "AmmoTracerColor",
  Description = T(223701622960, "7.62 NATO ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(527792163999, "<bullet_point> Hit enemies are <em>Exposed</em> and lose the benefits of Cover"),
  MaxStacks = 500,
  Caliber = "762NATO",
  Modifications = {},
  AppliedEffects = {"Exposed"}
}
