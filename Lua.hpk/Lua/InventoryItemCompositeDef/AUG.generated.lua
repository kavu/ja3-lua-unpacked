UndefineClass("AUG")
DefineClass.AUG = {
  __parents = {
    "AssaultRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "AssaultRifle",
  Reliability = 85,
  ScrapParts = 10,
  Icon = "UI/Icons/Weapons/AUG",
  DisplayName = T(803466426440, "AUG"),
  DisplayNamePlural = T(787775409623, "AUGs"),
  Description = T(889588633948, "A bullpup with heavy use of polymer and one of the first to feature integrated optics. Embodying the concept of switching from heavy main battle rifles to assault rifles with the lighter 5.56 NATO cartridge."),
  AdditionalHint = T(141191872728, [[
<bullet_point> Longer range
<bullet_point> Increased bonus from Aiming
<bullet_point> Low attack costs]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  is_valuable = true,
  Cost = 2500,
  Caliber = "556",
  Damage = 19,
  AimAccuracy = 6,
  MagazineSize = 30,
  PenetrationClass = 2,
  WeaponRange = 30,
  OverwatchAngle = 1440,
  HandSlot = "TwoHanded",
  Entity = "Weapon_Steyr",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Barrel",
      "AvailableComponents",
      {
        "BarrelNormal",
        "BarrelShort_AUG",
        "BarrelShortImproved_AUG",
        "BarrelLong_AUG",
        "BarrelLongImproved_AUG"
      },
      "DefaultComponent",
      "BarrelNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Muzzle",
      "AvailableComponents",
      {
        "AUGCompensator_01",
        "AUGCompensator_03",
        "Suppressor"
      },
      "DefaultComponent",
      "AUGCompensator_01"
    }),
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
      "Grenadelauncher",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "GrenadeLauncher_AUG"
      }
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
      "Mount",
      "Modifiable",
      false,
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {"AUGMount"}
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Scope",
      "AvailableComponents",
      {
        "LROptics",
        "LROpticsAdvanced",
        "ThermalScope",
        "ReflexSight",
        "ScopeCOG",
        "AUGScope_Default"
      },
      "DefaultComponent",
      "AUGScope_Default"
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
        "LaserDot"
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
  ShootAP = 5000,
  ReloadAP = 3000
}
