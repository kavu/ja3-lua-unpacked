UndefineClass("Berserker")
DefineClass.Berserker = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  DisplayName = T(489115886772, "Rage"),
  Description = T(709603782046, [[
Deal <em><percent(damageBonus)> Damage</em> per <GameTerm('Wound')>.

Capped at <em><Multiply(damageBonus, stackCap)>%</em>.]]),
  Icon = "UI/Icons/Perks/PainManagement",
  Tier = "Silver",
  Stat = "Health",
  StatValue = 80
}
