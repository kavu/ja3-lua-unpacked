UndefineClass("LegionManiac_Stronger")
DefineClass.LegionManiac_Stronger = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 96,
  Agility = 70,
  Dexterity = 58,
  Strength = 95,
  Wisdom = 16,
  Leadership = 65,
  Marksmanship = 34,
  Mechanical = 0,
  Explosives = 33,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionStormer",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(464735862333, "Veteran Brute"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 3,
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
      "Legion_Stormer"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Stormer02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Stormer03"
    })
  },
  Equipment = {
    "LegionBerserker_Stronger"
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
