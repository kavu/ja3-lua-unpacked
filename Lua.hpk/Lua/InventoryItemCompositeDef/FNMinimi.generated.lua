UndefineClass("FNMinimi")
DefineClass.FNMinimi = {
  __parents = {"MachineGun"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MachineGun",
  RepairCost = 120,
  Reliability = 85,
  ScrapParts = 16,
  Icon = "UI/Icons/Weapons/Minimi",
  DisplayName = T(967860288607, "Minimi"),
  DisplayNamePlural = T(559267255380, "Minimis"),
  Description = T(460196952811, "The 5.56 NATO Minimi is meant to provide squad-level fire support. It does so well that it was adopted by the US military and most people know it as the M249 squad automatic weapon. There is also a Minimi variant firing 7.62 NATO rounds."),
  AdditionalHint = T(262604175263, [[
<bullet_point> Wider attack cone
<bullet_point> Increased bonus from Aiming
<bullet_point> Reduced armor penetration]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  Cost = 2750,
  Caliber = "556",
  Damage = 17,
  AimAccuracy = 4,
  MagazineSize = 100,
  PenetrationClass = 2,
  WeaponRange = 30,
  OverwatchAngle = 2700,
  HandSlot = "TwoHanded",
  Entity = "Weapon_FNMinimi",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Barrel",
      "AvailableComponents",
      {
        "BarrelLong",
        "BarrelLongImproved",
        "BarrelNormal",
        "BarrelNormalImproved",
        "BarrelShort",
        "BarrelShortImproved"
      },
      "DefaultComponent",
      "BarrelNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Bipod",
      "AvailableComponents",
      {"Bipod"},
      "DefaultComponent",
      "Bipod"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Stock",
      "AvailableComponents",
      {
        "StockHeavy",
        "StockNormal"
      },
      "DefaultComponent",
      "StockNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Scope",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "ImprovedIronsight",
        "ReflexSight",
        "ReflexSightAdvanced",
        "LROptics",
        "LROpticsAdvanced",
        "ScopeCOG",
        "ScopeCOGQuick",
        "ThermalScope"
      }
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Magazine",
      "AvailableComponents",
      {"MagNormal", "MagLarge"},
      "DefaultComponent",
      "MagNormal"
    })
  },
  HolsterSlot = "Shoulder",
  PreparedAttackType = "Machine Gun",
  AvailableAttacks = {
    "MGBurstFire"
  },
  ShootAP = 4000,
  ReloadAP = 5000
}
