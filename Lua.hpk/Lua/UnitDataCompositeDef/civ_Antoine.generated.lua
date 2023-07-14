UndefineClass("civ_Antoine")
DefineClass.civ_Antoine = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Agility = 40,
  Dexterity = 40,
  Wisdom = 20,
  Leadership = 0,
  Marksmanship = 40,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ThugSoldier",
  Name = T(629150905811, "Antoine"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  MaxAttacks = 1,
  RewardExperience = 0,
  MaxHitPoints = 60,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "civ_Antoine"
    })
  },
  pollyvoice = "Matthew",
  gender = "Male",
  PersistentSessionId = "NPC_Antoine"
}
