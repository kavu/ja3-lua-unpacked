UndefineClass("MP5")
DefineClass.MP5 = {
  __parents = {
    "SubmachineGun"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "SubmachineGun",
  Reliability = 85,
  ScrapParts = 8,
  Icon = "UI/Icons/Weapons/MP5",
  DisplayName = T(102009055056, "MP5"),
  DisplayNamePlural = T(104940868512, "MP5s"),
  Description = T(940917162625, "The submachine gun used by most police tactical teams and counter terrorist units. It has seen a lot of action since it was introduced in the sixties, but the 9mm cartridge and the widespread availability of body armor gradually decreased the interest in the MP5. "),
  AdditionalHint = T(160123677864, [[
<bullet_point> Increased bonus from Aiming
<bullet_point> Less noisy]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  Cost = 1600,
  Caliber = "9mm",
  Damage = 16,
  AimAccuracy = 5,
  MagazineSize = 30,
  PointBlankRange = true,
  OverwatchAngle = 1440,
  Noise = 10,
  HandSlot = "TwoHanded",
  Entity = "Weapon_MP5",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Under",
      "Modifiable",
      false,
      "AvailableComponents",
      {
        "MP5_Handguard"
      },
      "DefaultComponent",
      "MP5_Handguard"
    }),
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
      "Stock",
      "AvailableComponents",
      {
        "StockNormal",
        "StockHeavy",
        "StockNo"
      },
      "DefaultComponent",
      "StockNormal"
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
        "FlashlightDot"
      }
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
      "Scope",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "LROptics",
        "ReflexSight",
        "ReflexSightAdvanced",
        "ScopeCOG",
        "ScopeCOGQuick",
        "ThermalScope"
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
        "ImprovisedSuppressor"
      }
    })
  },
  HolsterSlot = "Shoulder",
  AvailableAttacks = {
    "BurstFire",
    "AutoFire",
    "SingleShot",
    "RunAndGun",
    "CancelShot"
  },
  ShootAP = 5000,
  ReloadAP = 3000
}
