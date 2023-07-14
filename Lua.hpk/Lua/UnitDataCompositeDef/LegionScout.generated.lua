UndefineClass("LegionScout")
DefineClass.LegionScout = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 36,
  Agility = 79,
  Dexterity = 73,
  Strength = 48,
  Wisdom = 71,
  Leadership = 29,
  Marksmanship = 58,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionRecon",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(680341210171, "Scout"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 2,
  neutral_retaliate = true,
  AIKeywords = {"Flank", "RunAndGun"},
  archetype = "Skirmisher",
  role = "Recon",
  OpeningAttackType = "Overwatch",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Recon"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Recon02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Recon03"
    })
  },
  Equipment = {
    "LegionScout"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "LegionMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "LegionMale_2"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
