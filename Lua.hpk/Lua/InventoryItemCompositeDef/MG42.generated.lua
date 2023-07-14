UndefineClass("MG42")
DefineClass.MG42 = {
  __parents = {"MachineGun"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MachineGun",
  Reliability = 95,
  ScrapParts = 12,
  Icon = "UI/Icons/Weapons/MG42",
  DisplayName = T(209733078565, "MG42"),
  DisplayNamePlural = T(386382289596, "MG42s"),
  Description = T(347491665067, "With its incredible rate of fire, the MG42 provides amazing suppression capacity. She might be old but she's German."),
  AdditionalHint = T(184959531582, [[
<bullet_point> Cumbersome (no Free Move)
<bullet_point> Less accurate when fired from the hip]]),
  LargeItem = true,
  Cumbersome = true,
  UnitStat = "Marksmanship",
  Cost = 1200,
  Caliber = "762NATO",
  Damage = 17,
  MagazineSize = 100,
  PenetrationClass = 2,
  WeaponRange = 30,
  OverwatchAngle = 1800,
  HandSlot = "TwoHanded",
  Entity = "Weapon_MG42",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Bipod",
      "Modifiable",
      false,
      "AvailableComponents",
      {"Bipod_MG42"},
      "DefaultComponent",
      "Bipod_MG42"
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
