UndefineClass("ThugSniper_Stronger_Elite")
DefineClass.ThugSniper_Stronger_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 49,
  Agility = 91,
  Dexterity = 62,
  Wisdom = 55,
  Leadership = 50,
  Marksmanship = 85,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ThugSniper",
  Name = T(480850552739, "Badass Headhunter"),
  Randomization = true,
  Affiliation = "Thugs",
  StartingLevel = 7,
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
    "LightningReactionNPC",
    "Deadeye",
    "ColdHeart"
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
