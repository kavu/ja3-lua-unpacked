UndefineClass("LegionRaider_WeakFlagHill")
DefineClass.LegionRaider_WeakFlagHill = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 30,
  Agility = 50,
  Dexterity = 0,
  Strength = 40,
  Wisdom = 40,
  Leadership = 10,
  Marksmanship = 37,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionRaider",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(516572451846, "Goon"),
  Affiliation = "Legion",
  neutral_retaliate = true,
  archetype = "TutorialMinion",
  MaxAttacks = 1,
  MaxHitPoints = 60,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier03"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier04"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier05"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier06"
    })
  },
  Equipment = {"Minion"},
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Name",
      "LegionMale_1"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
