UndefineClass("MortarInventoryItem")
DefineClass.MortarInventoryItem = {
  __parents = {"Mortar"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Mortar",
  Reliability = 50,
  ScrapParts = 16,
  Caliber = "MortarShell",
  Entity = "Weapon_M224",
  Icon = "UI/Icons/Weapons/M224",
  DisplayName = T(896988248349, "Mortar"),
  DisplayNamePlural = T(771584366854, "Mortars"),
  Description = T(592156025078, "Lightweight system that allows for 60mm close support rain of fire or other ordnance. "),
  AdditionalHint = T(327199454194, [[
<bullet_point> Bombards a remote area after a delay
<bullet_point> Cumbersome (no Free Move)]]),
  LargeItem = true,
  Cumbersome = true,
  UnitStat = "Marksmanship",
  is_valuable = true,
  Cost = 10000,
  CritChanceScaled = 0,
  MagazineSize = 5,
  PenetrationClass = 5,
  WeaponRange = 70,
  Noise = 50,
  HandSlot = "TwoHanded",
  HolsterSlot = "Shoulder",
  PreparedAttackType = "None",
  ShootAP = 6000
}
