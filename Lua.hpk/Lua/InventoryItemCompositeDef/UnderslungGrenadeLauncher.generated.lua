UndefineClass("UnderslungGrenadeLauncher")
DefineClass.UnderslungGrenadeLauncher = {
  __parents = {
    "GrenadeLauncher"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "GrenadeLauncher",
  Reliability = 98,
  Caliber = "40mmGrenade",
  AttackAP = 4000,
  Icon = "UI/Icons/Upgrades/m16_grenade_launcher",
  DisplayName = T(204366158384, "Underslung Launcher"),
  DisplayNamePlural = T(668594626073, "Underslung Launchers"),
  LargeItem = true,
  UnitStat = "Explosives",
  is_valuable = true,
  Cost = 5000,
  CritChanceScaled = 0,
  PenetrationClass = 4,
  WeaponRange = 45,
  HandSlot = "TwoHanded",
  fxClass = "MGL",
  PreparedAttackType = "None",
  ShootAP = 4000,
  ReloadAP = 3000
}
