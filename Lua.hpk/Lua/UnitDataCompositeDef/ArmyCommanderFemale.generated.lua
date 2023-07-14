UndefineClass("ArmyCommanderFemale")
DefineClass.ArmyCommanderFemale = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 85,
  Agility = 82,
  Dexterity = 80,
  Strength = 63,
  Wisdom = 62,
  Leadership = 73,
  Marksmanship = 80,
  Mechanical = 54,
  Explosives = 57,
  Medical = 45,
  Portrait = "UI/EnemiesPortraits/ArmyOfficer",
  Name = T(207883269479, "Lieutenant"),
  Randomization = true,
  Affiliation = "Army",
  StartingLevel = 5,
  neutral_retaliate = true,
  AIKeywords = {"Control", "Flank"},
  archetype = "Skirmisher",
  role = "Commander",
  MaxAttacks = 2,
  PickCustomArchetype = function(self, proto_context)
    local enemy, dist = GetNearestEnemy(self)
    local archetype = self.archetype
    local weapon_class = "Firearm"
    if enemy and dist < 12 * const.SlabSizeX then
      archetype = "Soldier"
      weapon_class = "Firearm"
      PlayVoiceResponse(self, "AIArchetypeAngry")
    end
    if not self:GetActiveWeapons(weapon_class) then
      AIPlayCombatAction("ChangeWeapon", self, 0)
    end
    return archetype
  end,
  MaxHitPoints = 80,
  StartingPerks = {"BeefedUp"},
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "GrandChien_CommanderFemale"
    })
  },
  Equipment = {
    "ArmyCommander",
    "RefugeeCamp_Leiutenant"
  },
  AdditionalGroups = {},
  Tier = "Elite",
  pollyvoice = "Kendra",
  gender = "Female",
  VoiceResponseId = "AnneLeMitrailleur",
  FallbackMissingVR = "VillagerFemale"
}
