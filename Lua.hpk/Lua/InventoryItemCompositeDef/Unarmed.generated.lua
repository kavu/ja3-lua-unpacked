UndefineClass("Unarmed")
DefineClass.Unarmed = {
  __parents = {
    "UnarmedWeapon"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "UnarmedWeapon",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Weapons/Fist",
  DisplayName = T(738226804609, "Unarmed"),
  DisplayNamePlural = T(262841837142, "Unarmed"),
  AdditionalHint = T(550723540825, [[
<bullet_point> Low Damage
<bullet_point> Increased damage bonus from Strength
<bullet_point> Very High Crit chance
<bullet_point> Greatly increased bonus from Aiming]]),
  UnitStat = "Dexterity",
  Cost = 0,
  BaseChanceToHit = 100,
  CritChanceScaled = 50,
  BaseDamage = 5,
  AimAccuracy = 25,
  PenetrationClass = 4,
  DamageMultiplier = 150,
  WeaponRange = 0,
  IsUnarmed = true,
  AttackAP = 3000,
  MaxAimActions = 1,
  Noise = 1,
  NeckAttackType = "choke"
}
