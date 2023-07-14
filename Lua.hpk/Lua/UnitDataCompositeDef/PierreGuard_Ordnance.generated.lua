UndefineClass("PierreGuard_Ordnance")
DefineClass.PierreGuard_Ordnance = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 57,
  Agility = 70,
  Dexterity = 40,
  Strength = 53,
  Wisdom = 40,
  Leadership = 10,
  Marksmanship = 63,
  Mechanical = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionRaider",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(784278021240, "Pierre's Guard"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 4,
  neutral_retaliate = true,
  role = "Soldier",
  MaxAttacks = 2,
  CustomEquipGear = function(self, items)
    self:TryLoadAmmo("Handheld A", "AssaultRifle", "_762WP_Basic")
    self:TryLoadAmmo("Handheld A", "GrenadeLauncher_M14", "_40mmFlashbangGrenade")
  end,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier03"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier04"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier05"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier06"
    })
  },
  Equipment = {
    "PierreGuard_Ordnance"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Name",
      "LegionMale_2"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
