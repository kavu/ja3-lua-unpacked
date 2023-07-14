UndefineClass("Detonator")
DefineClass.Detonator = {
  __parents = {
    "TrapDetonator"
  },
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "TrapDetonator",
  Repairable = false,
  ScrapParts = 5,
  Icon = "UI/Icons/Items/detonator",
  DisplayName = T(747561295307, "Remote"),
  DisplayNamePlural = T(428906062831, "Remotes"),
  Description = "",
  AdditionalHint = T(861733747986, "<bullet_point> Used to trigger Remote-detonated explosives in an area"),
  UnitStat = "Explosives",
  AreaOfEffect = 5,
  ThrowRange = 20
}
