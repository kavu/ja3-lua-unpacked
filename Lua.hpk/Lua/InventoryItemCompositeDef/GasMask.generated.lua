UndefineClass("GasMask")
DefineClass.GasMask = {
  __parents = {"Armor"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Armor",
  Degradation = 12,
  ScrapParts = 2,
  Icon = "UI/Icons/Items/gas_mask",
  DisplayName = T(412060878986, "Gas Mask"),
  DisplayNamePlural = T(598211057804, "Gas Masks"),
  AdditionalHint = T(538823109533, [[
<bullet_point> Max AP lowered by 1
<bullet_point> Protects from gas grenades and gas mortar shells
<bullet_point> Can't be combined with weave or ceramics]]),
  Slot = "Head",
  PenetrationClass = 2,
  AdditionalReduction = 20,
  ProtectedBodyParts = set("Head")
}
