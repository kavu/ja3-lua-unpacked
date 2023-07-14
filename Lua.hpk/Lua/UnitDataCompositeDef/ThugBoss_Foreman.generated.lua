UndefineClass("ThugBoss_Foreman")
DefineClass.ThugBoss_Foreman = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 82,
  Agility = 76,
  Dexterity = 80,
  Strength = 75,
  Wisdom = 23,
  Leadership = 22,
  Marksmanship = 70,
  Mechanical = 12,
  Explosives = 14,
  Medical = 6,
  Portrait = "UI/EnemiesPortraits/ThugOfficer",
  Name = T(896063145050, "Foreman"),
  Randomization = true,
  Affiliation = "Thugs",
  StartingLevel = 5,
  neutral_retaliate = true,
  AIKeywords = {"Control"},
  role = "Commander",
  MaxAttacks = 2,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "Firearm")
    self:TryEquip(items, "Handheld B", "MeleeWeapon")
    self:TryLoadAmmo("Handheld A", "AssaultRifle", "_762WP_HP")
  end,
  MaxHitPoints = 80,
  StartingPerks = {
    "AutoWeapons",
    "Counterfire"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Officer"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Officer_1"
    })
  },
  Equipment = {
    "ThugBoss",
    "Foreman_Stash"
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
