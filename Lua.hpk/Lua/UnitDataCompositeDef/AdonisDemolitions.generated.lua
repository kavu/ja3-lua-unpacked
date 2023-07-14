UndefineClass("AdonisDemolitions")
DefineClass.AdonisDemolitions = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 63,
  Agility = 72,
  Strength = 81,
  Wisdom = 30,
  Leadership = 31,
  Marksmanship = 50,
  Mechanical = 0,
  Explosives = 50,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/AdonisDemo",
  Name = T(492629056557, "Ordnance Expert"),
  Randomization = true,
  Affiliation = "Adonis",
  StartingLevel = 6,
  neutral_retaliate = true,
  AIKeywords = {"Ordnance", "Explosives"},
  role = "Artillery",
  MaxAttacks = 2,
  PickCustomArchetype = function(self, proto_context)
    local enemy, dist = GetNearestEnemy(self)
    local archetype = self.archetype
    local weapon_class = "GrenadeLauncher"
    if enemy and dist < 7 * const.SlabSizeX then
      archetype = "Skirmisher"
      weapon_class = "Firearm"
      PlayVoiceResponse(self, "AIArchetypeScared")
    end
    if not self:GetActiveWeapons(weapon_class) then
      AIPlayCombatAction("ChangeWeapon", self, 0)
    end
    return archetype
  end,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "GrenadeLauncher")
    self:TryEquip(items, "Handheld B", "Firearm")
  end,
  unitPowerModifier = 75,
  MaxHitPoints = 50,
  StartingPerks = {"Throwing", "Berserker"},
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Adonis_Demolition"
    })
  },
  Equipment = {
    "AdonisDemolitions"
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
  pollyvoice = "Russell",
  gender = "Male",
  VoiceResponseId = "AdonisAssault"
}
