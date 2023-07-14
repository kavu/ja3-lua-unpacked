UndefineClass("LegionGoon_Stronger")
DefineClass.LegionGoon_Stronger = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 39,
  Agility = 85,
  Dexterity = 71,
  Strength = 39,
  Wisdom = 30,
  Leadership = 20,
  Marksmanship = 55,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionRecon",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(697917252042, "Hardy Goon"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 3,
  neutral_retaliate = true,
  AIKeywords = {"MobileShot"},
  archetype = "Skirmisher",
  role = "Recon",
  PinnedDownChance = 100,
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "Hotblood",
    "MinFreeMove"
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
    "LegionGoon_Stronger"
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
