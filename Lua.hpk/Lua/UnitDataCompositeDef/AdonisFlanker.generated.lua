UndefineClass("AdonisFlanker")
DefineClass.AdonisFlanker = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 70,
  Agility = 81,
  Dexterity = 83,
  Strength = 47,
  Wisdom = 73,
  Leadership = 20,
  Marksmanship = 70,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/AdonisRecon",
  Name = T(530121952558, "Commando"),
  Randomization = true,
  Affiliation = "Adonis",
  StartingLevel = 3,
  neutral_retaliate = true,
  AIKeywords = {"Flank", "RunAndGun"},
  archetype = "Skirmisher",
  role = "Recon",
  AlwaysUseOpeningAttack = true,
  MaxAttacks = 2,
  unitPowerModifier = 75,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons",
    "Hotblood",
    "NightOps",
    "RelentlessAdvance",
    "SteadyBreathing"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Adonis_Recon"
    })
  },
  Equipment = {
    "AdonisFlanker"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "AdonisMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "AdonisMale_2"
    })
  },
  Tier = "Veteran",
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "AdonisAssault"
}
