UndefineClass("KingChicken")
DefineClass.KingChicken = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Agility = 50,
  Dexterity = 50,
  Strength = 50,
  Wisdom = 50,
  Leadership = 0,
  Marksmanship = 50,
  Mechanical = 0,
  Explosives = 0,
  Medical = 10,
  Portrait = "UI/NPCsPortraits/KingChicken",
  BigPortrait = "UI/NPCs/KingChicken",
  Name = T(209828903618, "King Chicken"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  archetype = "Brute",
  MaxAttacks = 2,
  RewardExperience = 0,
  MaxHitPoints = 60,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "KingChicken"
    })
  },
  pollyvoice = "Matthew",
  gender = "Male"
}
