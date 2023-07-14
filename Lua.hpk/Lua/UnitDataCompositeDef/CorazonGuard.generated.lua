UndefineClass("CorazonGuard")
DefineClass.CorazonGuard = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 80,
  Agility = 90,
  Dexterity = 75,
  Strength = 85,
  Wisdom = 80,
  Leadership = 20,
  Marksmanship = 95,
  Mechanical = 0,
  Explosives = 0,
  Medical = 25,
  Portrait = "UI/EnemiesPortraits/AdonisSoldier",
  Name = T(574676973785, "Guard"),
  Randomization = true,
  Affiliation = "Adonis",
  immortal = true,
  MaxAttacks = 2,
  MaxHitPoints = 80,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Adonis_Stormer"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Adonis_Recon"
    })
  },
  Equipment = {
    "AdonisGuard"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Name",
      "AdonisMale_1"
    })
  },
  pollyvoice = "Russell",
  gender = "Male"
}
