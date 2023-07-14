UndefineClass("HiPower")
DefineClass.HiPower = {
  __parents = {"Pistol"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Pistol",
  RepairCost = 70,
  Reliability = 50,
  ScrapParts = 6,
  Icon = "UI/Icons/Weapons/Browning HiPower",
  DisplayName = T(796605924344, "Hi-Power"),
  DisplayNamePlural = T(376748831554, "Hi-Powers"),
  Description = T(718446064072, "Used by both the Nazis and Allies during WWII. The hammer has a tendency to bite. "),
  AdditionalHint = T(583470356503, [[
<bullet_point> High damage
<bullet_point> Decreased bonus from Aiming
<bullet_point> Limited customization options]]),
  UnitStat = "Marksmanship",
  Cost = 500,
  Caliber = "9mm",
  Damage = 18,
  MagazineSize = 15,
  WeaponRange = 14,
  PointBlankRange = true,
  OverwatchAngle = 2160,
  Entity = "Weapon_Browning_HP",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Muzzle",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "ImprovisedSuppressor",
        "Suppressor",
        "Compensator"
      }
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Magazine",
      "AvailableComponents",
      {
        "MagLarge",
        "MagNormal",
        "MagLargeFine",
        "MagNormalFine"
      },
      "DefaultComponent",
      "MagNormal"
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Barrel",
      "AvailableComponents",
      {
        "BarrelNormal",
        "BarrelNormalImproved",
        "BarrelShort",
        "BarrelShortImproved",
        "BarrelLong",
        "BarrelLongImproved"
      },
      "DefaultComponent",
      "BarrelNormal"
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
