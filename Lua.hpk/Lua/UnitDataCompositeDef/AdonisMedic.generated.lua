UndefineClass("AdonisMedic")
DefineClass.AdonisMedic = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 65,
  Agility = 91,
  Dexterity = 58,
  Strength = 53,
  Wisdom = 58,
  Leadership = 58,
  Marksmanship = 66,
  Mechanical = 41,
  Explosives = 39,
  Medical = 93,
  Portrait = "UI/EnemiesPortraits/AdonisMedic",
  Name = T(216715618928, "Medic"),
  Randomization = true,
  Affiliation = "Adonis",
  StartingLevel = 7,
  neutral_retaliate = true,
  archetype = "Medic",
  role = "Medic",
  MaxAttacks = 1,
  unitPowerModifier = 65,
  MaxHitPoints = 80,
  StartingPerks = {
    "Savior",
    "Caretaker",
    "Shatterhand",
    "Hotblood"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Adonis_Medic"
    })
  },
  Equipment = {
    "AdonisMedic"
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
  Tier = "Elite",
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "AdonisAssault"
}
