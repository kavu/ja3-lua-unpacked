UndefineClass("DiamondRedBoss")
DefineClass.DiamondRedBoss = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 65,
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
  Name = T(668718317292, "Slave Master Graaf"),
  Affiliation = "Legion",
  StartingLevel = 6,
  ImportantNPC = true,
  villain = true,
  neutral_retaliate = true,
  archetype = "TurretBoss",
  role = "Commander",
  AlwaysUseOpeningAttack = true,
  OpeningAttackType = "PinDown",
  PinnedDownChance = 0,
  PickCustomArchetype = function(self, proto_context)
  end,
  CustomEquipGear = function(self, items)
  end,
  Lives = 1,
  DefeatBehavior = "Defeated",
  StartingPerks = {
    "Killzone",
    "DeathFromAbove",
    "HoldPosition",
    "TrickShot"
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
