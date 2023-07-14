UndefineClass("AdonisStormer_Elite")
DefineClass.AdonisStormer_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 80,
  Agility = 90,
  Dexterity = 75,
  Strength = 85,
  Wisdom = 80,
  Leadership = 20,
  Marksmanship = 95,
  Mechanical = 50,
  Explosives = 38,
  Medical = 47,
  Portrait = "UI/EnemiesPortraits/AdonisStormer",
  Name = T(694706196890, "Shock Assault Elite"),
  Randomization = true,
  eliteCategory = "Foreigners",
  Affiliation = "Adonis",
  StartingLevel = 7,
  neutral_retaliate = true,
  archetype = "Brute",
  role = "Stormer",
  AlwaysUseOpeningAttack = true,
  OpeningAttackType = "Overwatch",
  PinnedDownChance = 100,
  MaxAttacks = 2,
  PickCustomArchetype = function(self, proto_context)
    local enemy, dist = GetNearestEnemy(self)
    local archetype = self.archetype
    local weapon_class = "Firearm"
    if enemy and dist < 8 * const.SlabSizeX then
      weapon_class = "Shotgun"
      PlayVoiceResponse(self, "AIArchetypeAngry")
    end
    if not self:GetActiveWeapons(weapon_class) then
      AIPlayCombatAction("ChangeWeapon", self, 0)
    end
    return archetype
  end,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "Firearm")
    self:TryEquip(items, "Handheld B", "MeleeWeapon")
  end,
  MaxHitPoints = 50,
  StartingPerks = {
    "InstantAutopsy",
    "CQCTraining",
    "Shatterhand"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Adonis_Stormer"
    })
  },
  Equipment = {
    "AdonisStormer"
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
  Tier = "Elite",
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "AdonisAssault"
}
