UndefineClass("Igor")
DefineClass.Igor = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 90,
  Agility = 89,
  Dexterity = 74,
  Strength = 85,
  Wisdom = 81,
  Leadership = 4,
  Marksmanship = 78,
  Mechanical = 36,
  Explosives = 19,
  Medical = 17,
  Portrait = "UI/MercsPortraits/Igor",
  BigPortrait = "UI/Mercs/Igor",
  Name = T(951021360874, "Igor Dolvich"),
  Nick = T(242446641011, "Igor"),
  AllCapsNick = T(383779569786, "IGOR"),
  Bio = T(401565007653, "The proud nephew of Ivan, Igor is an exceptionally talented mercenary in his own right. Although still young, Igor has managed to already garner a reputation at A.I.M. for using toughness, courage, marksmanship and stealth to get the better of his foes. Still a ways off from ever matching his uncle's exploits, Igor is eager to live up to his name. A merc to watch!"),
  Nationality = "Russia",
  Title = T(753598137188, "Most Meritorious Merc"),
  Email = T(673794011457, "igorisgreatmerc@aim.com"),
  snype_nick = T(951768641593, "igorisgreatmerc"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(336851318657, "No! You kill uncle Ivan. Uncle was greatest! If he died working for you, then you are terrible commander. Igor is last Dolvich merc. Igor must stay alive.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Dead", TargetUnit = "Ivan"})
      }
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(387833852326, "No! You are terrible commander and uncle is dead. I will not be working with you anymore.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Dead", TargetUnit = "Ivan"})
      },
      "Type",
      "rehire"
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(122302977852, "Too many of those under your command return only in bits and pieces. I do not wish for certain death. I must dismiss your request.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionDeathToll", {PresetValue = "2+"})
      }
    })
  },
  Haggles = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(449010257088, "No! A.I.M. always try to give Igor low balls! Igor deserves more. This is better number.")
        })
      },
      "Conditions",
      {},
      "chanceToRoll",
      20
    })
  },
  HaggleRehire = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(604251052049, "I already show actions of greatness. I deserve more payment. ")
        })
      },
      "Conditions",
      {},
      "chanceToRoll",
      20
    })
  },
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(134926984200, "I am always honored to serve wherever my illustrious uncle chooses to serve. I accept!")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Ivan"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(424670207295, "I was going to tell you I do not want contract, but sweet little Kalinka is still here and she must be protected. I will stay, but I will need more money to help look out for her.")
        })
      },
      "Conditions",
      {
        PlaceObj("AND", {
          Conditions = {
            PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Kalyna"}),
            PlaceObj("MercIsLikedDisliked", {Object = "Kalyna", TargetUnit = "Igor"})
          }
        })
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
          T(689959628569, "You must hire Uncle Ivan. He is greatest. He will come and see I am worthy of Dolvich name. But now we must drink. I go get bottle.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Ivan"})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(100640650018, "This is Igor. Igor is a great mercenary. Almost all previous commanders gave Igor praise. Call again to hire Igor please.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(103428746749, "This is Igor. Igor is great mercenary. Like uncle who is also great. What is job?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(513452735443, "Had to stop conversation to drink with friends? No worries. We continue.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(710657353028, "Are you there? It is vodka time over here so Igor is in hurry.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(332890798261, "You will not regret. Igor is great mercenary. Will receive a lot of commendation. Probably a medal, too.")
    }),
    PlaceObj("ChatMessage", {
      "Text",
      T(434040400943, "Great. Now we must drink. I go get bottle.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(863582844498, "You know Igor is great merc. But contract expiring soon. We must fix.")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(938302509814, "Now we drink. It is customary. ")
    })
  },
  MedicalDeposit = "large",
  Haggling = "high",
  StartingSalary = 450,
  SalaryIncrease = 290,
  SalaryLv1 = 275,
  SalaryMaxLv = 3500,
  LegacyNotes = [[
"Following in his uncle's footsteps won't be easy for Igor. His uncle Ivan Dolvich is legendary. Igor may be new to A.I.M. but he is by no means new to armed combat--he developed his abilities for stealth while in action in Chechnya. Most importantly, his bloodline speaks volumes about his potential. Igor and Ivan are already being referred to as the Russian "I-Team."" - A.I.M. Dossier

Additional info: 

Russian accent.
Has had plenty of exposure to alcohol due to the horrors of war, though not as much of a drunk as Larry. 
Uses odd expressions, which sometimes come off as strange and funny.
Admires his uncle, Ivan, but probably lacks the fortitude and discipline to be like him.
His affordable rates and good physical stats makes him a good choice for the opening game.]],
  StartingLevel = 2,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "MeleeWeapon")
    self:TryEquip(items, "Handheld B", "Firearm")
  end,
  MaxHitPoints = 91,
  Likes = {"Ivan", "Grunty"},
  LearnToLike = {"Kalyna"},
  StartingPerks = {
    "Nazdarovya",
    "Stealthy",
    "OptimalPerformance"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Igor"})
  },
  Equipment = {"Igor"},
  Specialization = "AllRounder",
  pollyvoice = "Geraint",
  gender = "Male",
  VoiceResponseId = "Igor"
}
