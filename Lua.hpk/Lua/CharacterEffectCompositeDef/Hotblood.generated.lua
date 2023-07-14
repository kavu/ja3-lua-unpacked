UndefineClass("Hotblood")
DefineClass.Hotblood = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  DisplayName = T(191027194421, "Reactive Fire"),
  Description = T(710792552808, [[
Make an <GameTerm('Interrupt')> attack with firearms when an enemy attack misses you during the enemy turn (chance is based on an opposed Dexterity check).

Will not trigger while <em>Taking Cover</em>.]]),
  Icon = "UI/Icons/Perks/Hotblood",
  Tier = "Silver",
  Stat = "Dexterity",
  StatValue = 80
}
