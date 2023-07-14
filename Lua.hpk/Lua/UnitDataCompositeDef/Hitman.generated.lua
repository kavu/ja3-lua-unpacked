UndefineClass("Hitman")
DefineClass.Hitman = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 72,
  Agility = 69,
  Dexterity = 40,
  Strength = 72,
  Wisdom = 74,
  Leadership = 58,
  Marksmanship = 88,
  Mechanical = 11,
  Explosives = 39,
  Medical = 3,
  Portrait = "UI/MercsPortraits/Hitman",
  BigPortrait = "UI/Mercs/Hitman",
  Name = T(799859181071, "Frank \"Hitman\" Hennessy"),
  Nick = T(946077284416, "Hitman"),
  AllCapsNick = T(734624158090, "HITMAN"),
  Bio = T(649246167400, "After spending the last couple of years fighting his own Battle of the Bulge, Frank has begrudgingly admitted that he is afflicted with \"Dad Bod\", although as far as A.I.M. knows he has no children nor even a wife. Still, he remains one of A.I.M.'s best marksmen and his throwing arm is as strong as ever. On top of that, his affable manner serves him well when teaching and training others in the field. A valuable, if slightly oversized, addition to any team."),
  Nationality = "USA",
  Title = T(831408309409, "The Affable Assassin"),
  Email = T(626379380637, "hitman@aim.com"),
  snype_nick = T(645661687272, "hitman"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(808348013682, "No way am I working with Raider. Man's thicker than a 2x4, but acts like he's the best one around here. Sorry, Ace, not going through that again.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Raider"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(601719461266, "Let's just say you don't have the best reputation in terms of keeping those who work for you alive. I value my life too much, Ace. Sorry, but I can't accept your offer.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionDeathToll", {PresetValue = "1"})
      }
    })
  },
  Haggles = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(620001696951, "Word on the street is you are rolling in it, Ace. I will work for you if you divert some of that extra cheddar my way.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionMoney", {PresetValue = ">=50"})
      }
    })
  },
  HaggleRehire = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(554415577338, "Well, Ace, I happen to know you are swimming in dough right now. I want a piece of that pie if we are to continue our mutual cooperation.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionMoney", {PresetValue = ">=50"})
      }
    }),
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(531216698923, "I know I'm good, Ace, but I've seen a lot of action lately. You are using me like a work horse, and I may be a lot of things but a horse ain't one. If we are to continue working like this, a big old wad of cash needs to come my way.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionCombatParticipate", {PresetValue = ">=10"})
      }
    })
  },
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(630933806416, "Well, with a fox like Raven on the team, how's a man to say no? I'm in, Ace, against my better judgement.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Raven"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(219051126945, "Well, you got Grunty somehow, and he is the key to a solid operation. I guess I'm in too. I hope I don't regret this, Ace.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Grunty"})
      },
      "chanceToRoll",
      100
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(933155613749, "Hitman Henessy, mercenary for hire! I am out and about, Ace. You will get a note when I get back in. Have a good one.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(349490027919, "Hey, Ace! Looks like you got a job for me.")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(588171612533, "You with me again, Ace? Where were we?")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(286657788041, "Did you fall asleep, Ace? Let's get the ball rolling.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(949447625244, "Looks like we got ourselves a contract, Ace. You will not regret having me there.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(830992502289, "Contract's about to expire, Ace. Let's get this little matter squared away.")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(798713629390, "Good, Ace. I knew you would appreciate a first-class hitman.")
    })
  },
  StartingSalary = 900,
  SalaryLv1 = 100,
  SalaryMaxLv = 2900,
  LegacyNotes = [[
JA1:

"Undisturbed by the scent of death, Frank Hennessy is a member in excellent standing. A private, yet personable individual, the Hitman has a proven track record and a no nonsense disposition. A note of caution: he suffers from buoyancy difficulties." - Jagged Alliance

JA2:

"The Hitman's easy-going and personable disposition has made him one of the more popular and respected mercenaries in the organization. Unfortunately, Frank hasn't taken care of himself lately and his health and skills have dropped off slightly. Despite repeated attempts, Hennessy has been unable to overcome his weight problem.  Additional info: Frank has been talking of throwing in the towel and become a combat instructor." - Jagged Alliance 2]],
  StartingLevel = 4,
  MaxHitPoints = 75,
  Likes = {"Raven", "Grunty"},
  Dislikes = {"Raider"},
  StartingPerks = {
    "Teacher",
    "DedicatedCamper",
    "TakeAim",
    "Hobbler",
    "HitTheDeck"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Hitman"})
  },
  Equipment = {"Hitman"},
  Tier = "Elite",
  Specialization = "Marksmen",
  gender = "Male",
  VoiceResponseId = "Hitman"
}
