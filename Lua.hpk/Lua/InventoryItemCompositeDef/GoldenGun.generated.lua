UndefineClass("GoldenGun")
DefineClass.GoldenGun = {
  __parents = {
    "SniperRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "SniperRifle",
  Reliability = 80,
  ScrapParts = 16,
  Icon = "UI/Icons/Weapons/GoldenGun",
  DisplayName = T(726601867404, "Gold Fever"),
  DisplayNamePlural = T(126313842219, "Gold Fever"),
  Description = T(998072775687, "This custom-made M14 is coated with 24-karat gold and has a mean aura."),
  AdditionalHint = T(439493128569, [[
<bullet_point> Insensitive
<bullet_point> Cumbersome (no Free Move)
<bullet_point> Very noisy]]),
  LargeItem = true,
  Cumbersome = true,
  is_valuable = true,
  Cost = 3000,
  Caliber = "762NATO",
  Damage = 50,
  AimAccuracy = 10,
  PenetrationClass = 3,
  IgnoreCoverReduction = 1,
  WeaponRange = 36,
  OverwatchAngle = 360,
  Noise = 30,
  HandSlot = "TwoHanded",
  Entity = "Weapon_M14_GoldEquip",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Bipod",
      "Modifiable",
      false,
      "AvailableComponents",
      {"Bipod"},
      "DefaultComponent",
      "Bipod"
    })
  },
  HolsterSlot = "Shoulder",
  ModifyRightHandGrip = true,
  PreparedAttackType = "Both",
  AvailableAttacks = {"SingleShot"},
  ShootAP = 7000
}
