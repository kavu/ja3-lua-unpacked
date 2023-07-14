UndefineClass("DoubleBarrelShotgun")
DefineClass.DoubleBarrelShotgun = {
  __parents = {"Shotgun"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Shotgun",
  RepairCost = 50,
  Reliability = 50,
  ScrapParts = 8,
  Icon = "UI/Icons/Weapons/Double-barrelled Shotgun",
  DisplayName = T(354097123587, "Double-Barrel"),
  DisplayNamePlural = T(178360690641, "Double-Barrels"),
  Description = T(563332952231, "A simple hunting weapon. Fancier combat shotguns can shoot semi and fully automatic but only the double-barrel can shoot two shells at once. "),
  AdditionalHint = T(345329597555, [[
<bullet_point> High Crit chance
<bullet_point> Limited ammo capacity
<bullet_point> Greatly decreased bonus from Aiming
<bullet_point> Special firing mode: Double Barrel]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  Cost = 700,
  Caliber = "12gauge",
  Damage = 28,
  ObjDamageMod = 150,
  AimAccuracy = 1,
  CritChanceScaled = 30,
  MagazineSize = 2,
  WeaponRange = 8,
  PointBlankRange = true,
  OverwatchAngle = 1200,
  BuckshotConeAngle = 1200,
  HandSlot = "TwoHanded",
  Entity = "Weapon_DBShotgun",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Barrel",
      "AvailableComponents",
      {
        "BarrelLongShotgun",
        "BarrelNormal",
        "BarrelShortShotgun"
      },
      "DefaultComponent",
      "BarrelNormal"
    })
  },
  HolsterSlot = "Shoulder",
  ModifyRightHandGrip = true,
  AvailableAttacks = {
    "Buckshot",
    "DoubleBarrel",
    "CancelShotCone"
  },
  ShootAP = 5000,
  ReloadAP = 3000
}
