UndefineClass("ThugEnforcer")
DefineClass.ThugEnforcer = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 75,
  Agility = 69,
  Dexterity = 93,
  Strength = 95,
  Wisdom = 16,
  Leadership = 65,
  Marksmanship = 43,
  Mechanical = 0,
  Explosives = 33,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ThugStormer",
  Name = T(783266701759, "Enforcer"),
  Randomization = true,
  Affiliation = "Thugs",
  StartingLevel = 3,
  neutral_retaliate = true,
  archetype = "Brute",
  role = "Stormer",
  MaxAttacks = 2,
  PickCustomArchetype = function(self, proto_context)
    local enemy, dist = GetNearestEnemy(self)
    local archetype = self.archetype
    local weapon_class = "Firearm"
    if enemy and dist < 8 * const.SlabSizeX then
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
    "Berserker",
    "BeefedUp",
    "MinFreeMove",
    "Shatterhand"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Stormer"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Stormer_1"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Stormer_2"
    })
  },
  Equipment = {
    "ThugEnforcer"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "ThugMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "ThugMale_2"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "ThugGunner"
}
