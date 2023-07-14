UndefineClass("Glock18")
DefineClass.Glock18 = {
  __parents = {"Pistol"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Pistol",
  RepairCost = 70,
  Reliability = 80,
  ScrapParts = 6,
  Icon = "UI/Icons/Weapons/Glock18",
  DisplayName = T(477797896110, "Glock 18"),
  DisplayNamePlural = T(137749552678, "Glock 18s"),
  Description = T(108518776488, "Glock 17 with a fun switch and built in compensator. 9x19mm spray in the palm of your hand. "),
  AdditionalHint = T(621603847984, "<bullet_point> Special Burst firing mode - 4 bullets"),
  UnitStat = "Marksmanship",
  Cost = 1500,
  Caliber = "9mm",
  Damage = 15,
  AimAccuracy = 4,
  MagazineSize = 15,
  WeaponRange = 14,
  PointBlankRange = true,
  OverwatchAngle = 2160,
  Entity = "Weapon_Glock18",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Scope",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "ReflexSight",
        "ReflexSightAdvanced_Glock",
        "ImprovedIronsight"
      }
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Muzzle",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "ImprovisedSuppressor",
        "Suppressor",
        "Compensator_Glock"
      }
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Handguard",
      "Modifiable",
      false,
      "AvailableComponents",
      {
        "MuzzleBooster_Glock18"
      },
      "DefaultComponent",
      "MuzzleBooster_Glock18"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Magazine",
      "AvailableComponents",
      {"MagLarge", "MagNormal"},
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
    })
  },
  HolsterSlot = "Leg",
  AvailableAttacks = {
    "BurstFire",
    "SingleShot",
    "DualShot",
    "CancelShot",
    "MobileShot"
  },
  ShootAP = 5000,
  ReloadAP = 3000
}
