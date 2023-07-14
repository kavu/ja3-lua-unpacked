UndefineClass("Grotto_Loony")
DefineClass.Grotto_Loony = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 90,
  Agility = 90,
  Dexterity = 90,
  Strength = 90,
  Wisdom = 90,
  Leadership = 90,
  Marksmanship = 90,
  Mechanical = 30,
  Explosives = 30,
  Medical = 30,
  Portrait = "UI/EnemiesPortraits/InfectedMale05",
  Name = T(449366935858, "Toon Looney"),
  Affiliation = "Other",
  StartingLevel = 7,
  neutral_retaliate = true,
  role = "Marksman",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "MinFreeMove",
    "Deadeye",
    "ColdHeart",
    "TrickShot"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Marksman_Thugs"
    })
  },
  Equipment = {
    "Grotto_Looney"
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
