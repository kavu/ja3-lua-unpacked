UndefineClass("Bonecrusher")
DefineClass.Bonecrusher = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 100,
  Agility = 95,
  Dexterity = 70,
  Strength = 100,
  Wisdom = 0,
  Leadership = 0,
  Marksmanship = 0,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(671608460419, "The Bonecrusher"),
  Affiliation = "Other",
  StartingLevel = 5,
  neutral_retaliate = true,
  archetype = "Brute",
  role = "Stormer",
  CanManEmplacements = false,
  MaxAttacks = 2,
  CustomEquipGear = function(self, items)
  end,
  StartingPerks = {
    "ColdHeart",
    "Berserker",
    "BloodScent",
    "BeefedUp"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Bonecrusher"
    })
  },
  Equipment = {
    "Civilian_Unarmed"
  },
  pollyvoice = "Russell",
  gender = "Male",
  PersistentSessionId = "NPC_Bonecrusher"
}
