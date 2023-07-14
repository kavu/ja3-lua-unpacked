UndefineClass("MortarShell_Smoke")
DefineClass.MortarShell_Smoke = {
  __parents = {"Ordnance"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ordnance",
  RepairCost = 0,
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Items/mortar_shell_smoke",
  DisplayName = T(725759308030, "Mortar Smoke Cartridge"),
  DisplayNamePlural = T(438787593786, "Mortar Smoke Cartridges"),
  Description = T(497568730512, "Ordnance ammo for Mortars."),
  AdditionalHint = T(890174082428, [[
<bullet_point> Ranged attacks passing through gas become <em>grazing</em> hits
<bullet_point> No damage
<bullet_point> Almost silent]]),
  PenetrationClass = 1,
  BurnGround = false,
  Caliber = "MortarShell",
  BaseDamage = 0,
  Noise = 0,
  aoeType = "smoke"
}
