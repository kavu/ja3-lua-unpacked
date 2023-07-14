UndefineClass("HK21")
DefineClass.HK21 = {
  __parents = {"MachineGun"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MachineGun",
  Reliability = 90,
  ScrapParts = 16,
  Icon = "UI/Icons/Weapons/HK21",
  DisplayName = T(250036048846, "HK21"),
  DisplayNamePlural = T(780353222754, "HK21s"),
  Description = T(998703628193, "Combine an assault rifle with a machine gun and you get HK21. Unlike most hybrid guns, it performs each role extremely well."),
  AdditionalHint = T(602989508486, [[
<bullet_point> Increased bonus from Aiming
<bullet_point> Cumbersome (no Free Move)
<bullet_point> Less accurate when fired from the hip]]),
  LargeItem = true,
  Cumbersome = true,
  UnitStat = "Marksmanship",
  is_valuable = true,
  Cost = 3500,
  Caliber = "762NATO",
  Damage = 21,
  AimAccuracy = 6,
  MagazineSize = 120,
  PenetrationClass = 2,
  WeaponRange = 30,
  OverwatchAngle = 1800,
  HandSlot = "TwoHanded",
  Entity = "Weapon_HK21",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Barrel",
      "AvailableComponents",
      {
        "BarrelLong",
        "BarrelLongImproved",
        "BarrelNormal",
        "BarrelNormalImproved",
        "BarrelShort",
        "BarrelShortImproved"
      },
      "DefaultComponent",
      "BarrelNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Muzzle",
      "AvailableComponents",
      {
        "DefaultMuzzle_HK21",
        "MuzzleBooster",
        "Compensator"
      },
      "DefaultComponent",
      "DefaultMuzzle_HK21"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Scope",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "ImprovedIronsight",
        "LROptics",
        "LROpticsAdvanced",
        "ReflexSight",
        "ReflexSightAdvanced",
        "ScopeCOG",
        "ScopeCOGQuick",
        "ThermalScope"
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
        "LaserDot",
        "FlashlightDot",
        "UVDot"
      }
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Stock",
      "AvailableComponents",
      {
        "StockHeavy",
        "StockNormal"
      },
      "DefaultComponent",
      "StockNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Bipod",
      "AvailableComponents",
      {"Bipod"},
      "DefaultComponent",
      "Bipod"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Under",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "TacGrip",
        "VerticalGrip"
      }
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Magazine",
      "AvailableComponents",
      {"MagNormal", "MagLarge"},
      "DefaultComponent",
      "MagNormal"
    })
  },
  HolsterSlot = "Shoulder",
  PreparedAttackType = "Machine Gun",
  AvailableAttacks = {
    "MGBurstFire"
  },
  ShootAP = 4000,
  ReloadAP = 5000
}
