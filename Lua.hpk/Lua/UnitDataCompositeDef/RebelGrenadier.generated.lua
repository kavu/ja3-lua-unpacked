UndefineClass("RebelGrenadier")
DefineClass.RebelGrenadier = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 63,
  Dexterity = 30,
  Strength = 75,
  Wisdom = 14,
  Leadership = 14,
  Marksmanship = 43,
  Mechanical = 0,
  Explosives = 65,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/RebelDemo",
  Name = T(357273448181, "Saboteur"),
  Randomization = true,
  Affiliation = "Rebel",
  StartingLevel = 2,
  neutral_retaliate = true,
  AIKeywords = {"Explosives"},
  archetype = "Skirmisher",
  role = "Demolitions",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "Throwing",
    "MinFreeMove",
    "NightOps"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Demolitions_Rebels"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Demolitions_Rebels_02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Demolitions_Rebels_03"
    })
  },
  Equipment = {
    "RebelGrenadier"
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
  pollyvoice = "Russell",
  gender = "Male",
  VoiceResponseId = "RebelSoldier"
}
