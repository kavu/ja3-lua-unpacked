UndefineClass("AnimTestDummy_Crouched")
DefineClass.AnimTestDummy_Crouched = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 10,
  Agility = 30,
  Dexterity = 21,
  Strength = 23,
  Wisdom = 12,
  Leadership = 10,
  Marksmanship = 13,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(764882950447, "Legion Marauder"),
  Affiliation = "Legion",
  StartingLevel = 2,
  neutral_retaliate = true,
  archetype = "AnimTestDummy_Crouched",
  RepositionArchetype = "AnimTestDummy_Crouched",
  MaxHitPoints = 50,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Recon"
    })
  },
  Equipment = {
    "LegionRaiders"
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
