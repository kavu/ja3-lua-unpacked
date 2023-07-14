UndefineClass("AdonisDemolitions_Elite")
DefineClass.AdonisDemolitions_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Agility = 72,
  Strength = 90,
  Wisdom = 30,
  Leadership = 31,
  Marksmanship = 50,
  Mechanical = 50,
  Explosives = 80,
  Medical = 34,
  Portrait = "UI/EnemiesPortraits/AdonisDemo",
  Name = T(623551901167, "Ordnance Master"),
  Randomization = true,
  elite = true,
  eliteCategory = "Foreigners",
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
