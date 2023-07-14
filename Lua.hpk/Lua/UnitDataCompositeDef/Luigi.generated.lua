UndefineClass("Luigi")
DefineClass.Luigi = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Agility = 80,
  Dexterity = 70,
  Wisdom = 50,
  Marksmanship = 90,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/NPCsPortraits/Luigi",
  BigPortrait = "UI/NPCs/Luigi",
  Name = T(910905228234, "Luigi"),
  Randomization = true,
  Affiliation = "Other",
  StartingLevel = 3,
  ImportantNPC = true,
  neutral_retaliate = true,
  archetype = "Brute",
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
  Lives = 1,
  RetreatBehavior = "None",
  StartingPerks = {"Berserker", "BeefedUp"},
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Luigi"})
  },
  Equipment = {
    "FleatownMafioso"
  },
  pollyvoice = "Russell",
  gender = "Male",
  PersistentSessionId = "NPC_Luigi"
}
