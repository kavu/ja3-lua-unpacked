UndefineClass("PierreMachete")
DefineClass.PierreMachete = {
  __parents = {
    "MacheteWeapon"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MacheteWeapon",
  Reliability = 50,
  ScrapParts = 2,
  Icon = "UI/Icons/Weapons/pierre_machete",
  DisplayName = T(646705990009, "Legion's Pride"),
  DisplayNamePlural = T(624754374783, "Legion's Pride"),
  AdditionalHint = T(619127058218, [[
<bullet_point> Increased damage bonus from Strength
<bullet_point> Low attack costs]]),
  LargeItem = true,
  UnitStat = "Dexterity",
  Cost = 150,
  locked = true,
  BaseChanceToHit = 100,
  CritChanceScaled = 30,
  BaseDamage = 16,
  AimAccuracy = 15,
  PenetrationClass = 4,
  DamageMultiplier = 150,
  WeaponRange = 0,
  Charge = true,
  AttackAP = 3000,
  MaxAimActions = 1,
  Noise = 1,
  NeckAttackType = "lethal",
  Entity = "Weapon_Machete_01",
  HolsterSlot = "Shoulder"
}
