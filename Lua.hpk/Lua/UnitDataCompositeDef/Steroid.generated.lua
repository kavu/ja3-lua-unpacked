UndefineClass("Steroid")
DefineClass.Steroid = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 100,
  Agility = 56,
  Dexterity = 48,
  Strength = 97,
  Wisdom = 61,
  Leadership = 9,
  Marksmanship = 89,
  Mechanical = 76,
  Explosives = 13,
  Medical = 22,
  Portrait = "UI/MercsPortraits/Steroid",
  BigPortrait = "UI/Mercs/Steroid",
  Name = T(191942662733, "Bobby \"Steroid\" Gontarski"),
  Nick = T(547412809082, "Steroid"),
  AllCapsNick = T(413371651152, "STEROID"),
  Bio = T(456387407873, "From fighting fires in Warsaw to winning firefights in Arulco, Bobby Gontarski uses his considerable strength and endurance to bend every encounter to his will. His skills with tools and gadgets are a nice bonus to his fine marksmanship and indomitable spirit. Steroid confronts every challenge with dogged determination, using his impressive stamina to always make sure his persistence pays off."),
  Nationality = "Poland",
  Title = T(545683006311, "The Performance-enhanced Pole"),
  Email = T(836836892923, "bobby@aim.com"),
  snype_nick = T(161230893072, "bobby"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(494152129582, "You have Ivan on your team? Then you DON'T want ME. I don't work with people like him.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Ivan"})
      }
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(144466457355, "I do not work with Communist like Igor. I sooner work with Germans.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Igor"})
      }
    })
  },
  Haggles = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(139476577458, "Many peoples die for you. I am not a person with death wish. Perhaps you can improve offer, yes?")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionDeathToll", {PresetValue = "2+"})
      },
      "chanceToRoll",
      100
    })
  },
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(621647051327, "This is not ideal job, but you have Grizzly and he is good fighter and work-out partner. All right. ")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Grizzly"})
      },
      "chanceToRoll",
      100
    })
  },
  ExtraPartingWords = {
    PlaceObj("MercChatBranch", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(597080364679, "I need job, so I say yes. But you must understand that I do not like Ivan Dolvich. Please keep many trees between us.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Ivan"})
      }
    }),
    PlaceObj("MercChatBranch", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(558558300486, "To be forced to work with Igor Dolvich does not make me happy. Please keep him and his stinky communism away from me.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Igor"})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(144300816928, "Robert Gontarski is, umm, unavoidable right now. Maybe I get in touch with you, maybe not.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(853380302875, "This is Bobby Gontarski. Do you have business?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(369484340930, "Back from your work-out? Me, too. Let us eat protein bars and discuss business.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(799080241348, "Why so quiet? You getting in some reps?")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(508884817963, "I thank you for, umm, giving me the business. I see you.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(818850924401, "My contract is almost at completion. Do you want to see more of what these biceps can do?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(851247417827, "Very good! I am excited to pummel more bad people for you.")
    })
  },
  MedicalDeposit = "none",
  Haggling = "low",
  StartingSalary = 800,
  SalaryIncrease = 240,
  SalaryLv1 = 780,
  SalaryMaxLv = 4700,
  LegacyNotes = [[
The transition from fighting fires to firefights has gone rather well for this ex-fireman from Warsaw. His knowledge of mechanics kept the out- dated and under-funded Polish firehouse running. His eagle-eyed vision and pumped-up persistence, now keeps the enemy on the run.

Additional info:

Gontarski refuses to submit to urine testing.]],
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "Firearm")
    self:TryEquip(items, "Handheld B", "MeleeWeapon")
  end,
  MaxHitPoints = 99,
  Likes = {"Larry", "Grizzly"},
  LearnToLike = {"Kalyna"},
  Dislikes = {"Ivan", "Igor"},
  LearnToDislike = {"Omryn"},
  StartingPerks = {
    "MrFixit",
    "SteroidPunch"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Steroid"})
  },
  Equipment = {"Steroid"},
  Specialization = "Mechanic",
  gender = "Male",
  blocked_spots = set("Weaponls", "Weaponrs"),
  VoiceResponseId = "Steroid"
}
