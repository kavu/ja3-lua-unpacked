UndefineClass("DiamondRedMiner")
DefineClass.DiamondRedMiner = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 13,
  Agility = 28,
  Dexterity = 30,
  Strength = 30,
  Wisdom = 30,
  Leadership = 0,
  Marksmanship = 30,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/MercsPortraits/unknown",
  Name = T(306104925562, "Miner"),
  Affiliation = "Civilian",
  archetype = "ActiveCivilian",
  MaxAttacks = 1,
  RewardExperience = 0,
  MaxHitPoints = 50,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Miner_01",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Miner_02",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Miner_03",
      "Weight",
      100
    })
  },
  Equipment = {
    "Civilian_Unarmed"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Exclusive",
      true,
      "Name",
      "CivilianMaleMiner_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Exclusive",
      true,
      "Name",
      "CivilianMaleMiner_2"
    }),
    PlaceObj("AdditionalGroup", {
      "Name",
      "CivilianMale_3"
    })
  },
  pollyvoice = "Matthew",
  gender = "Male"
}
