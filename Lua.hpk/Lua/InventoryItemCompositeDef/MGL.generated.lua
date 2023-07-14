UndefineClass("MGL")
DefineClass.MGL = {
  __parents = {
    "GrenadeLauncher"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "GrenadeLauncher",
  Reliability = 50,
  ScrapParts = 16,
  Caliber = "40mmGrenade",
  AttackAP = 4000,
  BombardRadius = 3,
  ComponentSlots = {},
  Entity = "Weapon_MilkorMGL",
  Icon = "UI/Icons/Weapons/weapon_MGL",
  DisplayName = T(778467383249, "MGL"),
  DisplayNamePlural = T(429606722516, "MGLs"),
  Description = T(921816007807, "When a single-shot 40mm underbarrel grenade launcher isn't enough. The MGL allows for simple, fast and reliable way to flood the field with high explosive or other type of rounds. "),
  AdditionalHint = T(618724537503, [[
<bullet_point> Shoots 40mm Grenades at a longer range
<bullet_point> Cumbersome (no Free Move)]]),
  LargeItem = true,
  Cumbersome = true,
  UnitStat = "Marksmanship",
  is_valuable = true,
  Cost = 5000,
  CritChanceScaled = 0,
  MagazineSize = 6,
  PenetrationClass = 4,
  WeaponRange = 45,
  HandSlot = "TwoHanded",
  HolsterSlot = "Shoulder",
  PreparedAttackType = "None",
  ShootAP = 4000,
  ReloadAP = 6000
}
