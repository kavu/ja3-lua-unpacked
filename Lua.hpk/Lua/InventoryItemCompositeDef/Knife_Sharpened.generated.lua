UndefineClass("Knife_Sharpened")
DefineClass.Knife_Sharpened = {
  __parents = {
    "StackableMeleeWeapon"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "StackableMeleeWeapon",
  Reliability = 50,
  Icon = "UI/Icons/Weapons/Combat Knife Balanced",
  SubIcon = "UI/Icons/Weapons/sharpened",
  DisplayName = T(103890682555, "Sharpened Knife"),
  DisplayNamePlural = T(827013008238, "Sharpened Knives"),
  AdditionalHint = T(851425884559, [[
<bullet_point> Sharpened - high damage
<bullet_point> Low attack costs]]),
  UnitStat = "Dexterity",
  Cost = 200,
  BaseChanceToHit = 100,
  BaseDamage = 18,
  AimAccuracy = 15,
  PenetrationClass = 4,
  DamageMultiplier = 100,
  CanThrow = true,
  AttackAP = 3000,
  MaxAimActions = 1,
  Noise = 1,
  Entity = "Weapon_FC_AMZ_Knife_01",
  HolsterSlot = "Leg"
}
