UndefineClass("ArmyRPG")
DefineClass.ArmyRPG = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 45,
  Agility = 83,
  Dexterity = 8,
  Strength = 88,
  Wisdom = 14,
  Leadership = 10,
  Marksmanship = 12,
  Mechanical = 0,
  Explosives = 62,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ArmyArtillery",
  Name = T(764168708253, "Heavy Trooper"),
  Randomization = true,
  Affiliation = "Army",
  StartingLevel = 4,
  neutral_retaliate = true,
  AIKeywords = {"Ordnance"},
  role = "Artillery",
  CanManEmplacements = false,
  MaxAttacks = 1,
  MaxHitPoints = 50,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "GrandChien_Artillery"
    })
  },
  Equipment = {"ArmyRPG"},
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "ArmyMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "ArmyMale_2"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "ArmySoldier"
}
