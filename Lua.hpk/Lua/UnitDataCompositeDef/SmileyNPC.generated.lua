UndefineClass("SmileyNPC")
DefineClass.SmileyNPC = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 82,
  Agility = 78,
  Dexterity = 56,
  Strength = 73,
  Wisdom = 62,
  Leadership = 54,
  Marksmanship = 72,
  Mechanical = 5,
  Explosives = 5,
  Portrait = "UI/MercsPortraits/Smiley",
  BigPortrait = "UI/Mercs/Smiley",
  Name = T(677179507992, "Smiley"),
  Nick = T(235350716572, "Smiley"),
  AllCapsNick = T(699415768763, "SMILEY"),
  Affiliation = "Secret",
  Bio = T(374645251597, "Alejandro \"Smiley\" Diaz came to Grand Chien as mercenary serving some unknown small group - which got totally obliterated by the Major a few weeks before your encounter with him. An Arulco native, he is eager to join up with you as A.I.M. is held in great regard in the new order back at his home country."),
  StartingLevel = 2,
  ImportantNPC = true,
  MaxAttacks = 2,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "SniperRifle")
    self:TryEquip(items, "Handheld B", "SubmachineGun")
  end,
  RewardExperience = 0,
  MaxHitPoints = 85,
  StartingPerks = {
    "AutoWeapons"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Smiley"})
  },
  Equipment = {"Smiley"},
  Tier = "Elite",
  Specialization = "Doctor",
  gender = "Male",
  PersistentSessionId = "NPC_Smiley",
  VoiceResponseId = "Smiley"
}
