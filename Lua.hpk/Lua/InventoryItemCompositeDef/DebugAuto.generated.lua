UndefineClass("DebugAuto")
DefineClass.DebugAuto = {
  __parents = {
    "AssaultRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "AssaultRifle",
  RepairCost = 20,
  Reliability = 95,
  ScrapParts = 10,
  Icon = "UI/Icons/Weapons/AK47",
  DisplayName = T(396889236298, "Debug Gun"),
  DisplayNamePlural = T(343215376565, "Debug Guns"),
  LargeItem = true,
  Cost = 800,
  Caliber = "762WP",
  Damage = 10,
  MagazineSize = 30,
  PenetrationClass = 2,
  WeaponRange = 24,
  OverwatchAngle = 1440,
  HandSlot = "TwoHanded",
  Entity = "Weapon_AK47",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Bipod",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {"Bipod"}
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Grenadelauncher",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "AK47_Launcher"
      }
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Stock",
      "AvailableComponents",
      {
        "StockNormal",
        "StockLight",
        "StockBump",
        "StockHeavy"
      },
      "DefaultComponent",
      "StockNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Magazine",
      "AvailableComponents",
      {
        "MagNormal",
        "MagLarge",
        "MagQuick",
        "MagNormalFine",
        "MagLargeFine"
      },
      "DefaultComponent",
      "MagNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Handguard",
      "AvailableComponents",
      {
        "AK47_VerticalGrip",
        "AK47_Handguard_basic",
        "AK47_TacGrip"
      },
      "DefaultComponent",
      "AK47_Handguard_basic"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Scope",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "LROptics",
        "ReflexSight",
        "ScopeCOG",
        "ThermalScope",
        "ImprovedIronsight",
        "LROpticsAdvanced",
        "ReflexSightAdvanced",
        "ScopeCOGQuick"
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
        "MuzzleBooster",
        "Suppressor"
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
      "Barrel",
      "AvailableComponents",
      {
        "BarrelHeavy",
        "BarrelLong",
        "BarrelLongImproved",
        "BarrelNormal",
        "BarrelNormalImproved",
        "BarrelShort"
      }
    })
  },
  AvailableAttacks = {
    "BurstFire",
    "SingleShot",
    "AutoFire"
  },
  ShootAP = 6000,
  ReloadAP = 3000
}
