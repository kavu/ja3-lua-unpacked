UndefineClass("Machete_Crafted")
DefineClass.Machete_Crafted = {
  __parents = {
    "MacheteWeapon"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MacheteWeapon",
  Reliability = 50,
  ScrapParts = 2,
  Icon = "UI/Icons/Weapons/MacheteChainsword",
  DisplayName = T(416965583814, "Composite Machete"),
  DisplayNamePlural = T(703147370925, "Composite Machetes"),
  Description = T(617282185892, "Includes built-in multitool, corkscrew and nail clipper."),
  AdditionalHint = T(553000990624, [[
<bullet_point> Increased damage bonus from Strength
<bullet_point> High Crit chance]]),
  LargeItem = true,
  UnitStat = "Dexterity",
  Cost = 150,
  BaseChanceToHit = 100,
  CritChanceScaled = 30,
  BaseDamage = 16,
  AimAccuracy = 15,
  PenetrationClass = 4,
  DamageMultiplier = 150,
  WeaponRange = 0,
  Charge = true,
  AttackAP = 4000,
  MaxAimActions = 1,
  Noise = 1,
  NeckAttackType = "lethal",
  Entity = "Weapon_Machete_02",
  HolsterSlot = "Shoulder"
}
