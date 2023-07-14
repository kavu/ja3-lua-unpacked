UndefineClass("ArmyStormer")
DefineClass.ArmyStormer = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 75,
  Agility = 70,
  Dexterity = 58,
  Strength = 95,
  Wisdom = 16,
  Leadership = 65,
  Marksmanship = 34,
  Mechanical = 0,
  Explosives = 33,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ArmyStormer",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(594579133313, "Shock Trooper"),
  Randomization = true,
  Affiliation = "Army",
  StartingLevel = 5,
  neutral_retaliate = true,
  archetype = "Brute",
  role = "Stormer",
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
  MaxHitPoints = 100,
  StartingPerks = {
    "BeefedUp",
    "MeleeTraining",
    "MinFreeMove",
    "Shatterhand"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "GrandChien_Stormer"
    })
  },
  Equipment = {
    "ArmyStormer"
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
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "ArmySoldier"
}
