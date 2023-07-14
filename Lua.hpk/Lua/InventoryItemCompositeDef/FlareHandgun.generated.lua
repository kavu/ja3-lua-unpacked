UndefineClass("FlareHandgun")
DefineClass.FlareHandgun = {
  __parents = {"FlareGun"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "FlareGun",
  RepairCost = 70,
  Reliability = 20,
  ScrapParts = 2,
  Icon = "UI/Icons/Weapons/FlareGun",
  ItemType = "FlareGun",
  DisplayName = T(335515845100, "Flare Gun"),
  DisplayNamePlural = T(989166829697, "Flare Guns"),
  Description = T(323491634965, "Single-shot breech-loading pistol you can use to light up the sky. "),
  AdditionalHint = T(327868916279, [[
<bullet_point> Illuminates a large area
<bullet_point> Long range
<bullet_point> Silent]]),
  UnitStat = "Marksmanship",
  is_valuable = true,
  Cost = 3000,
  Caliber = "Flare",
  ObjDamageMod = 0,
  CritChanceScaled = 0,
  WeaponRange = 35,
  OverwatchAngle = 2160,
  Noise = 3,
  Entity = "Weapon_FlareGun",
  HolsterSlot = "Leg",
  PreparedAttackType = "None",
  AvailableAttacks = {"FireFlare"},
  MinMishapChance = 20,
  MaxMishapChance = 60
}
