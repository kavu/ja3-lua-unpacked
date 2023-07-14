UndefineClass("Pastor")
DefineClass.Pastor = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Agility = 30,
  Strength = 50,
  Leadership = 80,
  Marksmanship = 40,
  Mechanical = 20,
  Explosives = 0,
  Medical = 10,
  Portrait = "UI/NPCsPortraits/Pastor",
  BigPortrait = "UI/NPCs/Pastor",
  Name = T(196207594320, "Father Tooker"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  archetype = "Brute",
  MaxAttacks = 2,
  RewardExperience = 0,
  MaxHitPoints = 60,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Pastor"})
  },
  Equipment = {
    "Civilian_Unarmed",
    "Diamonds_Loot"
  },
  pollyvoice = "Matthew",
  gender = "Male"
}
