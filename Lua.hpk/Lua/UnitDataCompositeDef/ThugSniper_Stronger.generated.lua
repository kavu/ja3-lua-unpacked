UndefineClass("ThugSniper_Stronger")
DefineClass.ThugSniper_Stronger = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 76,
  Agility = 91,
  Dexterity = 69,
  Strength = 81,
  Wisdom = 37,
  Leadership = 50,
  Marksmanship = 85,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ThugSniper",
  Name = T(267654402872, "Tough Headhunter"),
  Randomization = true,
  Affiliation = "Thugs",
  StartingLevel = 5,
  neutral_retaliate = true,
  AIKeywords = {"Sniper"},
  role = "Marksman",
  AlwaysUseOpeningAttack = true,
  OpeningAttackType = "PinDown",
  MaxAttacks = 1,
  MaxHitPoints = 50,
  StartingPerks = {
    "MinFreeMove",
    "Shatterhand",
    "LightningReactionNPC"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Marksman"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Marksman_1"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Marksman_2"
    })
  },
  Equipment = {
    "ThugSniper_Stronger"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "ThugMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "ThugMale_2"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "ThugGunner"
}
