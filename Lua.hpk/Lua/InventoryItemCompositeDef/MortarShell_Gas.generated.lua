UndefineClass("MortarShell_Gas")
DefineClass.MortarShell_Gas = {
  __parents = {"Ordnance"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ordnance",
  RepairCost = 0,
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Items/mortar_shell_gas",
  DisplayName = T(695814790332, "Mortar Gas Cartridge"),
  DisplayNamePlural = T(485162600133, "Mortar Gas Cartridges"),
  Description = T(866167485518, "Ordnance ammo for Mortars."),
  AdditionalHint = T(789422211618, [[
<bullet_point> Inflicts <em>Choking</em>
<bullet_point> Ranged attacks passing through gas become Grazing hits
<bullet_point> Almost silent]]),
  PenetrationClass = 1,
  BurnGround = false,
  Caliber = "MortarShell",
  BaseDamage = 0,
  Noise = 0,
  aoeType = "toxicgas"
}
