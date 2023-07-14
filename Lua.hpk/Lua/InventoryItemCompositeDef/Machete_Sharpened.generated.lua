UndefineClass("Machete_Sharpened")
DefineClass.Machete_Sharpened = {
  __parents = {
    "TransmutedMachete"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "TransmutedMachete",
  Reliability = 50,
  ScrapParts = 2,
  Icon = "UI/Icons/Weapons/Machete",
  SubIcon = "UI/Icons/Weapons/sharpened",
  DisplayName = T(304405191155, "Sharpened Machete"),
  DisplayNamePlural = T(403544043005, "Sharpened Machetes"),
  AdditionalHint = T(651122664679, [[
<bullet_point> Increased damage bonus from Strength
<bullet_point> Sharpened - high damage]]),
  LargeItem = true,
  UnitStat = "Dexterity",
  Cost = 200,
  BaseChanceToHit = 100,
  BaseDamage = 24,
  AimAccuracy = 15,
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
