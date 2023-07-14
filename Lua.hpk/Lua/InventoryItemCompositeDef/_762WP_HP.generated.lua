UndefineClass("_762WP_HP")
DefineClass._762WP_HP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_wp_bullets_hollow_point",
  DisplayName = T(730378195306, "7.62 mm WP Hollow Point"),
  DisplayNamePlural = T(277143674333, "7.62 mm WP Hollow Point"),
  colorStyle = "AmmoHPColor",
  Description = T(220374487056, "7.62 Warsaw Pact ammo for Assault Rifles, SMGs, Machine Guns, and Snipers."),
  AdditionalHint = T(122052983336, [[
<bullet_point> No armor penetration
<bullet_point> High Crit chance
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "762WP",
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {
      mod_add = -4,
      target_prop = "PenetrationClass"
    })
  },
  AppliedEffects = {"Bleeding"}
}
