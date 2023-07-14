UndefineClass("M16A2")
DefineClass.M16A2 = {
  __parents = {
    "AssaultRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "AssaultRifle",
  Reliability = 80,
  ScrapParts = 10,
  Icon = "UI/Icons/Weapons/M16A2",
  DisplayName = T(943266217115, "M16A2"),
  DisplayNamePlural = T(617921744433, "M16A2s"),
  Description = T(116000725238, "The most iconic firearm of the western world, the M16 introduced the 5.56 NATO cartridge which was made for its 20 inch barrel. It's higher bullet velocity improves accuracy at long range and auto-fire handling, though it has less stopping power than its main rival - the AK-47. Don't ask about the forward assist..."),
  AdditionalHint = T(622886074467, [[
<bullet_point> Increased bonus from Aiming
<bullet_point> Low attack costs
<bullet_point> No Auto firing mode with standard Stock]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  Cost = 1200,
  Caliber = "556",
  Damage = 17,
  AimAccuracy = 6,
  MagazineSize = 30,
  PenetrationClass = 2,
  WeaponRange = 24,
  OverwatchAngle = 1440,
  HandSlot = "TwoHanded",
  Entity = "Weapon_M16A2",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Handguard",
      "Modifiable",
      false,
      "AvailableComponents",
      {
        "M16_Handguard"
      },
      "DefaultComponent",
      "M16_Handguard"
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
        "ReflexSight"
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
      },
      "DefaultComponent",
      "Compensator"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Barrel",
      "Modifiable",
      false,
      "AvailableComponents",
      {
        "BarrelNormal"
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
        "MagNormal",
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
        "GrenadeLauncher_M16A1",
        "VerticalGrip_M16"
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
