UndefineClass("MP40")
DefineClass.MP40 = {
  __parents = {
    "SubmachineGun"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "SubmachineGun",
  Reliability = 70,
  ScrapParts = 6,
  Icon = "UI/Icons/Weapons/MP40",
  DisplayName = T(623210280984, "MP40"),
  DisplayNamePlural = T(925856619983, "MP40s"),
  Description = T(107317552821, "Initially designed for vehicle crews and paratroopers, It really became widely used when the brutal urban combat of the Eastern front showed the value of a reliable submachine gun. "),
  AdditionalHint = T(396615593162, "<bullet_point> Decreased bonus from Aiming"),
  LargeItem = true,
  UnitStat = "Marksmanship",
  Cost = 800,
  Caliber = "9mm",
  Damage = 14,
  MagazineSize = 40,
  PointBlankRange = true,
  OverwatchAngle = 1440,
  Noise = 15,
  HandSlot = "TwoHanded",
  Entity = "Weapon_MP40",
  ComponentSlots = {
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
  AvailableAttacks = {
    "BurstFire",
    "AutoFire",
    "SingleShot",
    "RunAndGun",
    "CancelShot"
  },
  ShootAP = 5000,
  ReloadAP = 3000
}
