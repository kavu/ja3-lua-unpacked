UndefineClass("LegionMortarman")
DefineClass.LegionMortarman = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 28,
  Agility = 75,
  Dexterity = 8,
  Strength = 96,
  Wisdom = 14,
  Leadership = 10,
  Marksmanship = 50,
  Mechanical = 0,
  Explosives = 30,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionArtillery",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(464126401854, "Bomber Man"),
  Randomization = true,
  Affiliation = "Legion",
  neutral_retaliate = true,
  archetype = "Artillery",
  role = "Artillery",
  CanManEmplacements = false,
  MaxAttacks = 1,
  PickCustomArchetype = function(self, proto_context)
    local enemy, dist = GetNearestEnemy(self)
    local archetype = self.archetype
    local weapon_class = "Firearm"
    if GameState.Underground or enemy and dist < 5 * const.SlabSizeX then
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
      "Legion_Artillery"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Artillery02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Artillery03"
    })
  },
  Equipment = {
    "LegionMortarman"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "LegionMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "LegionMale_2"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
