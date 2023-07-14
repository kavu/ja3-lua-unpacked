UndefineClass("FAMAS")
DefineClass.FAMAS = {
  __parents = {
    "AssaultRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "AssaultRifle",
  Reliability = 70,
  ScrapParts = 10,
  Icon = "UI/Icons/Weapons/FAMAS",
  DisplayName = T(535915752603, "FAMAS"),
  DisplayNamePlural = T(468242262916, "FAMAS's"),
  Description = T(782243912175, "Bullpup design with utility and ergonomics in mind. The magazines were designed to be single-use and disposable. But no design survives contact with reality - soldiers started reusing them and running into all sorts of problems. A durable mag was later introduced. "),
  AdditionalHint = T(313092155901, [[
<bullet_point> Low damage
<bullet_point> Increased bonus from Aiming
<bullet_point> Low attack costs
<bullet_point> Increased Reload cost
<bullet_point> Less noisy]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  Cost = 800,
  Caliber = "556",
  Damage = 16,
  AimAccuracy = 4,
  MagazineSize = 25,
  PenetrationClass = 2,
  WeaponRange = 24,
  OverwatchAngle = 1440,
  Noise = 10,
  HandSlot = "TwoHanded",
  Entity = "Weapon_FAMAS",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Under",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "VerticalGrip"
      }
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
      "Scope",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "LROptics",
        "ReflexSight",
        "ScopeCOGQuick",
        "ScopeCOG",
        "ThermalScope"
      }
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
      "Modifiable",
      false,
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {"MagNormal"},
      "DefaultComponent",
      "MagNormal"
    })
  },
  HolsterSlot = "Shoulder",
  AvailableAttacks = {
    "BurstFire",
    "AutoFire",
    "SingleShot",
    "CancelShot"
  },
  ShootAP = 5000,
  ReloadAP = 4000
}
