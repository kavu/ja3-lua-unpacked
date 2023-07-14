UndefineClass("RebelSoldier")
DefineClass.RebelSoldier = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 57,
  Agility = 48,
  Dexterity = 40,
  Strength = 53,
  Wisdom = 40,
  Leadership = 10,
  Marksmanship = 63,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/RebelSoldier",
  Name = T(256556608638, "Rebel"),
  Randomization = true,
  Affiliation = "Rebel",
  StartingLevel = 2,
  neutral_retaliate = true,
  AIKeywords = {"Soldier"},
  role = "Soldier",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons",
    "MinFreeMove",
    "NightOps",
    "Hotblood",
    "Shatterhand"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Soldier_Rebels"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Soldier_Rebels_02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Soldier_Rebels_03"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Soldier_Rebels_04"
    })
  },
  Equipment = {
    "RebelSoldier"
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
