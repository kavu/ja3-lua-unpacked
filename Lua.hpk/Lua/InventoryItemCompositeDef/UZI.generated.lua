UndefineClass("UZI")
DefineClass.UZI = {
  __parents = {
    "SubmachineGun"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "SubmachineGun",
  Reliability = 75,
  ScrapParts = 6,
  Icon = "UI/Icons/Weapons/UZI",
  DisplayName = T(412998767677, "UZI"),
  DisplayNamePlural = T(516476240554, "UZIs"),
  Description = T(923965701752, "Designed as a personal defense weapon for rear echelon troops in the Israel Defense Forces. Intended to be used with a buttstock, but regularly wielded one-handed. Can deliver a lot of lead though accuracy may vary. "),
  AdditionalHint = T(888623247089, [[
<bullet_point> Decreased bonus from Aiming
<bullet_point> Less noisy
<bullet_point> Firing Modes: Burst, Auto]]),
  UnitStat = "Marksmanship",
  Cost = 1200,
  Caliber = "9mm",
  Damage = 15,
  MagazineSize = 30,
  PointBlankRange = true,
  OverwatchAngle = 1440,
  Noise = 10,
  Entity = "Weapon_Uzi",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Barrel",
      "AvailableComponents",
      {
        "BarrelNormal",
        "BarrelNormalImproved",
        "BarrelLong",
        "BarrelLongImproved"
      },
      "DefaultComponent",
      "BarrelNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Magazine",
      "AvailableComponents",
      {"MagNormal", "MagLarge"},
      "DefaultComponent",
      "MagNormal"
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
      "Magazine",
      "AvailableComponents",
      {
        "MagNormal",
        "MagLarge",
        "MagLargeFine",
        "MagNormalFine"
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
        "Suppressor"
      }
    })
  },
  HolsterSlot = "Leg",
  AvailableAttacks = {
    "BurstFire",
    "AutoFire",
    "SingleShot",
    "DualShot",
    "RunAndGun",
    "CancelShot"
  },
  ShootAP = 5000,
  ReloadAP = 3000
}
