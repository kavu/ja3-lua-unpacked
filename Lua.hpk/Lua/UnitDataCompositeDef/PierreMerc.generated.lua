UndefineClass("PierreMerc")
DefineClass.PierreMerc = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 81,
  Agility = 72,
  Dexterity = 68,
  Strength = 78,
  Wisdom = 56,
  Leadership = 39,
  Marksmanship = 77,
  Mechanical = 5,
  Explosives = 15,
  Medical = 12,
  Portrait = "UI/MercsPortraits/Pierre",
  BigPortrait = "UI/Mercs/Pierre",
  Name = T(232743658474, "Pierre Laurent"),
  Nick = T(873651462548, "Pierre"),
  AllCapsNick = T(612136728344, "PIERRE"),
  Affiliation = "Secret",
  Nationality = "GrandChien",
  Title = T(201430117731, "Welcome to the Jungle"),
  SalaryLv1 = 0,
  SalaryMaxLv = 0,
  LegacyNotes = "A local boy who joined the Legion years ago in a pursuit of adventure, and grew up to become a Legion warlord. He recently returned to Ernie with a band of raiders, only to rob his home town and break the heart of his father. \nYet he is as a person who lives by his own code \226\128\147 he dislikes unneeded violence and did restrain his Legion thugs from doing too much mischief.",
  StartingLevel = 3,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "Firearm")
    self:TryEquip(items, "Handheld B", "MeleeWeapon")
  end,
  LearnToLike = {"Flay"},
  LearnToDislike = {"Grizzly"},
  StartingPerks = {
    "AutoWeapons",
    "GloryHog",
    "OptimalPerformance",
    "BloodlustPerk"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Pierre"})
  },
  Equipment = {"Pierre"},
  Specialization = "Leader",
  gender = "Male",
  PersistentSessionId = "NPC_Pierre"
}
