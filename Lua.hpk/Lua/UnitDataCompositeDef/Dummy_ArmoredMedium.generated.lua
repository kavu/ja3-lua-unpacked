UndefineClass("Dummy_ArmoredMedium")
DefineClass.Dummy_ArmoredMedium = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 100,
  Agility = 100,
  Dexterity = 100,
  Strength = 100,
  Wisdom = 100,
  Leadership = 100,
  Marksmanship = 100,
  Mechanical = 100,
  Explosives = 100,
  Medical = 100,
  Portrait = "UI/MercsPortraits/unknown",
  Name = T(139733332496, "Medium Armored Dummy"),
  reincarnate = true,
  dummy = true,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Commando_Foreign_01"
    })
  },
  Equipment = {
    "DummyArmorMedium",
    "DummyGun"
  },
  gender = "Male"
}
