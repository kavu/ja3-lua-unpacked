UndefineClass("HeadshotHue")
DefineClass.HeadshotHue = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Strength = 40,
  Wisdom = 75,
  Leadership = 50,
  Marksmanship = 75,
  Mechanical = 0,
  Explosives = 0,
  Medical = 25,
  Portrait = "UI/NPCsPortraits/HeadshotHue",
  BigPortrait = "UI/NPCs/HeadshotHue",
  Name = T(179633927451, "Headshot Hue"),
  Randomization = true,
  Affiliation = "Other",
  ImportantNPC = true,
  MaxAttacks = 2,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "HeadshotHue"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  PersistentSessionId = "NPC_HeadshotHue"
}
