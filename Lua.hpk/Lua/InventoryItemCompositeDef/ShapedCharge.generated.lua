UndefineClass("ShapedCharge")
DefineClass.ShapedCharge = {
  __parents = {"Grenade"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Grenade",
  Repairable = false,
  Reliability = 100,
  Icon = "UI/Icons/Weapons/ShapedCharge",
  ItemType = "Grenade",
  DisplayName = T(380012367478, "Shaped Charge"),
  DisplayNamePlural = T(622567247516, "Shaped Charges"),
  AdditionalHint = T(429964637592, [[
<bullet_point> Cone-shaped explosion
<bullet_point> High mishap risk when used by anyone except Barry]]),
  UnitStat = "Explosives",
  Cost = 1500,
  MinMishapChance = 2,
  MaxMishapChance = 30,
  MaxMishapRange = 6,
  AreaOfEffect = 8,
  PenetrationClass = 3,
  coneShaped = true,
  coneAngle = 45,
  BurnGround = false,
  DeathType = "BlowUp",
  BaseDamage = 40,
  Scatter = 4,
  CanBounce = false,
  Entity = "MilitaryCamp_Grenade_01",
  ActionIcon = "UI/Icons/Hud/shaped_charge"
}
