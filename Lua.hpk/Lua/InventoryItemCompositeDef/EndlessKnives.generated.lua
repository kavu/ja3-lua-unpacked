UndefineClass("EndlessKnives")
DefineClass.EndlessKnives = {
  __parents = {
    "MeleeWeapon"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MeleeWeapon",
  Reliability = 50,
  Icon = "UI/Icons/Weapons/EndlessKnives",
  DisplayName = T(996476550790, "Endless Knives"),
  DisplayNamePlural = T(262652558760, "Endless Knives"),
  AdditionalHint = T(389124413877, [[
<bullet_point> Always available for throwing
<bullet_point> Low attack costs
<bullet_point> Increased bonus from Aiming]]),
  UnitStat = "Dexterity",
  Cost = 150,
  locked = true,
  BaseChanceToHit = 100,
  BaseDamage = 12,
  AimAccuracy = 20,
  PenetrationClass = 4,
  DamageMultiplier = 100,
  CanThrow = true,
  AttackAP = 3000,
  MaxAimActions = 1,
  Noise = 1,
  Entity = "Weapon_FC_AMZ_Knife_01",
  HolsterSlot = "Leg"
}
