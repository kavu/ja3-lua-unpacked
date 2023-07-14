UndefineClass("MD")
DefineClass.MD = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 72,
  Agility = 62,
  Dexterity = 78,
  Strength = 76,
  Wisdom = 94,
  Leadership = 4,
  Marksmanship = 68,
  Mechanical = 7,
  Explosives = 0,
  Medical = 81,
  Portrait = "UI/MercsPortraits/MD",
  BigPortrait = "UI/Mercs/MD",
  Name = T(686612112398, "Dr. Michael \"MD\" Dawson"),
  Nick = T(484352976943, "MD"),
  AllCapsNick = T(640628882023, "MD"),
  Bio = T(186460451002, "When he was just out of medical school, Michael gave up a bright future in medicine to become a mercenary. He is evasive when asked, but it's entirely possible Michael joined A.I.M. thinking it was Doctors Without Borders. Whatever the reason, MD saw his first combat in Arulco and has developed a taste for the soldiering life. His skills with knives come in handy for fighting as well as healing and his incurable optimism makes all who work with him want to learn from his example."),
  Nationality = "Canada",
  Title = T(892027636726, "Always Uncertain, Never Discouraged"),
  Email = T(853992834316, "goodguymichael@aim.com"),
  snype_nick = T(894034021981, "goodguymichael"),
  Haggles = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(589316307933, "Ummm... Steroid will be there. Not that I have anything against him but... he likes to bully me and say I'm \"weak and feminine.\"")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(377316958854, "I mean, I can see his point, but I will need some more money for the therapy later.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Steroid"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(255971337240, "That's all great, but Meltdown and I don't exactly get along. She always likes to tell me that I remind her of a turd one of her dog's once ate.")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(706928440131, "I mean, maybe it's true. I wasn't there. The turd could've looked like me... Anyway, it's still a bit stressful and some extra money for the inevitable therapy sessions would be appreciated.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Meltdown"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(133732872963, "Oh god. Nails will be there, right? He ran me over with his bike. Repeatedly. Then yelled at me for getting blood on his tires.")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(812957826017, "Well, I suppose I'm partially to blame for being in his way. Anyway, he likes to remind me of it, and so I'll need some extra money to deal with all the PTSD.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Nails"})
      },
      "chanceToRoll",
      100
    })
  },
  HaggleRehire = {},
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(232520855092, "Hi, this is Dr. Michael Dawson and I'm unavailable. If you contact me later... Why do I even bother? No one's bound to call me. They'll get good expensive mercs like Sidney, or Dr. Q.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(844200702211, "Hi. Is this a prank call? Last time, some mercs contacted me under an alias and sent me to Cambodia for two weeks. So is this a genuine offer?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(156327251175, "Oh thank god! I thought you decided to ditch. ")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(514838144823, "Umm... you didn't change your mind about me, right? Right?")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(204072676737, "Oh wow. I never thought this would happen. I mean... you're sure you want me?")
    }),
    PlaceObj("ChatMessage", {
      "Text",
      T(248975416845, "Of course, you're sure. That was stupid of me. Sorry. Where are we going? Africa? I'll pack some shorts.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(141535236983, "Umm... I don't know how to say this but, ummm... my contract. It will... expire, I guess? Maybe we can continue working together?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(169241431651, "That's... wow. Thanks! I will continue, ummm... doing what I do I guess.")
    })
  },
  MedicalDeposit = "large",
  StartingSalary = 450,
  SalaryIncrease = 270,
  SalaryLv1 = 525,
  SalaryMaxLv = 3500,
  LegacyNotes = [[
"Fresh out of med school, Doctor Dawson eagerly awaits his first assignment. Although his innocent and youthful appearance has prevented others from taking him seriously but rest assured, once he saves a couple of lives, he'll be shown the kind of respect he deserves. For a man who just completed his internship, he can certainly wield a mean scalpel."

Additional info:

Young, inexperienced, a little chattier than most of the others.
Uses some scientific terminology.
Enthusiastic and somewhat brash.
Surprises himself on occasion as he feels his way through combat.
MD has an excellent wisdom score, so you can easily train up his marksmanship]],
  MaxHitPoints = 72,
  LearnToDislike = {"Flay"},
  StartingPerks = {
    "Teacher",
    "Optimist",
    "Zoophobic",
    "BuildingConfidence"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "MD"})
  },
  Equipment = {"MD"},
  Specialization = "Doctor",
  gender = "Male",
  VoiceResponseId = "MD"
}
