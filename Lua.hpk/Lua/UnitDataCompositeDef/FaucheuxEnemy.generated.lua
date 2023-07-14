UndefineClass("FaucheuxEnemy")
DefineClass.FaucheuxEnemy = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 77,
  Agility = 91,
  Dexterity = 95,
  Strength = 53,
  Wisdom = 94,
  Leadership = 82,
  Marksmanship = 64,
  Mechanical = 37,
  Explosives = 32,
  Medical = 31,
  Portrait = "UI/NPCsPortraits/Faucheux",
  BigPortrait = "UI/NPCs/Faucheux",
  Name = T(780992505395, "Colonel Faucheux"),
  Randomization = true,
  Affiliation = "Army",
  StartingLevel = 7,
  ImportantNPC = true,
  villain = true,
  neutral_retaliate = true,
  AIKeywords = {"Control"},
  role = "Commander",
  CanManEmplacements = false,
  AlwaysUseOpeningAttack = true,
  PinnedDownChance = 40,
  MaxAttacks = 2,
  CustomEquipGear = function(self, items)
  end,
  Lives = 4,
  MaxHitPoints = 50,
  StartingPerks = {
    "BeefedUp",
    "AutoWeapons",
    "Ironclad",
    "HoldPosition"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Faucheux"})
  },
  Equipment = {"Faucheaux"},
  pollyvoice = "Russell",
  gender = "Male",
  PersistentSessionId = "NPC_Faucheux",
  VoiceResponseId = "FaucheuxEnemy"
}
