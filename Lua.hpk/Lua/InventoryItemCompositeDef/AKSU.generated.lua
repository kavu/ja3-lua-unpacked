UndefineClass("AKSU")
DefineClass.AKSU = {
  __parents = {
    "SubmachineGun"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "SubmachineGun",
  RepairCost = 50,
  Reliability = 80,
  ScrapParts = 10,
  Icon = "UI/Icons/Weapons/AKSU",
  DisplayName = T(128744593633, "AK-SU"),
  DisplayNamePlural = T(897934363658, "AK-SUs"),
  Description = T(371210514910, "Short versions of the AK-74 intended for Spec Ops and vehicle crew personal defense. It needed a custom gas block and muzzle booster to work properly. Americans call it Krinkov but Russians have a more intimate nickname - Ksyukha or sometimes Suchka. And yes, there is a thigh holster for it. "),
  AdditionalHint = T(293511122593, "<bullet_point> High damage"),
  LargeItem = true,
  UnitStat = "Marksmanship",
  is_valuable = true,
  Cost = 2250,
  Caliber = "762WP",
  Damage = 20,
  CritChanceScaled = 20,
  MagazineSize = 30,
  PenetrationClass = 2,
  PointBlankRange = true,
  OverwatchAngle = 1440,
  Noise = 15,
  HandSlot = "TwoHanded",
  Entity = "Weapon_AKS74U",
  ComponentSlots = {
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
      "Handguard",
      "AvailableComponents",
      {
        "AKSU_Hanguard_Basic",
        "AKSU_VerticalGrip"
      },
      "DefaultComponent",
      "AKSU_Hanguard_Basic"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Magazine",
      "AvailableComponents",
      {
        "MagNormal",
        "MagNormalFine",
        "MagLarge",
        "MagQuick",
        "MagLargeFine"
      },
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
      "AvailableComponents",
      {
        "Compensator",
        "MuzzleBooster",
        "Suppressor",
        "ImprovisedSuppressor"
      },
      "DefaultComponent",
      "MuzzleBooster"
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
