UndefineClass("Winchester_Quest")
DefineClass.Winchester_Quest = {
  __parents = {
    "SniperRifle"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "SniperRifle",
  Reliability = 95,
  ScrapParts = 8,
  Icon = "UI/Icons/Weapons/Winchester",
  DisplayName = T(296944207700, "Confidante"),
  DisplayNamePlural = T(811919268698, "Confidante"),
  Description = T(784492395256, "Reward for keeping a secret that is used for secret keeping."),
  AdditionalHint = T(111789233685, [[
<bullet_point> Backstabby and Silent
<bullet_point> High Crit chance
<bullet_point> Very low attack costs
<bullet_point> Short range
<bullet_point> Limited ammo capacity]]),
  LargeItem = true,
  UnitStat = "Marksmanship",
  Cost = 1250,
  Caliber = "44CAL",
  Damage = 43,
  AimAccuracy = 5,
  CritChanceScaled = 20,
  MagazineSize = 4,
  WeaponRange = 18,
  OverwatchAngle = 360,
  Noise = 0,
  HandSlot = "TwoHanded",
  Entity = "Weapon_Winchester",
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
    }),
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Scope",
      "AvailableComponents",
      {
        "ImprovedIronsight"
      },
      "DefaultComponent",
      "ImprovedIronsight"
    })
  },
  HolsterSlot = "Shoulder",
  ModifyRightHandGrip = true,
  PreparedAttackType = "Both",
  AvailableAttacks = {"SingleShot", "CancelShot"},
  ShootAP = 5000,
  ReloadAP = 3000
}
