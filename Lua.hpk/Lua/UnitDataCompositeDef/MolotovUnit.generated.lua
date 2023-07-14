UndefineClass("MolotovUnit")
DefineClass.MolotovUnit = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 85,
  Agility = 75,
  Dexterity = 75,
  Strength = 80,
  Wisdom = 50,
  Leadership = 35,
  Marksmanship = 75,
  Mechanical = 25,
  Explosives = 85,
  Medical = 0,
  Name = T(417996336623, "Molotov"),
  Affiliation = "Other",
  StartingLevel = 7,
  ImportantNPC = true,
  neutral_retaliate = true,
  AIKeywords = {"Explosives"},
  archetype = "Skirmisher",
  MaxAttacks = 1,
  StartingPerks = {
    "CollateralDamage",
    "Berserker"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Demolishion03"
    })
  },
  Equipment = {
    "LegionGrenadier_Stronger_Elite_Molotov"
  },
  pollyvoice = "Geraint",
  gender = "Male"
}
