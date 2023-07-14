UndefineClass("_50BMG_Incendiary")
DefineClass._50BMG_Incendiary = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/50bmg_incendiary",
  DisplayName = T(727344246325, ".50 Frag"),
  DisplayNamePlural = T(468293090203, ".50 Frag"),
  colorStyle = "AmmoTracerColor",
  Description = T(196314399167, ".50 Ammo for Machine Guns, Snipers and Handguns."),
  AdditionalHint = T(662002010356, [[
<bullet_point> Hit enemies are <em>Exposed</em> and lose the benefits of Cover
<bullet_point> Inflicts <em>Burning</em>]]),
  MaxStacks = 500,
  Caliber = "50BMG",
  Modifications = {},
  AppliedEffects = {"Exposed", "Burning"}
}
