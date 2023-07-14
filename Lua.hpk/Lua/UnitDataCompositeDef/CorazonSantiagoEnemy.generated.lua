UndefineClass("CorazonSantiagoEnemy")
DefineClass.CorazonSantiagoEnemy = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 100,
  Agility = 100,
  Dexterity = 100,
  Wisdom = 100,
  Leadership = 100,
  Marksmanship = 100,
  Mechanical = 0,
  Explosives = 0,
  Medical = 30,
  Portrait = "UI/NPCsPortraits/CorazonSantiago",
  BigPortrait = "UI/NPCs/CorazonSantiago",
  Name = T(330922548566, "Corazon Santiago"),
  Randomization = true,
  Affiliation = "Adonis",
  StartingLevel = 8,
  ImportantNPC = true,
  villain = true,
  neutral_retaliate = true,
  archetype = "CorazonBoss",
  role = "Commander",
  CanManEmplacements = false,
  MaxAttacks = 2,
  Lives = 4,
  DefeatBehavior = "Defeated",
  MaxHitPoints = 100,
  StartingPerks = {
    "TrickShot",
    "BattleFocus",
    "LightningReaction",
    "Hotblood",
    "RelentlessAdvance",
    "Ironclad"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "CorazonSantiago"
    })
  },
  Equipment = {
    "CorazonBoss"
  },
  pollyvoice = "Joanna",
  gender = "Female",
  PersistentSessionId = "NPC_Corazon",
  VoiceResponseId = "CorazonSantiagoEnemy"
}
