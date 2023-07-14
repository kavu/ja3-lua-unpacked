UndefineClass("_40mmFlashbangGrenade")
DefineClass._40mmFlashbangGrenade = {
  __parents = {"Ordnance"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ordnance",
  Icon = "UI/Icons/Items/40mm_flashbang_grenade",
  DisplayName = T(805412560134, "40 mm Flashbang"),
  DisplayNamePlural = T(753721174279, "40 mm Flashbangs"),
  Description = T(637064167762, "40 mm ordnance ammo for Grenade Launchers."),
  AdditionalHint = T(222515823004, [[
<bullet_point> Reduces target Energy in the epicenter (once per battle)
<bullet_point> Inflicts <em>Suppressed</em>
<bullet_point> Less noisy]]),
  CenterUnitDamageMod = 130,
  CenterObjDamageMod = 10,
  CenterAppliedEffects = {
    "IncreaseTiredness",
    "Suppressed"
  },
  AreaObjDamageMod = 10,
  AreaAppliedEffects = {"Suppressed"},
  PenetrationClass = 1,
  BurnGround = false,
  Caliber = "40mmGrenade",
  BaseDamage = 5,
  Noise = 5,
  Entity = "Weapon_MilkorMGL_Shell"
}
