UndefineClass("TheThing")
DefineClass.TheThing = {
  __parents = {
    "MacheteWeapon"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MacheteWeapon",
  Reliability = 50,
  ScrapParts = 2,
  Icon = "UI/Icons/Weapons/TheThing",
  DisplayName = T(433481113205, "The Thing"),
  DisplayNamePlural = T(118082867905, "The Things"),
  Description = T(982967757070, "It's a Family Thing."),
  AdditionalHint = T(655013313496, "<bullet_point> Extreme damage bonus from Strength"),
  LargeItem = true,
  UnitStat = "Dexterity",
  is_valuable = true,
  Cost = 150,
  BaseChanceToHit = 100,
  CritChanceScaled = 30,
  BaseDamage = 18,
  AimAccuracy = 15,
  PenetrationClass = 4,
  WeaponRange = 0,
  Charge = true,
  AttackAP = 4000,
  MaxAimActions = 1,
  Noise = 1,
  Entity = "Weapon_Machete_02",
  HolsterSlot = "Shoulder"
}
