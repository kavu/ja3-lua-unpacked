UndefineClass("Winchester1894")
DefineClass.Winchester1894 = {
  __parents = {
    "SniperRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "SniperRifle",
  Reliability = 95,
  ScrapParts = 8,
  Icon = "UI/Icons/Weapons/Winchester",
  DisplayName = T(107436643972, "Winchester 1894"),
  DisplayNamePlural = T(439968849416, "Winchester 1894s"),
  Description = T(359190905644, "One of the guns that \"won the West\". The magazine tube holds more ammo than your standard bolt action rifle. How this one got in this part of the world is anyone's guess."),
  AdditionalHint = T(765189854993, [[
<bullet_point> High Crit chance
<bullet_point> Low attack costs
<bullet_point> Shorter range]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  Cost = 1250,
  Caliber = "44CAL",
  Damage = 43,
  AimAccuracy = 5,
  CritChanceScaled = 20,
  MagazineSize = 9,
  WeaponRange = 24,
  OverwatchAngle = 360,
  HandSlot = "TwoHanded",
  Entity = "Weapon_Winchester",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Barrel",
      "AvailableComponents",
      {
        "BarrelLong",
        "BarrelNormal",
        "BarrelShort_Winchester"
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
      {
        "ImprovisedSuppressor"
      }
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Scope",
      "CanBeEmpty",
      true,
      "AvailableComponents",
      {
        "ImprovedIronsight",
        "LROptics",
        "LROpticsAdvanced",
        "ReflexSight",
        "ReflexSightAdvanced",
        "ScopeCOG",
        "ScopeCOGQuick",
        "ThermalScope"
      }
    })
  },
  HolsterSlot = "Shoulder",
  ModifyRightHandGrip = true,
  PreparedAttackType = "Both",
  AvailableAttacks = {"SingleShot", "CancelShot"},
  ShootAP = 7000,
  ReloadAP = 3000
}
