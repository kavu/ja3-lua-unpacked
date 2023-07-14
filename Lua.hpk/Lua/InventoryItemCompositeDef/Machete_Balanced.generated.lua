UndefineClass("Machete_Balanced")
DefineClass.Machete_Balanced = {
  __parents = {
    "MacheteWeapon"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MacheteWeapon",
  Reliability = 50,
  ScrapParts = 2,
  Icon = "UI/Icons/Weapons/Machete",
  SubIcon = "UI/Icons/Weapons/balanced",
  DisplayName = T(449180061981, "Balanced Machete"),
  DisplayNamePlural = T(806406909704, "Balanced Machetes"),
  AdditionalHint = T(862835497248, [[
<bullet_point> Increased damage bonus from Strength
<bullet_point> Balanced - increased bonus from Aiming]]),
  LargeItem = true,
  UnitStat = "Dexterity",
  Cost = 200,
  BaseChanceToHit = 100,
  BaseDamage = 16,
  AimAccuracy = 20,
  PenetrationClass = 4,
  DamageMultiplier = 150,
  WeaponRange = 0,
  Charge = true,
  AttackAP = 4000,
  MaxAimActions = 1,
  Noise = 1,
  NeckAttackType = "lethal",
  Entity = "Weapon_Machete_03",
  HolsterSlot = "Shoulder"
}
