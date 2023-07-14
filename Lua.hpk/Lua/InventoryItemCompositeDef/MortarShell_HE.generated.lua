UndefineClass("MortarShell_HE")
DefineClass.MortarShell_HE = {
  __parents = {"Ordnance"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ordnance",
  RepairCost = 0,
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Items/mortar_shell_he",
  DisplayName = T(155089126370, "Mortar Cartridge"),
  DisplayNamePlural = T(463883298336, "Mortar Cartridges"),
  Description = T(544846349389, "Explosive Ordnance ammo for Mortars."),
  CenterObjDamageMod = 500,
  AreaOfEffect = 2,
  AreaObjDamageMod = 500,
  PenetrationClass = 4,
  DeathType = "BlowUp",
  Caliber = "MortarShell",
  BaseDamage = 40
}
