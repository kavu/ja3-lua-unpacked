UndefineClass("Knife")
DefineClass.Knife = {
  __parents = {
    "StackableMeleeWeapon"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "StackableMeleeWeapon",
  Reliability = 50,
  Icon = "UI/Icons/Weapons/Combat Knife Balanced",
  DisplayName = T(778293748375, "Combat Knife"),
  DisplayNamePlural = T(372653348721, "Combat Knives"),
  AdditionalHint = T(958578445510, "<bullet_point> Low attack costs"),
  UnitStat = "Dexterity",
  Cost = 150,
  BaseChanceToHit = 100,
  BaseDamage = 12,
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
