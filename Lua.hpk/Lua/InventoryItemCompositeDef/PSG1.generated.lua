UndefineClass("PSG1")
DefineClass.PSG1 = {
  __parents = {
    "SniperRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "SniperRifle",
  Reliability = 53,
  ScrapParts = 14,
  Icon = "UI/Icons/Weapons/PSG1",
  DisplayName = T(648722056158, "PSG1"),
  DisplayNamePlural = T(681840099367, "PSG1s"),
  Description = T(938045092300, "Semi-auto precision rifle initially designed for law enforcement after the 1972 Munich Olympics. They skipped adding any iron sights and went straight to a scope. Adjustable buttstock, cheekpiece, trigger unit, and much more. This gun screams \"I can watch this hostage situation all day as I wait for the greenlight\". "),
  AdditionalHint = T(261185171403, "<bullet_point> High Crit chance"),
  LargeItem = true,
  UnitStat = "Marksmanship",
  is_valuable = true,
  Cost = 3200,
  Caliber = "762NATO",
  Damage = 42,
  AimAccuracy = 5,
  CritChanceScaled = 30,
  MagazineSize = 5,
  PenetrationClass = 2,
  WeaponRange = 36,
  OverwatchAngle = 360,
  HandSlot = "TwoHanded",
  Entity = "Weapon_PSG1",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Stock",
      "AvailableComponents",
      {
        "StockNormal",
        "StockHeavy"
      },
      "DefaultComponent",
      "StockNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Bipod",
      "AvailableComponents",
      {"Bipod"}
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Muzzle",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "ImprovisedSuppressor",
        "Suppressor"
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
      "Scope",
      "AvailableComponents",
      {
        "PSG_DefaultScope",
        "LROpticsAdvanced",
        "ReflexSight",
        "ReflexSightAdvanced",
        "ScopeCOG",
        "ScopeCOGQuick",
        "ThermalScope"
      },
      "DefaultComponent",
      "PSG_DefaultScope"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Side",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "FlashlightDot_PSG_M1",
        "Flashlight_PSG_M1",
        "LaserDot_PSG_M1",
        "UVDot_PSG_M1"
      }
    })
  },
  HolsterSlot = "Shoulder",
  PreparedAttackType = "Both",
  AvailableAttacks = {"SingleShot", "CancelShot"},
  ShootAP = 8000,
  ReloadAP = 2000
}
