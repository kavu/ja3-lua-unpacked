UndefineClass("G36")
DefineClass.G36 = {
  __parents = {
    "AssaultRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "AssaultRifle",
  Reliability = 90,
  ScrapParts = 10,
  Icon = "UI/Icons/Weapons/G36",
  DisplayName = T(675182711489, "G36"),
  DisplayNamePlural = T(349971410946, "G36s"),
  Description = T(511176251955, "Futuristic assault rifle with an integrated dual combat sighting system. The 5.56 NATO cartridge combined with the short-stroke gas piston system make this a joy to shoot."),
  AdditionalHint = T(720286229624, [[
<bullet_point> Longer range
<bullet_point> Increased bonus from Aiming
<bullet_point> Low attack costs]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  is_valuable = true,
  Cost = 4000,
  Caliber = "556",
  Damage = 22,
  AimAccuracy = 6,
  MagazineSize = 30,
  PenetrationClass = 2,
  WeaponRange = 30,
  PointBlankRange = true,
  OverwatchAngle = 1440,
  HandSlot = "TwoHanded",
  Entity = "Weapon_HKG36",
  fxClass = "G36",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Barrel",
      "AvailableComponents",
      {
        "BarrelNormal",
        "BarrelLong"
      },
      "DefaultComponent",
      "BarrelNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Scope",
      "AvailableComponents",
      {
        "ScopeCOG",
        "LROptics",
        "ThermalScope",
        "ReflexSightAdvanced"
      },
      "DefaultComponent",
      "ScopeCOG"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Muzzle",
      "AvailableComponents",
      {
        "Compensator",
        "Suppressor",
        "ImprovisedSuppressor"
      },
      "DefaultComponent",
      "Compensator"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Magazine",
      "AvailableComponents",
      {
        "MagNormal",
        "MagLarge",
        "MagQuick"
      },
      "DefaultComponent",
      "MagNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Under",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "TacGrip",
        "VerticalGrip",
        "GrenadeLauncher"
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
      "Stock",
      "AvailableComponents",
      {
        "StockNormal",
        "StockFolded",
        "StockHeavy"
      },
      "DefaultComponent",
      "StockNormal"
    })
  },
  Color = "Black",
  HolsterSlot = "Shoulder",
  AvailableAttacks = {
    "BurstFire",
    "AutoFire",
    "SingleShot",
    "CancelShot"
  },
  ShootAP = 5000,
  ReloadAP = 3000
}
