UndefineClass("DiamondRedBossAlly")
DefineClass.DiamondRedBossAlly = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Agility = 90,
  Dexterity = 95,
  Strength = 40,
  Wisdom = 99,
  Leadership = 15,
  Marksmanship = 75,
  Mechanical = 34,
  Explosives = 8,
  Medical = 7,
  Portrait = "UI/NPCsPortraits/SlaveMasterGraaf",
  BigPortrait = "UI/NPCs/SlaveMasterGraaf",
  Name = T(797119179953, "Slave Master Graaf"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 6,
  ImportantNPC = true,
  neutral_retaliate = true,
  archetype = "TurretBoss",
  role = "Commander",
  PinnedDownChance = 0,
  MaxAttacks = 2,
  PickCustomArchetype = function(self, proto_context)
  end,
  CustomEquipGear = function(self, items)
  end,
  Lives = 1,
  StartingPerks = {
    "Deadeye",
    "DeathFromAbove"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "MineForeman"
    })
  },
  Equipment = {
    "DiamondRedBoss"
  },
  Tier = "Veteran",
  gender = "Male",
  PersistentSessionId = "NPC_Graaf",
  VoiceResponseId = "DiamondRedBoss"
}
