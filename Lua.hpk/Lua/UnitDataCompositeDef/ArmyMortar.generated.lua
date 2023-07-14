UndefineClass("ArmyMortar")
DefineClass.ArmyMortar = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 45,
  Agility = 75,
  Dexterity = 8,
  Strength = 96,
  Wisdom = 14,
  Leadership = 10,
  Marksmanship = 50,
  Mechanical = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ArmyArtillery",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(966979487626, "Field Mortar"),
  Randomization = true,
  Affiliation = "Army",
  StartingLevel = 4,
  neutral_retaliate = true,
  AIKeywords = {"Ordnance"},
  archetype = "Artillery",
  role = "Artillery",
  CanManEmplacements = false,
  MaxAttacks = 1,
  PickCustomArchetype = function(self, proto_context)
    local enemy, dist = GetNearestEnemy(self)
    local archetype = self.archetype
    local weapon_class = "Firearm"
    if GameState.Underground or enemy and dist < 6 * const.SlabSizeX then
      archetype = "Soldier"
      weapon_class = "AssaultRifle"
      PlayVoiceResponse(self, "AIArchetypeScared")
    end
    if not self:GetActiveWeapons(weapon_class) then
      AIPlayCombatAction("ChangeWeapon", self, 0)
    end
    return archetype
  end,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "HeavyWeapon")
    self:TryEquip(items, "Handheld B", "AssaultRifle")
  end,
  MaxHitPoints = 50,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "GrandChien_Artillery"
    })
  },
  Equipment = {"ArmyMortar"},
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
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "ArmySoldier"
}
