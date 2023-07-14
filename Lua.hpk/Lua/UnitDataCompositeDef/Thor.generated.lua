UndefineClass("Thor")
DefineClass.Thor = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 97,
  Agility = 83,
  Dexterity = 84,
  Strength = 89,
  Wisdom = 93,
  Leadership = 61,
  Marksmanship = 74,
  Mechanical = 35,
  Explosives = 11,
  Medical = 72,
  Portrait = "UI/MercsPortraits/Thor",
  BigPortrait = "UI/Mercs/Thor",
  Name = T(928760236378, "Thor Kaufman"),
  Nick = T(520222526306, "Thor"),
  AllCapsNick = T(981910118838, "THOR"),
  Bio = T(696466543743, "Just returned from a two-week chi-cleansing retreat in New Mexico, Thor reports that he has two things: a groovy recipe for an avocado smoothie and a thirst for adventure. Kaufman's new age lifestyle makes him a natural healer and his balance-focused conditioning allows him to move about with stealth and grace. His Zen-like demeanor makes it easy to overlook his fighting skills, but in hand-to-hand combat there are few that can match him. Thor also possesses an extremely inquisitive intellect, meaning there are few skills he can't pick up while on assignment."),
  Nationality = "Germany",
  Title = T(222862793640, "Positive Thinking as a Deadly Force"),
  Email = T(369085666162, "positivepower@aim.com"),
  snype_nick = T(702556725674, "positivepower"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(688252716496, "Unfortunately, Mercury is in retrograde right now. This bodes ill for starting new contracts. I am sorry. Let us talk again when the stars are better.")
        })
      },
      "Conditions",
      {},
      "chanceToRoll",
      20
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(632860633590, "I'll have to say no. I need a C.O. who inspires confidence, not caution. The recent deaths in your team make me uneasy.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionDeathToll", {PresetValue = "1"})
      }
    })
  },
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(928026734452, "Ice apparently thinks highly enough of you to be on your team. So, I think if you're good enough for him, you're good enough for me as well.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Ice"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(894479586741, "I still have more to learn from Omryn. Every moment around his wisdom makes me a better man.")
        })
      },
      "Conditions",
      {
        PlaceObj("AND", {
          Conditions = {
            PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Omryn"}),
            PlaceObj("MercIsLikedDisliked", {Object = "Omryn", TargetUnit = "Thor"})
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
          T(839770835330, "I'm looking forward to working for you. Also, Ice is the kind of man I'm proud to serve with. Why not contact him and hire him for the team?")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Ice"})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(681550588538, "You've reached Thor, Cassandra, and Fenrus. We may be asleep or busy just now. I'll get back to you when I am able. Thank you!")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(514082345416, "Hello, I am Thor Kaufman. I am always open for new adventure. What are you proposing?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(310390725970, "I am very glad to hear from you again. I just had a bowel cleanse and am ready to talk business!")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(331040399865, "While we wait, do you want me to do your horoscope?")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(126462930896, "I'm looking forward to working for you.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(815366988804, "When my contract expires a short time from now, will you want to keep me on as part of the operation?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(419099663092, "Your aura exudes positivity and confidence! I'll be glad to stay.")
    })
  },
  MedicalDeposit = "none",
  DurationDiscount = "long only",
  StartingSalary = 1600,
  SalaryLv1 = 570,
  SalaryMaxLv = 4950,
  LegacyNotes = [[
"This vegetarian New Age healer has an amazing grasp of medicine for a man who's never seen the inside of a university med school. He also has a decent grasp for killing quickly and quietly. Born on outskirts of Berlin, he now calls California home where he lives in the mountains with his newborn son and ex-wife, Cassandra."

Additional info:

Slight German accent
An easy-going new age, professional killer with scientific terminology in his dialogue
Switches to German expressions when the situation is tense.
He switches between the direct rigidity of his upbringing and his new found inner-tranquillity.]],
  StartingLevel = 3,
  MaxHitPoints = 96,
  Likes = {"Ice"},
  LearnToLike = {"Omryn"},
  StartingPerks = {
    "Stealthy",
    "Spiritual",
    "NaturalHealing",
    "Savior",
    "StressManagement"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Thor"})
  },
  Equipment = {"Thor"},
  Tier = "Veteran",
  Specialization = "Doctor",
  gender = "Male"
}
