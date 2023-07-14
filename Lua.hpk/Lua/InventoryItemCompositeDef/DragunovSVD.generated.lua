UndefineClass("DragunovSVD")
DefineClass.DragunovSVD = {
  __parents = {
    "SniperRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "SniperRifle",
  Reliability = 50,
  ScrapParts = 14,
  Icon = "UI/Icons/Weapons/Dragunov",
  DisplayName = T(204531102680, "Dragunov"),
  DisplayNamePlural = T(663701954106, "Dragunovs"),
  Description = T(925638108776, "Not what it seems at first glance. On the outside it looks like an AK but actually uses a short stroke gas piston system that reduces the recoil and allows for better follow up shots. It is more of a close support designated marksman's rifle than a sniper one. "),
  AdditionalHint = T(907655175705, [[
<bullet_point> Decreased bonus from Aiming
<bullet_point> Very noisy
<bullet_point> Rifle with Burst firing mode]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  Cost = 1750,
  Caliber = "762WP",
  Damage = 36,
  AimAccuracy = 3,
  CritChance = 10,
  CritChanceScaled = 0,
  MagazineSize = 10,
  PenetrationClass = 2,
  WeaponRange = 36,
  OverwatchAngle = 360,
  Noise = 30,
  HandSlot = "TwoHanded",
  Entity = "Weapon_Dragunov",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Stock",
      "AvailableComponents",
      {
        "StockHeavy",
        "StockLight",
        "StockNormal"
      },
      "DefaultComponent",
      "StockNormal"
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
      "Magazine",
      "AvailableComponents",
      {"MagNormal", "MagLarge"},
      "DefaultComponent",
      "MagNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Scope",
      "AvailableComponents",
      {
        "LROptics_DragunovDefault",
        "ReflexSight",
        "ScopeCOG",
        "ThermalScope",
        "LROpticsAdvanced",
        "ReflexSightAdvanced",
        "ScopeCOGQuick"
      },
      "DefaultComponent",
      "LROptics_DragunovDefault"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Muzzle",
      "AvailableComponents",
      {
        "Compensator",
        "Suppressor"
      },
      "DefaultComponent",
      "Compensator"
    })
  },
  HolsterSlot = "Shoulder",
  PreparedAttackType = "Both",
  AvailableAttacks = {
    "SingleShot",
    "BurstFire",
    "CancelShot"
  },
  ShootAP = 8000,
  ReloadAP = 3000
}
