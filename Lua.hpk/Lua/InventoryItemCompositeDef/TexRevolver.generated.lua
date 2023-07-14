UndefineClass("TexRevolver")
DefineClass.TexRevolver = {
  __parents = {"Revolver"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Revolver",
  RepairCost = 50,
  Reliability = 95,
  ScrapParts = 8,
  Icon = "UI/Icons/Weapons/TexRevolver",
  DisplayName = T(520238058822, "Custom Six-Shooter"),
  DisplayNamePlural = T(463004632034, "Custom Six-Shooters"),
  Description = T(349928663403, "A custom-built revolver with a 10-inch barrel and ivory handle featuring TEX engraved in a 14K gold."),
  AdditionalHint = T(838916530388, [[
<bullet_point> High Crit chance
<bullet_point> Increased bonus from Aiming
<bullet_point> Slower Condition loss]]),
  UnitStat = "Marksmanship",
  Cost = 2000,
  locked = true,
  Caliber = "44CAL",
  Damage = 17,
  AimAccuracy = 5,
  CritChanceScaled = 30,
  MagazineSize = 6,
  PointBlankRange = true,
  OverwatchAngle = 2160,
  Entity = "Weapon_Colt",
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
