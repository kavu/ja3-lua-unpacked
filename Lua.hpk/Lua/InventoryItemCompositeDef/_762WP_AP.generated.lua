UndefineClass("_762WP_AP")
DefineClass._762WP_AP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_wp_bullets_armor_piercing",
  DisplayName = T(967129689129, "7.62 mm WP Armor Piercing"),
  DisplayNamePlural = T(837647504259, "7.62 mm WP Armor Piercing"),
  colorStyle = "AmmoAPColor",
  Description = T(910307381187, "7.62 Warsaw Pact ammo for Assault Rifles, SMGs, Machine Guns, and Snipers."),
  AdditionalHint = T(302328653162, "<bullet_point> Improved armor penetration"),
  MaxStacks = 500,
  Caliber = "762WP",
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "PenetrationClass"
    })
  }
}
