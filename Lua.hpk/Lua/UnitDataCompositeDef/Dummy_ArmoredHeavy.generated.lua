UndefineClass("Dummy_ArmoredHeavy")
DefineClass.Dummy_ArmoredHeavy = {
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
  Name = T(723432081096, "Heavily Armored Dummy"),
  reincarnate = true,
  dummy = true,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Commando_Foreign_01"
    })
  },
  Equipment = {
    "DummyArmorHeavy",
    "DummyGun"
  },
  gender = "Male"
}
