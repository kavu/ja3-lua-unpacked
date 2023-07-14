UndefineClass("M4Commando")
DefineClass.M4Commando = {
  __parents = {
    "SubmachineGun"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "SubmachineGun",
  Reliability = 80,
  ScrapParts = 10,
  Icon = "UI/Icons/Weapons/Commando",
  DisplayName = T(106857539418, "Commando"),
  DisplayNamePlural = T(434250307019, "Commandos"),
  Description = T(346391822201, "How would you make a short barrel M16 work? Answer - lower muzzle velocity and huge muzzle flash."),
  AdditionalHint = T(679443019604, [[
<bullet_point> High Crit chance
<bullet_point> Increased bonus from Aiming]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  is_valuable = true,
  Cost = 2700,
  Caliber = "556",
  Damage = 17,
  AimAccuracy = 4,
  CritChanceScaled = 30,
  MagazineSize = 30,
  PenetrationClass = 2,
  PointBlankRange = true,
  OverwatchAngle = 1440,
  Noise = 15,
  HandSlot = "TwoHanded",
  Entity = "Weapon_CAR15",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Under",
      "AvailableComponents",
      {
        "Handguard_Commando",
        "VerticalGrip_Commando",
        "GrenadeLauncher_Commando"
      },
      "DefaultComponent",
      "Handguard_Commando"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Magazine",
      "AvailableComponents",
      {
        "MagNormal",
        "MagNormalFine",
        "MagLarge",
        "MagLargeFine",
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
        "LROptics",
        "ReflexSight",
        "ScopeCOG",
        "ThermalScope",
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
        "Suppressor",
        "ImprovisedSuppressor"
      },
      "DefaultComponent",
      "Compensator"
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
