UndefineClass("Magic")
DefineClass.Magic = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 95,
  Agility = 99,
  Dexterity = 98,
  Strength = 92,
  Wisdom = 80,
  Leadership = 15,
  Marksmanship = 94,
  Mechanical = 91,
  Explosives = 27,
  Medical = 24,
  Portrait = "UI/MercsPortraits/Magic",
  BigPortrait = "UI/Mercs/Magic",
  Name = T(990490681062, "Earl \"Magic\" Walker"),
  Nick = T(597495451908, "Magic"),
  AllCapsNick = T(400907277958, "MAGIC"),
  Bio = T(273999095685, "Although he downplays it, A.I.M. is proud to announce Earl Walker as the winner of both the \"Fastest Fingers\" and \"Best Dressed\" competitions at this year's annual Worldwide Mercenary Awards. Congrats, Magic! Earl combines Olympic-level physical conditioning, stealth, alertness, and adeptness with a lockpick to be the foremost infiltrator among A.I.M.'s members. Take all that and combine it with exceptional marksmanship and you have a merc at the top of his game."),
  Nationality = "USA",
  Title = T(392626315903, "The Man with the Magic Plan"),
  Email = T(201985029292, "justlikemagic@aim.com"),
  snype_nick = T(367614979450, "justlikemagic"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(791488790738, "As long as that chick Buns is on the guest list, you can forget about me being at the party.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Buns"})
      }
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(624090922681, "Hey, man... You want to watch the Magic show, you got to bring the dough. Ya dig?")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionMoney", {})
      }
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(715661622535, "That Buns chick messes with my groove. I gotta split. Maybe catch you later.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Buns"})
      },
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
          T(610720160197, "Ya signed the Iceman, ya signed me.")
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
          T(274138944570, "I was gonna tell you I can't join because I gotta organize my record collection, but I see here you got Keith \"Blood\" Hanson on your team. That's my man. Blood is one brother I always want to work with, no matter the job.")
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
  ExtraPartingWords = {
    PlaceObj("MercChatBranch", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(825397889767, "If you're looking for another brother, Ice is one cool cat to consider.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Ice"})
      }
    }),
    PlaceObj("MercChatBranch", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(450011435940, "I hear my man Blood is looking for work. You should check him out.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Blood"})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(370043022550, "You reached Magic. I'm away on business, but be cool and leave a message and I'll hit you up when I get back.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(675309371261, "Magic. What you want?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(217534341976, "Hey. What you want this time?")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(514348844008, "Don't mean to rush you or nothing but... I gotta hustle down to the record store before they close, ya dig?")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(199111145437, "Cool. We all good. Be seeing you.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(341035456537, "We got business to discuss. You thinking about extending my contract or what?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(435176604344, "Solid. Ready to get back in action whenever you are.")
    })
  },
  StartingSalary = 4900,
  SalaryIncrease = 150,
  SalaryLv1 = 2800,
  SalaryMaxLv = 9000,
  LegacyNotes = [[
JA1:

"Cautious, light-footed and extremely agile, Earl Walker is considered to be one of the best second story men in the business. And even when he's been fingered, his sharp eyes and deadly aim have eliminated the dilemma of witnesses!" - Jagged Alliance

JA2:

"Magic's calm, cool, and collected demeanor sets the tone for battle. In peak physical condition, he displays razor-sharp reflexes and catlike agility. Magic can ferret out danger with astonishing acumen. And with his lethal marksmanship, he quickly and efficiently puts an end to any threat. He's nicknamed Magic due to the way doors seem to open up in front of him." - Jagged Alliance 2

Additional info:

Voice: Deep, drawn-out and definitive
Assertive, detached and deadly.
Being a second-story man, he is regularly wanted by the police, something he shared with fellow burglar Jimmy Upton until Jimmy was caught and jailed.]],
  StartingLevel = 5,
  MaxHitPoints = 95,
  Likes = {"Blood", "Ice"},
  Dislikes = {"Buns"},
  StartingPerks = {
    "Stealthy",
    "Scoundrel",
    "SecondStoryMan",
    "SteadyBreathing",
    "DeathFromAbove",
    "Untraceable",
    "LuckyStreak"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Magic"})
  },
  Equipment = {"Magic"},
  Tier = "Legendary",
  Specialization = "Mechanic",
  gender = "Male",
  VoiceResponseId = "Magic"
}
