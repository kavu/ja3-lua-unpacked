UndefineClass("DrFracture")
DefineClass.DrFracture = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 70,
  Agility = 80,
  Dexterity = 80,
  Strength = 80,
  Wisdom = 50,
  Leadership = 35,
  Marksmanship = 55,
  Mechanical = 25,
  Explosives = 20,
  Medical = 0,
  Name = T(619434744023, "Dr. Fracture"),
  Affiliation = "Other",
  StartingLevel = 4,
  neutral_retaliate = true,
  archetype = "Brute",
  MaxAttacks = 1,
  StartingPerks = {
    "StressManagement",
    "Berserker",
    "ShockAndAwe",
    "BattleFocus"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "DrFracture"})
  },
  Equipment = {
    "Civilian_Unarmed"
  },
  pollyvoice = "Russell",
  gender = "Male",
  PersistentSessionId = "NPC_DrFracture"
}
