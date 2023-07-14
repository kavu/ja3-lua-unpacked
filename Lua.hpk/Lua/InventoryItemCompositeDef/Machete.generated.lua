UndefineClass("Machete")
DefineClass.Machete = {
  __parents = {
    "MacheteWeapon"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MacheteWeapon",
  Reliability = 50,
  ScrapParts = 2,
  Icon = "UI/Icons/Weapons/Machete",
  DisplayName = T(898985781986, "Machete"),
  DisplayNamePlural = T(315076086987, "Machetes"),
  AdditionalHint = T(725616226891, "<bullet_point> Increased damage bonus from Strength"),
  LargeItem = true,
  UnitStat = "Dexterity",
  Cost = 150,
  BaseChanceToHit = 100,
  BaseDamage = 16,
  AimAccuracy = 15,
  PenetrationClass = 4,
  DamageMultiplier = 150,
  WeaponRange = 0,
  Charge = true,
  AttackAP = 4000,
  MaxAimActions = 1,
  Noise = 1,
  NeckAttackType = "lethal",
  Entity = "Weapon_Machete_01",
  HolsterSlot = "Shoulder"
}
