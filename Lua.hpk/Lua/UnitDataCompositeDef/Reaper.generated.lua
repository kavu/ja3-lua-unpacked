UndefineClass("Reaper")
DefineClass.Reaper = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 80,
  Agility = 92,
  Dexterity = 92,
  Strength = 81,
  Wisdom = 81,
  Leadership = 34,
  Marksmanship = 97,
  Mechanical = 41,
  Explosives = 47,
  Medical = 2,
  Portrait = "UI/MercsPortraits/Reaper",
  BigPortrait = "UI/Mercs/Reaper",
  Name = T(418504386182, "Carl \"Reaper\" Sheppards"),
  Nick = T(728059446658, "Reaper"),
  AllCapsNick = T(554704973917, "REAPER"),
  Bio = T(344912752793, "A man who has accepted that death is a part of life - or at least that other people's deaths are a part of his life - Reaper is the perfect assassin. His skills at stealthy movement and lock picking make it easy for him to reach his prey and his chillingly calm demeanor makes it even easier for him to eliminate them. He rarely misses and even when he does, he has the steely determination to make sure the next shot does not. Carl just finished an assignment hunting down a few especially slippery international terrorists and is ready for a new assignment."),
  Nationality = "USA",
  Title = T(272376216454, "Harbinger of Death"),
  Email = T(426580911623, "reaperofsouls@aim.com"),
  snype_nick = T(458369100789, "reaperofsouls"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(151982790988, "There are many who want my services. Perhaps too many. I need to sort out my prior obligations first. We may still work together in the future.")
        })
      },
      "Conditions",
      {}
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(261288234184, "I'm going to Tibet to cleanse myself after my last mission. You may contact me again in a few days.")
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
          T(855430404520, "This plane of existence no longer holds my interest. I must meditate and visit the astral to cleanse myself. Perhaps we will meet again.")
        })
      },
      "Conditions",
      {},
      "chanceToRoll",
      20,
      "Type",
      "rehire"
    })
  },
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(661300087224, "I'm less than confident of my decision. But Shadow Simmons speaks well of you, so I'll risk it. You have my soul.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Shadow"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(417125635143, "The arrangement could be more attractive. But I'm intrigued by Keith Hanson. I see potential there. On that basis, I'm accepting your offer.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Blood"})
      },
      "chanceToRoll",
      100
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(951172020299, "This is Reaper. I am away on assignment. If you have need of my particular skill set, contact me again when I am available.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(666747738581, "I am Reaper. I have a very specialized set of skills. Tell me how my skills might be of service to you.")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(906243182757, "Let us try this again. You have piqued my curiosity, otherwise I would not bother with more than one call. ")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(558310587627, "Yes. It is wise to think before talking. I will ponder upon Death while you find your words.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(432330723394, "Good, then it is agreed. Let our words to each other be our bond and let us never speak of this again.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(510950100711, "My contract's up soon. Let me know if you want to continue our arrangement. Shall I stay or shall I ghost?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(610952982464, "All right. I'll continue our contract. Same conditions apply. No paperwork.")
    })
  },
  StartingSalary = 3600,
  SalaryIncrease = 200,
  SalaryMaxLv = 6400,
  LegacyNotes = [[
"Otherwise known as The Assassin, if you come face-to-face with Carl Sheppards, chances are you're on your last breath. The Reaper takes pride in his patience. He strides silently and uses his stealth skills to gain easy access to his victims. Carl also gets a kick out of looking them in the eye just before they die. One of his former CO's described him as "potentially too dangerous even for A.I.M. service." - Jagged Alliance 2

Additional info:

A loner, though not anti-social.
Sees death and killing as something spiritual.
Carries himself as if living on another plane of existence, and can be very eloquent and poetic about how he perceives things.
He's almost spooky, has an unsettling calmness.]],
  StartingLevel = 6,
  MaxHitPoints = 81,
  LearnToLike = {"Fauda"},
  StartingPerks = {
    "Stealthy",
    "Loner",
    "Spiritual",
    "TheGrim",
    "Flanker",
    "DeathFromAbove",
    "SingularPurpose",
    "Hobbler",
    "LastWarning"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Reaper"})
  },
  Equipment = {"Reaper"},
  Tier = "Legendary",
  Specialization = "Marksmen",
  gender = "Male",
  VoiceResponseId = "Reaper"
}
