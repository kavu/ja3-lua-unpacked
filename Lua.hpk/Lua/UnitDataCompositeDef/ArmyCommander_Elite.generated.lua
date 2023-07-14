UndefineClass("ArmyCommander_Elite")
DefineClass.ArmyCommander_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 90,
  Agility = 89,
  Dexterity = 90,
  Strength = 63,
  Wisdom = 62,
  Leadership = 73,
  Marksmanship = 85,
  Mechanical = 54,
  Explosives = 57,
  Medical = 45,
  Portrait = "UI/EnemiesPortraits/ArmyOfficer",
  Name = T(651275698504, "Lieutenant"),
  Randomization = true,
  elite = true,
  Affiliation = "Army",
  StartingLevel = 8,
  neutral_retaliate = true,
  AIKeywords = {"Control"},
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
      "GrandChien_Officer"
    })
  },
  Equipment = {
    "ArmyCommander"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "ArmyMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "ArmyMale_2"
    })
  },
  Tier = "Elite",
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "ArmySoldier"
}
