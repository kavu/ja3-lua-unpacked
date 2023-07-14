UndefineClass("LegionGoon")
DefineClass.LegionGoon = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 28,
  Agility = 80,
  Dexterity = 30,
  Strength = 39,
  Wisdom = 30,
  Leadership = 20,
  Marksmanship = 55,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionRecon",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(469665106520, "Goon"),
  Randomization = true,
  Affiliation = "Legion",
  neutral_retaliate = true,
  AIKeywords = {"MobileShot"},
  archetype = "Skirmisher",
  role = "Recon",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "MinFreeMove",
    "Hotblood"
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
  Equipment = {"LegionGoon"},
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
