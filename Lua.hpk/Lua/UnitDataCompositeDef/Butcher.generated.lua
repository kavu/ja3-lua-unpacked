UndefineClass("Butcher")
DefineClass.Butcher = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 90,
  Agility = 40,
  Dexterity = 40,
  Strength = 80,
  Wisdom = 20,
  Leadership = 20,
  Marksmanship = 50,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(450260320427, "Butcher Louis"),
  Randomization = true,
  Affiliation = "Legion",
  neutral_retaliate = true,
  archetype = "Brute",
  MaxAttacks = 1,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Butcher"})
  },
  Equipment = {
    "LegionMeleeFighter_Stronger_Elite"
  },
  gender = "Male",
  VoiceResponseId = "Butcher"
}
