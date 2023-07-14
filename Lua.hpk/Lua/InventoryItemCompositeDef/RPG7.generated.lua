UndefineClass("RPG7")
DefineClass.RPG7 = {
  __parents = {
    "RocketLauncher"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "RocketLauncher",
  Reliability = 50,
  ScrapParts = 16,
  Caliber = "Warhead",
  Entity = "Weapon_RPG7_Copy",
  Icon = "UI/Icons/Weapons/RPG-7",
  DisplayName = T(117851406940, "RPG-7"),
  DisplayNamePlural = T(336619600237, "RPGs-7"),
  Description = T(323877319340, "Initially created as an anti-tank weapon, it's currently being used against vehicles, buildings, and generally anything else the wielders dislike."),
  AdditionalHint = T(808710717379, [[
<bullet_point> Shoots Rockets in a straight line to the target
<bullet_point> Minor damage to characters behind the attacker
<bullet_point> Cumbersome (no Free Move)]]),
  LargeItem = true,
  Cumbersome = true,
  UnitStat = "Explosives",
  is_valuable = true,
  Cost = 10000,
  ObjDamageMod = 600,
  CritChanceScaled = 0,
  PenetrationClass = 5,
  WeaponRange = 45,
  HandSlot = "TwoHanded",
  HolsterSlot = "Shoulder",
  PreparedAttackType = "None",
  ShootAP = 6000,
  ReloadAP = 4000,
  BackfireRange = 2,
  BackfireDamage = 8
}
