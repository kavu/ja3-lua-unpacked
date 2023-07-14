UndefineClass("PrisonerJailBird")
DefineClass.PrisonerJailBird = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 76,
  Agility = 89,
  Dexterity = 65,
  Strength = 88,
  Wisdom = 30,
  Leadership = 15,
  Marksmanship = 69,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ThugArtillery",
  Name = T(713035632624, "Prisoner"),
  Randomization = true,
  Affiliation = "Other",
  neutral_retaliate = true,
  role = "Soldier",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Prisoner_01"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Prisoner_02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Prisoner_03"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Prisoner_04"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Prisoner_05"
    })
  },
  Equipment = {
    "Civilian_Unarmed"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {"Name", "ThugMale_1"})
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "ThugGunner"
}
