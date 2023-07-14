UndefineClass("AdonisSniper_Elite")
DefineClass.AdonisSniper_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 71,
  Agility = 90,
  Dexterity = 100,
  Strength = 85,
  Wisdom = 80,
  Leadership = 20,
  Marksmanship = 80,
  Mechanical = 50,
  Explosives = 42,
  Medical = 53,
  Portrait = "UI/EnemiesPortraits/AdonisSniper",
  Name = T(935215359693, "Elite Marksman"),
  Randomization = true,
  elite = true,
  eliteCategory = "Foreigners",
  Affiliation = "Adonis",
  StartingLevel = 5,
  neutral_retaliate = true,
  AIKeywords = {"Sniper"},
  role = "Marksman",
  AlwaysUseOpeningAttack = true,
  OpeningAttackType = "PinDown",
  MaxAttacks = 1,
  PickCustomArchetype = function(self, proto_context)
    local enemy, dist = GetNearestEnemy(self)
    local archetype = self.archetype
    local weapon_class = "Firearm"
    if enemy and dist < 5 * const.SlabSizeX then
      archetype = "Skirmisher"
      weapon_class = "Revolver"
      PlayVoiceResponse(self, "AIArchetypeScared")
    end
    if not self:GetActiveWeapons(weapon_class) then
      AIPlayCombatAction("ChangeWeapon", self, 0)
    end
    return archetype
  end,
  MaxHitPoints = 50,
  StartingPerks = {
    "Deadeye",
    "Shatterhand"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Adonis_Marksman"
    })
  },
  Equipment = {
    "AdonisSniper"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "AdonisMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "AdonisMale_2"
    })
  },
  Tier = "Veteran",
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "AdonisAssault"
}
