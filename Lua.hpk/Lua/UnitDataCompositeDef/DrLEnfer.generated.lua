UndefineClass("DrLEnfer")
DefineClass.DrLEnfer = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 70,
  Agility = 50,
  Dexterity = 80,
  Strength = 50,
  Wisdom = 90,
  Leadership = 0,
  Marksmanship = 50,
  Mechanical = 0,
  Explosives = 0,
  Medical = 90,
  Portrait = "UI/NPCsPortraits/DrGenessier LEnfer",
  BigPortrait = "UI/NPCs/DrGenessier LEnfer",
  Name = T(923763786513, "Dr. G\195\169nessier L'Enfer"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  neutral_retaliate = true,
  MaxAttacks = 2,
  RewardExperience = 0,
  MaxHitPoints = 60,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Genessier"})
  },
  Equipment = {"LegionGoon"},
  gender = "Male"
}
