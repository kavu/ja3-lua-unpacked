UndefineClass("Gewehr98")
DefineClass.Gewehr98 = {
  __parents = {
    "SniperRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "SniperRifle",
  Reliability = 25,
  ScrapParts = 8,
  Icon = "UI/Icons/Weapons/Gewehr98",
  DisplayName = T(622217392257, "Gewehr 98"),
  DisplayNamePlural = T(512124485855, "Gewehr 98s"),
  Description = T(688355440301, "It is said that this Mauser design is the grandpa of all bolt action rifles. Even the modern hunting or military sniper rifles started here. "),
  AdditionalHint = T(885309778365, [[
<bullet_point> Shorter range
<bullet_point> Very noisy]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  Cost = 1250,
  Caliber = "762NATO",
  Damage = 36,
  AimAccuracy = 5,
  MagazineSize = 5,
  PenetrationClass = 2,
  WeaponRange = 32,
  OverwatchAngle = 360,
  Noise = 30,
  HandSlot = "TwoHanded",
  Entity = "Weapon_Gewehr98",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Scope",
      "AvailableComponents",
      {
        "LROptics",
        "ReflexSight",
        "ScopeCOG",
        "GewehrDefaultSight",
        "ImprovedIronsight",
        "ReflexSightAdvanced",
        "ScopeCOGQuick",
        "ThermalScope"
      },
      "DefaultComponent",
      "GewehrDefaultSight"
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
    })
  },
  HolsterSlot = "Shoulder",
  ModifyRightHandGrip = true,
  PreparedAttackType = "Both",
  AvailableAttacks = {"SingleShot", "CancelShot"},
  ShootAP = 8000,
  ReloadAP = 3000
}
