UndefineClass("Tedd")
DefineClass.Tedd = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 95,
  Agility = 95,
  Dexterity = 80,
  Strength = 90,
  Wisdom = 85,
  Leadership = 0,
  Marksmanship = 25,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(375784320733, "Teddy"),
  Affiliation = "Other",
  StartingLevel = 7,
  neutral_retaliate = true,
  archetype = "Brute",
  RepositionArchetype = "Brute",
  AlwaysUseOpeningAttack = true,
  MaxAttacks = 1,
  StartingPerks = {
    "BloodScent",
    "Berserker",
    "TrueGrit",
    "BattleFocus",
    "NaturalCamouflage",
    "MeleeTraining",
    "ColdHeart"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Tedd"})
  },
  Equipment = {"Tedd"},
  gender = "Male",
  PersistentSessionId = "NPC_Ted"
}
