UndefineClass("_762NATO_AP")
DefineClass._762NATO_AP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_nato_bullets_armor_piercing",
  DisplayName = T(451239732490, "7.62 mm NATO Armor Piercing"),
  DisplayNamePlural = T(987128655410, "7.62 mm NATO Armor Piercing"),
  colorStyle = "AmmoAPColor",
  Description = T(241536180521, "7.62 NATO ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(850324784601, "<bullet_point> Improved armor penetration"),
  MaxStacks = 500,
  Caliber = "762NATO",
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "PenetrationClass"
    })
  }
}
