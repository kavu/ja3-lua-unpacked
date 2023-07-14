UndefineClass("LegionScout_Stronger_Elite")
DefineClass.LegionScout_Stronger_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 74,
  Agility = 82,
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
  Name = T(636452311469, "Elite Scout"),
  Randomization = true,
  elite = true,
  eliteCategory = "Legion",
  Affiliation = "Legion",
  StartingLevel = 2,
  neutral_retaliate = true,
  AIKeywords = {"Flank", "RunAndGun"},
  archetype = "Skirmisher",
  role = "Recon",
  OpeningAttackType = "Overwatch",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons",
    "RelentlessAdvance",
    "Counterfire"
  },
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
    "LegionScout_Stronger_Elite"
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
