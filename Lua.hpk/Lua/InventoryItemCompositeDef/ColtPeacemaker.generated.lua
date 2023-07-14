UndefineClass("ColtPeacemaker")
DefineClass.ColtPeacemaker = {
  __parents = {"Revolver"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Revolver",
  RepairCost = 30,
  Reliability = 95,
  ScrapParts = 6,
  Icon = "UI/Icons/Weapons/Colt Peacemaker",
  DisplayName = T(692081024631, "Peacemaker"),
  DisplayNamePlural = T(275530346749, "Peacemakers"),
  Description = T(401712079854, "Single action revolver designed for the US army. Don't forget to carry it with one empty under the hammer unless you want a hole in your foot."),
  AdditionalHint = T(117021553694, "<bullet_point> Slower Condition loss"),
  UnitStat = "Marksmanship",
  Cost = 600,
  Caliber = "44CAL",
  Damage = 15,
  AimAccuracy = 5,
  MagazineSize = 6,
  PointBlankRange = true,
  OverwatchAngle = 2160,
  Entity = "Weapon_Colt",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Barrel",
      "AvailableComponents",
      {
        "BarrelLong",
        "BarrelNormal",
        "BarrelShort"
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
