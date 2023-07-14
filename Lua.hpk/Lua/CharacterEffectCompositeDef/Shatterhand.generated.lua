UndefineClass("Shatterhand")
DefineClass.Shatterhand = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  DisplayName = T(180355493830, "Revenge"),
  Description = T(210753897016, [[
Make an <GameTerm('Interrupt')> attack with firearms when taking significant damage during the enemy turn (chance is based on Health).

Will not trigger while <em>Taking Cover</em>.]]),
  Icon = "UI/Icons/Perks/Shatterhand",
  Tier = "Silver",
  Stat = "Health",
  StatValue = 80
}
