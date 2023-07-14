UndefineClass("LegionGoon_Stronger_Elite")
DefineClass.LegionGoon_Stronger_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 64,
  Agility = 96,
  Dexterity = 71,
  Strength = 39,
  Wisdom = 30,
  Leadership = 20,
  Marksmanship = 77,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionRecon",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(389131382620, "Tough Goon"),
  Randomization = true,
  elite = true,
  eliteCategory = "Legion",
  Affiliation = "Legion",
  StartingLevel = 6,
  neutral_retaliate = true,
  AIKeywords = {"MobileShot"},
  archetype = "Skirmisher",
  role = "Recon",
  PinnedDownChance = 100,
  MaxAttacks = 2,
  CustomEquipGear = function(self, items)
  end,
  MaxHitPoints = 50,
  StartingPerks = {
    "BeefedUp",
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
  Equipment = {
    "LegionGoon_Stronger_Elite"
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
