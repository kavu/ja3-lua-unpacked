UndefineClass("MrGattz")
DefineClass.MrGattz = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 65,
  Agility = 95,
  Dexterity = 95,
  Wisdom = 85,
  Leadership = 10,
  Marksmanship = 78,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(526524848807, "Mr. Gattz"),
  Randomization = true,
  Affiliation = "Civilian",
  StartingLevel = 6,
  ImportantNPC = true,
  neutral_retaliate = true,
  archetype = "Skirmisher",
  AlwaysUseOpeningAttack = true,
  StartingPerks = {
    "LightningReactionNPC",
    "StealthKillDefense",
    "NaturalCamouflage",
    "Instagib",
    "Shatterhand",
    "TrickShot"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "MrGattz"})
  },
  Equipment = {"MrGattz"},
  gender = "Male",
  PersistentSessionId = "NPC_Gattz"
}
