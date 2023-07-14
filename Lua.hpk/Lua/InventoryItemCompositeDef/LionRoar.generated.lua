UndefineClass("LionRoar")
DefineClass.LionRoar = {
  __parents = {
    "SubmachineGun"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "SubmachineGun",
  Reliability = 80,
  ScrapParts = 10,
  Icon = "UI/Icons/Weapons/LionRoar",
  DisplayName = T(755592839679, "The Lion's Roar"),
  DisplayNamePlural = T(357764743328, "The Lion's Roar"),
  Description = T(216467415261, "Imperialists cower before its voice!"),
  AdditionalHint = T(251066241512, [[
<bullet_point> OUR weapon
<bullet_point> Shorter range
<bullet_point> High Damage
<bullet_point> Limited ammo capacity
<bullet_point> Increased bonus from Aiming
<bullet_point> Very noisy]]),
  is_valuable = true,
  Cost = 3000,
  Caliber = "9mm",
  Damage = 22,
  AimAccuracy = 8,
  MagazineSize = 20,
  PenetrationClass = 2,
  WeaponRange = 16,
  PointBlankRange = true,
  OverwatchAngle = 1440,
  HandSlot = "TwoHanded",
  Entity = "Weapon_Uzi_LionsRoar",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Muzzle",
      "Modifiable",
      false,
      "AvailableComponents",
      {
        "Compensator_cosmetic"
      },
      "DefaultComponent",
      "Compensator_cosmetic"
    })
  },
  HolsterSlot = "Shoulder",
  AvailableAttacks = {
    "BurstFire",
    "AutoFire",
    "SingleShot",
    "RunAndGun"
  },
  ShootAP = 5000,
  ReloadAP = 3000
}
