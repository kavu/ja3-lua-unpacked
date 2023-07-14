UndefineClass("GutHookKnife")
DefineClass.GutHookKnife = {
  __parents = {
    "MeleeWeapon"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MeleeWeapon",
  Reliability = 50,
  ScrapParts = 2,
  Icon = "UI/Icons/Weapons/GutHookKnife",
  DisplayName = T(271517940366, "Gut Hook Knife"),
  DisplayNamePlural = T(947457047925, "Gut Hook Knives"),
  AdditionalHint = T(849394808821, [[
<bullet_point> Inflicts <em>Bleeding</em>
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
  AttackAP = 3000,
  MaxAimActions = 1,
  Noise = 1,
  Entity = "Weapon_FC_AMZ_Knife_01",
  HolsterSlot = "Leg"
}
