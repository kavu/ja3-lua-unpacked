UndefineClass("PrisonerJoseph")
DefineClass.PrisonerJoseph = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 99,
  Agility = 74,
  Dexterity = 43,
  Strength = 97,
  Wisdom = 25,
  Leadership = 0,
  Marksmanship = 52,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionRaider",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(456544273605, "Joseph"),
  Randomization = true,
  Affiliation = "Other",
  neutral_retaliate = true,
  role = "Soldier",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "MeleeTraining",
    "BeefedUp",
    "InstantAutopsy",
    "BloodScent"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier05"
    })
  },
  Equipment = {
    "Luigi_Reward"
  },
  AdditionalGroups = {},
  pollyvoice = "Joey",
  gender = "Male",
  PersistentSessionId = "NPC_Joseph",
  VoiceResponseId = "ThugGunner"
}
