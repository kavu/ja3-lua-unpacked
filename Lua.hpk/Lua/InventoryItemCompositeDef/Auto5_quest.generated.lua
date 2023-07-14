UndefineClass("Auto5_quest")
DefineClass.Auto5_quest = {
  __parents = {"Shotgun"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Shotgun",
  RepairCost = 50,
  Reliability = 20,
  ScrapParts = 10,
  Icon = "UI/Icons/Weapons/Auto5Quest",
  ItemType = "Shotgun",
  DisplayName = T(104957685912, "Ma Baxter's Argument Invalidator"),
  DisplayNamePlural = T(319145443336, "Ma Baxter's Argument Invalidators"),
  Description = T(918826814712, "The legendary owner of the bar in Port Cacao used this custom Auto-5 shotgun to end bar fights in the most final way possible."),
  AdditionalHint = T(876166041529, "<bullet_point> Rapid Invalidation"),
  LargeItem = true,
  is_valuable = true,
  Cost = 1200,
  Caliber = "12gauge",
  Damage = 22,
  ObjDamageMod = 150,
  AimAccuracy = 4,
  MagazineSize = 9,
  WeaponRange = 8,
  PointBlankRange = true,
  OverwatchAngle = 1200,
  BuckshotConeAngle = 1200,
  BuckshotFalloffDamage = 100,
  HandSlot = "TwoHanded",
  Entity = "Weapon_Auto5",
  ComponentSlots = {
    PlaceObj("WeaponComponentSlot", {
      "SlotType",
      "Barrel",
      "AvailableComponents",
      {
        "Auto5_Basic_LMag"
      },
      "DefaultComponent",
      "Auto5_Basic_LMag"
    })
  },
  HolsterSlot = "Shoulder",
  AvailableAttacks = {
    "BuckshotBurst"
  },
  ShootAP = 4000,
  ReloadAP = 3000
}
