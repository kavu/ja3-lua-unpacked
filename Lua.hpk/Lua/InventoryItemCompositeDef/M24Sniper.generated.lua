UndefineClass("M24Sniper")
DefineClass.M24Sniper = {
  __parents = {
    "SniperRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "SniperRifle",
  Reliability = 44,
  ScrapParts = 14,
  Icon = "UI/Icons/Weapons/M24",
  DisplayName = T(672666400702, "M24"),
  DisplayNamePlural = T(703533260621, "M24s"),
  Description = T(767131106202, "US Army sniper weapon system that replaced the M21 (based on the M14). Apparently semi-auto was still not up to par with what snipers needed in terms of reliability and accuracy that bolt action can provide. "),
  AdditionalHint = T(622433882128, [[
<bullet_point> Cumbersome (no Free Move)
<bullet_point> Very noisy]]),
  LargeItem = true,
  Cumbersome = true,
  UnitStat = "Marksmanship",
  Cost = 2500,
  Caliber = "762NATO",
  Damage = 46,
  AimAccuracy = 5,
  MagazineSize = 5,
  PenetrationClass = 2,
  WeaponRange = 36,
  OverwatchAngle = 360,
  Noise = 30,
  HandSlot = "TwoHanded",
  Entity = "Weapon_M24",
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
        "LROptics",
        "LROpticsAdvanced",
        "ReflexSight",
        "ScopeCOG",
        "ThermalScope"
      },
      "DefaultComponent",
      "LROptics"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Muzzle",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {"Suppressor"}
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
        "LaserDot",
        "UVDot"
      }
    })
  },
  HolsterSlot = "Shoulder",
  PreparedAttackType = "Both",
  AvailableAttacks = {"SingleShot", "CancelShot"},
  ShootAP = 8000,
  ReloadAP = 3000
}
