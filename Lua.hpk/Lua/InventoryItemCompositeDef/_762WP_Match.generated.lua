UndefineClass("_762WP_Match")
DefineClass._762WP_Match = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_wp_bullets_match",
  DisplayName = T(983548612559, "7.62 mm WP Match"),
  DisplayNamePlural = T(565381152146, "7.62 mm WP Match"),
  colorStyle = "AmmoMatchColor",
  Description = T(587024333620, "7.62 Warsaw Pact ammo for Assault Rifles, SMGs, Machine Guns, and Snipers."),
  AdditionalHint = T(898089454154, "<bullet_point> Increased bonus from Aiming"),
  MaxStacks = 500,
  Caliber = "762WP",
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "AimAccuracy"
    })
  }
}
