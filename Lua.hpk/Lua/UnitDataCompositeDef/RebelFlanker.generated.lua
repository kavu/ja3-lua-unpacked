UndefineClass("RebelFlanker")
DefineClass.RebelFlanker = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 53,
  Agility = 80,
  Dexterity = 74,
  Strength = 48,
  Wisdom = 55,
  Leadership = 29,
  Marksmanship = 66,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/RebelRecon",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(799544250926, "Envoy"),
  Randomization = true,
  Affiliation = "Rebel",
  StartingLevel = 3,
  neutral_retaliate = true,
  AIKeywords = {"Flank", "RunAndGun"},
  archetype = "Skirmisher",
  role = "Recon",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "MinFreeMove",
    "NightOps",
    "Hotblood"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Recon_Rebels"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Recon_Rebels_02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Recon_Rebels_03"
    })
  },
  Equipment = {
    "RebelFlanker"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "MaquisMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "MaquisMale_2"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "RebelSoldier"
}
