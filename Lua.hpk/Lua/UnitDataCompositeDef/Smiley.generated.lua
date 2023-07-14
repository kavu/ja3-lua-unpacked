UndefineClass("Smiley")
DefineClass.Smiley = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 82,
  Agility = 78,
  Dexterity = 56,
  Strength = 73,
  Wisdom = 55,
  Leadership = 54,
  Marksmanship = 77,
  Mechanical = 5,
  Explosives = 5,
  Medical = 36,
  Portrait = "UI/MercsPortraits/Smiley",
  BigPortrait = "UI/Mercs/Smiley",
  Name = T(607241134056, "Alejandro \"Smiley\" Diaz"),
  Nick = T(623933115537, "Smiley"),
  AllCapsNick = T(904548406102, "SMILEY"),
  Affiliation = "Secret",
  HireStatus = "NotMet",
  Bio = T(660209893656, "Alejandro \"Smiley\" Diaz came to Grand Chien as mercenary serving some unknown small group - which got totally obliterated by the Major a few weeks before your encounter with him. An Arulco native, he is eager to join up with you as A.I.M. is held in great regard in the new order back at his home country."),
  Nationality = "Arulco",
  Title = T(599631305679, "Romeo in Combat Fatigues"),
  SalaryLv1 = 0,
  SalaryMaxLv = 0,
  StartingLevel = 2,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "SubmachineGun")
    self:TryEquip(items, "Handheld B", "SniperRifle")
  end,
  MaxHitPoints = 85,
  LearnToLike = {
    "Kalyna",
    "Fox",
    "Buns"
  },
  StartingPerks = {
    "AutoWeapons",
    "Optimist",
    "RecklessAssault",
    "BeefedUp"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Smiley"})
  },
  Equipment = {"Smiley"},
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {"Name", "SmileyNPC"})
  },
  Specialization = "AllRounder",
  gender = "Male",
  VoiceResponseId = "Smiley"
}
