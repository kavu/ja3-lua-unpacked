UndefineClass("BrowningM2HMG")
DefineClass.BrowningM2HMG = {
  __parents = {"MachineGun"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MachineGun",
  Reliability = 80,
  ScrapParts = 20,
  Icon = "UI/Icons/Weapons/M2Browning",
  DisplayName = T(178371122439, "M2 Browning"),
  DisplayNamePlural = T(472976044430, "M2 Brownings"),
  Description = T(706172423918, "When you're a dime short of buying some tank ordnance but you won't make a compromise with power."),
  AdditionalHint = T(608086437081, [[
<bullet_point> Stationary weapon
<bullet_point> Very high damage
<bullet_point> Very noisy]]),
  LargeItem = true,
  Cumbersome = true,
  UnitStat = "Marksmanship",
  Cost = 4200,
  Caliber = "50BMG",
  Damage = 30,
  MagazineSize = 100,
  PenetrationClass = 3,
  WeaponRange = 30,
  OverwatchAngle = 3600,
  Noise = 30,
  HandSlot = "TwoHanded",
  Entity = "Weapon_M2Browning",
  ComponentSlots = {},
  HolsterSlot = "Shoulder",
  PreparedAttackType = "Machine Gun",
  AvailableAttacks = {
    "MGBurstFire"
  },
  ShootAP = 4000,
  ReloadAP = 6000
}
