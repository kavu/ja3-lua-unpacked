UndefineClass("IMP_male_02")
DefineClass.IMP_male_02 = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 30,
  Agility = 30,
  Dexterity = 30,
  Strength = 30,
  Wisdom = 30,
  Leadership = 30,
  Marksmanship = 30,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/MercsPortraits/IMP_Gunner",
  BigPortrait = "UI/Mercs/IMP_Gunner",
  Name = T(708270634897, "Alpha"),
  Nick = T(352334064943, "Alpha"),
  AllCapsNick = T(449093235074, "ALPHA"),
  Affiliation = "Other",
  HireStatus = "NotMet",
  Bio = T(189820268743, "A merc based on your I.M.P. evaluation."),
  Refusals = {},
  HaggleRehire = {},
  Offline = {},
  GreetingAndOffer = {},
  ConversationRestart = {},
  IdleLine = {},
  PartingWords = {},
  RehireIntro = {},
  RehireOutro = {},
  SalaryLv1 = 0,
  SalaryMaxLv = 0,
  MaxHitPoints = 80,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "IMP_Male_02"
    })
  },
  Equipment = {
    "IMP_equipment_basic"
  },
  Specialization = "AllRounder",
  pollyvoice = "Geraint",
  gender = "Male",
  VoiceResponseId = "IMP_male_01"
}
