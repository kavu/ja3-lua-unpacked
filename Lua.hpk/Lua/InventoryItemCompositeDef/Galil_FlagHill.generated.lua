UndefineClass("Galil_FlagHill")
DefineClass.Galil_FlagHill = {
  __parents = {
    "AssaultRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "AssaultRifle",
  RepairCost = 50,
  Reliability = 77,
  ScrapParts = 10,
  Icon = "UI/Icons/Weapons/Galil_Flaghill",
  DisplayName = T(167758773926, "The Hired Gun"),
  DisplayNamePlural = T(887498877657, "The Hired Guns"),
  Description = T(503430285250, "Mercenary contract termination tool."),
  AdditionalHint = T(112848820358, [[
<bullet_point> Awesome Crit chance
<bullet_point> Longer range]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  is_valuable = true,
  Cost = 2500,
  Caliber = "762NATO",
  Damage = 26,
  CritChanceScaled = 50,
  MagazineSize = 30,
  PenetrationClass = 2,
  WeaponRange = 30,
  OverwatchAngle = 1440,
  HandSlot = "TwoHanded",
  Entity = "Weapon_Galil",
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
      "Stock",
      "Modifiable",
      false,
      "AvailableComponents",
      {
        "StockNormal"
      },
      "DefaultComponent",
      "StockNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Muzzle",
      "Modifiable",
      false,
      "AvailableComponents",
      {
        "MuzzleBooster"
      },
      "DefaultComponent",
      "MuzzleBooster"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Under",
      "Modifiable",
      false,
      "AvailableComponents",
      {
        "Bipod_Galil"
      },
      "DefaultComponent",
      "Bipod_Galil"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Scope",
      "Modifiable",
      false,
      "AvailableComponents",
      {
        "ReflexSightAdvanced"
      },
      "DefaultComponent",
      "ReflexSightAdvanced"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Magazine",
      "Modifiable",
      false,
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
  ShootAP = 6000,
  ReloadAP = 3000
}
