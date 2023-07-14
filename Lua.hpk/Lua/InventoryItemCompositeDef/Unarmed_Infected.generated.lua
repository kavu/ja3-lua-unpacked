UndefineClass("Unarmed_Infected")
DefineClass.Unarmed_Infected = {
  __parents = {
    "UnarmedWeapon"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "UnarmedWeapon",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Weapons/Fist",
  DisplayName = T(456874142840, "Unarmed"),
  DisplayNamePlural = T(123803178531, "Unarmed"),
  Description = T(712801509918, "For people who like it mano-a-mano"),
  AdditionalHint = T(573620517515, [[
<bullet_point> Very High Crit
<bullet_point> Very high aiming bonus
<bullet_point> Low Damage
<bullet_point> Additional damage from Strength skill]]),
  UnitStat = "Dexterity",
  Cost = 0,
  BaseChanceToHit = 100,
  CritChanceScaled = 50,
  BaseDamage = 20,
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
