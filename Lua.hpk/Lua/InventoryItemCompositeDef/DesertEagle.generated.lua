UndefineClass("DesertEagle")
DefineClass.DesertEagle = {
  __parents = {"Pistol"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Pistol",
  RepairCost = 70,
  Reliability = 20,
  ScrapParts = 10,
  Icon = "UI/Icons/Weapons/DesertEagle",
  DisplayName = T(275314808651, "Desert Eagle"),
  DisplayNamePlural = T(975125699386, "Desert Eagles"),
  Description = T(587004777006, "Everybody knows the Desert Eagle as a .50 caliber hand cannon but the .44 barrel can make it much more practical and affordable to shoot. "),
  AdditionalHint = T(883485222965, [[
<bullet_point> High damage
<bullet_point> Improved armor penetration
<bullet_point> Shorter range
<bullet_point> Very noisy]]),
  UnitStat = "Marksmanship",
  is_valuable = true,
  Cost = 3000,
  Caliber = "44CAL",
  Damage = 30,
  ObjDamageMod = 200,
  AimAccuracy = 3,
  MagazineSize = 15,
  PenetrationClass = 2,
  WeaponRange = 12,
  PointBlankRange = true,
  OverwatchAngle = 2160,
  Entity = "Weapon_DesertEagle",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Scope",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "ReflexSight",
        "ReflexSightAdvanced",
        "ImprovedIronsight"
      }
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
      "Barrel",
      "AvailableComponents",
      {
        "BarrelLong",
        "BarrelNormal",
        "Barrel50BMG_DesertEagle"
      },
      "DefaultComponent",
      "BarrelNormal"
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
        "FlashlightDot",
        "Flashlight",
        "LaserDot",
        "UVDot"
      }
    })
  },
  HolsterSlot = "Leg",
  AvailableAttacks = {
    "SingleShot",
    "DualShot",
    "CancelShot",
    "MobileShot"
  },
  ShootAP = 5000,
  ReloadAP = 3000
}
