UndefineClass("Barry")
DefineClass.Barry = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 81,
  Agility = 73,
  Dexterity = 87,
  Strength = 78,
  Wisdom = 91,
  Leadership = 29,
  Marksmanship = 70,
  Mechanical = 46,
  Explosives = 92,
  Medical = 20,
  Portrait = "UI/MercsPortraits/Barry",
  BigPortrait = "UI/Mercs/Barry",
  Name = T(919764309920, "Barry Unger"),
  Nick = T(872433137526, "Barry"),
  AllCapsNick = T(420472155832, "BARRY"),
  Bio = T(201477611708, "A pious man with an immense attention to detail, at first glance Barry seems better suited to the humble life of an electrician than a soldier of fortune. Were it not for Barry's preference for blowing things up for money and picking locks for fun, he could easily lead a happy life installing cable in his homeland of Hungary."),
  Nationality = "Hungary",
  Title = T(139748625274, "Patron Saint of Plastique"),
  Email = T(314757335274, "unger.barry@aim.com"),
  snype_nick = T(435268553018, "unger.barry"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(674127463811, "I love to play with bombs, but working for you seems too dangerous even for me. Take better care of your soldiers! Goodbye.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionDeathToll", {PresetValue = "2+"})
      }
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(650809113310, "I want to have long contract. More certainty.")
        })
      },
      "Type",
      "duration"
    })
  },
  Haggles = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(646034666673, "Working for you is dangerous work. I can be persuaded with more money.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionDeathToll", {PresetValue = "1"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(115207671188, "I have not worked with you. You are unknown to me. I need more money as insurance I stay alive.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionRehire", {})
      },
      "chanceToRoll",
      20
    })
  },
  HaggleRehire = {},
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(456533953431, "I am not sure about this, but Red has joined you. I like him. So, very well, we have deal.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Red"})
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
          T(935578724304, "We have reached simultaneous agreement. Count me as part of your team. ")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(408115538874, "Something else - my friend Red is some terrific. I would like to work with him. Take in consideration.")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(196551213889, "We will meet soon. Goodbye.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Red"})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(816742272286, "Barry Unger here. I am not of availability right now. I am for hire. I work with explosives. Make contact when can.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(255302860986, "This is Barry Unger. This is about job? Work is not plenty at the moment so I cannot be particular.")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(490078009951, "Our business agreement has not reached conclusion. Let us resume.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(181178716282, "Are you having trouble in machine? If not, let us continue with agreement. ")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(553481989500, "We have reached simultaneous agreement. Count me as part of your team. Goodbye.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(779078342210, "My contract is of expiring duration. Let us reach new agreement.")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(912455165410, "This gives me pleasure. Thank you.")
    })
  },
  MedicalDeposit = "none",
  StartingSalary = 470,
  SalaryIncrease = 280,
  SalaryLv1 = 100,
  SalaryMaxLv = 4100,
  LegacyNotes = [[
"Hungarian-born Unger is part of a new breed of explosive experts. He learned most of his trade the safe way--in a classroom. His studies included the theory behind incendiary devices, and the technical aspects of electronics and circuitry. Although he also took locksmith and swimming courses, he didn't do well in the latter." - A.I.M. Dossier

Additional info:

Speaks with a heavy Hungarian accent. Use of English is stilted and overly formal.
Dispassionate and distant, straightforward with his opinions, yet in possession of humility.
Religion had a strong part in his upbringing.
Precise and intelligent (would likely read instructions before attempting anything).]],
  StartingLevel = 2,
  MaxHitPoints = 82,
  Likes = {"Red"},
  StartingPerks = {
    "MrFixit",
    "Spiritual",
    "DesignerExplosives",
    "BreachAndClear"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Barry"})
  },
  Equipment = {"Barry"},
  Specialization = "ExplosiveExpert",
  gender = "Male",
  blocked_spots = set("Weaponls", "Weaponrs"),
  VoiceResponseId = "Barry"
}
