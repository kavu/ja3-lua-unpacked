UndefineClass("AnimTestDummy_Standing")
DefineClass.AnimTestDummy_Standing = {
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
  Name = T(109394928094, "Legion Marauder"),
  Affiliation = "Legion",
  StartingLevel = 2,
  neutral_retaliate = true,
  archetype = "AnimTestDummy_Standing",
  RepositionArchetype = "AnimTestDummy_Standing",
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
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {"Name", "Dummy_1"}),
    PlaceObj("AdditionalGroup", {"Name", "Dummy_2"})
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
