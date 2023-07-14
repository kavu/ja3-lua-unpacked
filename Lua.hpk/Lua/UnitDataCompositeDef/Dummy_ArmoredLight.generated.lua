UndefineClass("Dummy_ArmoredLight")
DefineClass.Dummy_ArmoredLight = {
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
  Name = T(570364748950, "Light Armored Dummy"),
  reincarnate = true,
  dummy = true,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Commando_Foreign_01"
    })
  },
  Equipment = {
    "DummyArmorLight",
    "DummyGun"
  },
  gender = "Male"
}
