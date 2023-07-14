UndefineClass("ColtAnaconda")
DefineClass.ColtAnaconda = {
  __parents = {"Revolver"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Revolver",
  RepairCost = 30,
  Reliability = 95,
  ScrapParts = 8,
  Icon = "UI/Icons/Weapons/Anaconda",
  DisplayName = T(769922391034, "Anaconda"),
  DisplayNamePlural = T(505981904083, "Anacondas"),
  Description = T(472163591080, "Double-action revolver with a swing out cylinder. High reliability and stopping power shot after shot. "),
  AdditionalHint = T(869405276287, [[
<bullet_point> Improved armor penetration
<bullet_point> Increased bonus from Aiming
<bullet_point> Slower Condition loss]]),
  UnitStat = "Marksmanship",
  is_valuable = true,
  Cost = 1800,
  Caliber = "44CAL",
  Damage = 24,
  AimAccuracy = 5,
  MagazineSize = 6,
  PenetrationClass = 2,
  PointBlankRange = true,
  OverwatchAngle = 2160,
  Entity = "Weapon_ColtAnaconda44",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Barrel",
      "AvailableComponents",
      {
        "BarrelLong",
        "BarrelNormal",
        "BarrelShort"
      },
      "DefaultComponent",
      "BarrelNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Scope",
      "AvailableComponents",
      {
        "BaseIronsight_Anaconda",
        "ImprovedIronsight",
        "ReflexSight",
        "ReflexSightAdvanced",
        "ScopeCOG",
        "ScopeCOGQuick",
        "LaserDot_Anaconda",
        "FlashlightDot_Anaconda",
        "UVDot_Anaconda"
      },
      "DefaultComponent",
      "BaseIronsight_Anaconda"
    })
  },
  HolsterSlot = "Leg",
  AvailableAttacks = {
    "SingleShot",
    "DualShot",
    "CancelShot",
    "MobileShot"
  },
  ShootAP = 5000,
  ReloadAP = 3000
}
