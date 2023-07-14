UndefineClass("MP5K")
DefineClass.MP5K = {
  __parents = {
    "SubmachineGun"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "SubmachineGun",
  Reliability = 85,
  ScrapParts = 8,
  Icon = "UI/Icons/Weapons/MP5K",
  DisplayName = T(271982946642, "MP5K"),
  DisplayNamePlural = T(879832194807, "MP5Ks"),
  Description = T(254086057863, "Brutally short MP5 designed for close quarters engagements and personal defense. There is even a suitcase with a trigger on the handle for covert escort jobs."),
  AdditionalHint = T(261800415516, [[
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
      "AvailableComponents",
      {
        "VerticalGrip"
      },
      "DefaultComponent",
      "VerticalGrip"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Barrel",
      "AvailableComponents",
      {
        "BarrelShort"
      },
      "DefaultComponent",
      "BarrelShort"
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
      "StockNo"
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
      "Scope",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "ReflexSight",
        "ReflexSightAdvanced",
        "ScopeCOG",
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
        "Suppressor",
        "ImprovisedSuppressor"
      }
    })
  },
  HolsterSlot = "Leg",
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
