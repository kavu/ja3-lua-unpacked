UndefineClass("FNFAL")
DefineClass.FNFAL = {
  __parents = {
    "AssaultRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "AssaultRifle",
  Reliability = 50,
  ScrapParts = 10,
  Icon = "UI/Icons/Weapons/FNFAL",
  DisplayName = T(291629379642, "FN-FAL"),
  DisplayNamePlural = T(103102569939, "FN-FALs"),
  Description = T(600961576283, "Often described as the Right Arm of the Free World, it delivers pure Democracy in volleys!"),
  AdditionalHint = T(869035575847, [[
<bullet_point> High damage
<bullet_point> Faster Condition loss]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  is_valuable = true,
  Cost = 1800,
  Caliber = "762NATO",
  Damage = 30,
  MagazineSize = 30,
  PenetrationClass = 2,
  WeaponRange = 24,
  OverwatchAngle = 1440,
  HandSlot = "TwoHanded",
  Entity = "Weapon_FNFAL",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Handguard",
      "Modifiable",
      false,
      "AvailableComponents",
      {
        "FNFAL_Handguard"
      },
      "DefaultComponent",
      "FNFAL_Handguard"
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
      "Scope",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "ScopeCOG",
        "ScopeCOGQuick",
        "LROptics",
        "ThermalScope",
        "ReflexSight",
        "ReflexSightAdvanced"
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
        "Suppressor",
        "ImprovisedSuppressor",
        "MuzzleBooster"
      }
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Magazine",
      "AvailableComponents",
      {
        "MagNormal",
        "MagNormalFine",
        "MagLarge",
        "MagLargeFine"
      },
      "DefaultComponent",
      "MagNormal"
    }),
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
      "Barrel",
      "AvailableComponents",
      {
        "BarrelNormal",
        "BarrelNormalImproved",
        "BarrelHeavy",
        "BarrelLong",
        "BarrelLongImproved",
        "BarrelShort",
        "BarrelShortImproved"
      },
      "DefaultComponent",
      "BarrelNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Magazine",
      "AvailableComponents",
      {
        "MagLarge",
        "MagLargeFine",
        "MagNormal",
        "MagNormalFine"
      },
      "DefaultComponent",
      "MagNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Stock",
      "AvailableComponents",
      {
        "StockNormal",
        "StockHeavy",
        "StockLight"
      },
      "DefaultComponent",
      "StockNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Under",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "GrenadeLauncher",
        "TacGrip",
        "VerticalGrip"
      }
    })
  },
  HolsterSlot = "Shoulder",
  AvailableAttacks = {
    "BurstFire",
    "AutoFire",
    "SingleShot",
    "CancelShot"
  },
  ShootAP = 6000,
  ReloadAP = 3000
}
