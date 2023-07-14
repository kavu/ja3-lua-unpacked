UndefineClass("Knife_Balanced")
DefineClass.Knife_Balanced = {
  __parents = {
    "StackableMeleeWeapon"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "StackableMeleeWeapon",
  Reliability = 50,
  Icon = "UI/Icons/Weapons/Combat Knife Balanced",
  SubIcon = "UI/Icons/Weapons/balanced",
  DisplayName = T(443240153343, "Balanced Knife"),
  DisplayNamePlural = T(645556627800, "Balanced Knives"),
  AdditionalHint = T(307902922198, [[
<bullet_point> Balanced - longer throwing range
<bullet_point> Balanced - increased bonus from Aiming
<bullet_point> Low attack costs]]),
  UnitStat = "Dexterity",
  Cost = 200,
  BaseChanceToHit = 100,
  BaseDamage = 12,
  AimAccuracy = 20,
  PenetrationClass = 4,
  DamageMultiplier = 100,
  CanThrow = true,
  WeaponRange = 10,
  AttackAP = 3000,
  MaxAimActions = 1,
  Noise = 1,
  Entity = "Weapon_FC_AMZ_Knife_01",
  HolsterSlot = "Leg"
}
