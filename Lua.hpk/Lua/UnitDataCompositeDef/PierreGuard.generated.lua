UndefineClass("PierreGuard")
DefineClass.PierreGuard = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 57,
  Agility = 70,
  Dexterity = 40,
  Strength = 53,
  Wisdom = 40,
  Leadership = 10,
  Marksmanship = 63,
  Mechanical = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionRaider",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(526151465586, "Pierre's Guard"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 4,
  neutral_retaliate = true,
  AIKeywords = {"RunAndGun"},
  role = "Stormer",
  MaxAttacks = 2,
  PickCustomArchetype = function(self, proto_context)
    local enemy, dist = GetNearestEnemy(self)
    local archetype = self.archetype
    local weapon_class = "Firearm"
    if enemy and dist < 5 * const.SlabSizeX then
      weapon_class = "MeleeWeapon"
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
    "AutoWeapons"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier03"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier04"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier05"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier06"
    })
  },
  Equipment = {
    "PierreGuard"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Name",
      "LegionMale_2"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
