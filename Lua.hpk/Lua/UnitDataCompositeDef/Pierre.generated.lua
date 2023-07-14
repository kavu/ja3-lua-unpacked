UndefineClass("Pierre")
DefineClass.Pierre = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 81,
  Agility = 72,
  Dexterity = 68,
  Strength = 65,
  Wisdom = 56,
  Leadership = 39,
  Marksmanship = 77,
  Mechanical = 5,
  Explosives = 15,
  Medical = 12,
  Portrait = "UI/MercsPortraits/Pierre",
  BigPortrait = "UI/Mercs/Pierre",
  Name = T(401395987194, "Pierre"),
  Affiliation = "Legion",
  StartingLevel = 6,
  ImportantNPC = true,
  villain = true,
  neutral_retaliate = true,
  role = "Commander",
  CanManEmplacements = false,
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
  DefeatBehavior = "Defeated",
  MaxHitPoints = 40,
  StartingPerks = {
    "AutoWeapons",
    "GloryHog",
    "OptimalPerformance",
    "BloodlustPerk",
    "Ironclad"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Pierre"})
  },
  Equipment = {"Pierre"},
  gender = "Male",
  PersistentSessionId = "NPC_Pierre"
}
