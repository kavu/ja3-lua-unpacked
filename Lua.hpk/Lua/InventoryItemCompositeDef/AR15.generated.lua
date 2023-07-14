UndefineClass("AR15")
DefineClass.AR15 = {
  __parents = {
    "AssaultRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "AssaultRifle",
  Reliability = 80,
  ScrapParts = 10,
  Icon = "UI/Icons/Weapons/AR15",
  DisplayName = T(532039127176, "AR-15"),
  DisplayNamePlural = T(685781028407, "AR-15s"),
  Description = T(436294294475, "Created to ensure the highest constitutional rights of self-defense and the possibility to bear a weapon that's easy as hell to convert to a fully-automatic one because a law-abiding citizen always needs one."),
  AdditionalHint = T(387507453824, [[
<bullet_point> High Crit chance
<bullet_point> Low attack costs
<bullet_point> Highly modifiable
<bullet_point> No Auto firing mode with standard Stock]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  Cost = 1800,
  Caliber = "556",
  Damage = 17,
  AimAccuracy = 4,
  CritChanceScaled = 30,
  MagazineSize = 30,
  PenetrationClass = 2,
  WeaponRange = 24,
  OverwatchAngle = 1440,
  HandSlot = "TwoHanded",
  Entity = "Weapon_AR15",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Scope",
      "AvailableComponents",
      {
        "ScopeCOG",
        "LROptics",
        "LROpticsAdvanced",
        "ThermalScope",
        "ReflexSight",
        "DefaultIronsight_AR15",
        "ImprovedIronsight_AR15"
      },
      "DefaultComponent",
      "DefaultIronsight_AR15"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Magazine",
      "AvailableComponents",
      {
        "MagNormal",
        "MagNormalFine",
        "MagLarge",
        "MagLargeFine",
        "MagQuick"
      },
      "DefaultComponent",
      "MagNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Barrel",
      "AvailableComponents",
      {
        "BarrelNormal",
        "BarrelNormalImproved",
        "BarrelShort",
        "BarrelShortImproved",
        "BarrelLong",
        "BarrelLongImproved"
      },
      "DefaultComponent",
      "BarrelNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Stock",
      "AvailableComponents",
      {
        "StockHeavy_AR_BurstOnly",
        "StockLight_AR_BurstOnly",
        "StockBump"
      },
      "DefaultComponent",
      "StockHeavy_AR_BurstOnly"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Under",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "GrenadeLauncher",
        "VerticalGrip",
        "TacGrip"
      }
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Side",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "Flashlight",
        "FlashlightDot",
        "LaserDot",
        "UVDot"
      }
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Muzzle",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "Compensator",
        "ImprovisedSuppressor",
        "Suppressor",
        "MuzzleBooster"
      },
      "DefaultComponent",
      "Compensator"
    })
  },
  HolsterSlot = "Shoulder",
  AvailableAttacks = {
    "BurstFire",
    "SingleShot",
    "CancelShot"
  },
  ShootAP = 5000,
  ReloadAP = 3000
}
