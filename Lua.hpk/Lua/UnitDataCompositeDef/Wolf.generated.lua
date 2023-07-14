UndefineClass("Wolf")
DefineClass.Wolf = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 90,
  Agility = 83,
  Dexterity = 86,
  Strength = 87,
  Wisdom = 75,
  Leadership = 18,
  Marksmanship = 79,
  Mechanical = 65,
  Explosives = 43,
  Medical = 48,
  Portrait = "UI/MercsPortraits/Wolf",
  BigPortrait = "UI/Mercs/Wolf",
  Name = T(415973309831, "Peter \"Wolf\" Sanderson"),
  Nick = T(854057195964, "Wolf"),
  AllCapsNick = T(772197398311, "WOLF"),
  Bio = T(947517898504, "After taking a short leave of absence to run a highly specialized (and highly lucrative) paintball retreat for Fortune 500 companies, Wolf grew tired of teaching fat, middle-aged men how to pretend to kill each other. Especially exhausting was the week-long minicamp \"Oh-Dark-Dirty\" where he attempted to instruct them in Night Operations concepts and tactics while making sure everyone was wearing safety orange. He reports he's ready and very eager to return to mercenary work. One of A.I.M.'s most well-rounded members, Sanderson is highly sought after by clients looking for a merc who is capable of doing everything and is willing to do anything. Best to hire him as soon as he's available because he surely won't be without a contract for long!"),
  Nationality = "USA",
  Title = T(474239652453, "Jack Of All Trades, Master Of All"),
  Email = T(478313327038, "howling1@aim.com"),
  snype_nick = T(735297197775, "howling1"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(339046331040, "Fox and I... We had a thing. And now she's gone and I blame you for it. So get out of my face, I won't work with you now or ever.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Dead", TargetUnit = "Fox"})
      }
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(972802933246, "I would love to work for you but my mom just got in town and then I gotta do this other thing. I got a life, you know. Maybe some other time.")
        })
      },
      "Conditions",
      {},
      "chanceToRoll",
      10
    })
  },
  Haggles = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(317941837726, "Your record so far is far from stellar, judging by the coffins brought back. I would need a little extra if you want me.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionDeathToll", {PresetValue = "1"})
      },
      "chanceToRoll",
      100
    })
  },
  HaggleRehire = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(836197395161, "New contracts, new rates. Figure I'm worth a few extra dollars now.")
        })
      },
      "Conditions",
      {},
      "chanceToRoll",
      10
    })
  },
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(833123233503, "If the Fox is on your team, then you bet your ass I am too! I'm in.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Fox"})
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
          T(191822303648, "You know, it would be good to spend some more time with Fox. How about you give her a call as well?")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(527442588676, "Just a thought. Now I gotta go and pack. ")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Fox"})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(929760186481, "This is Wolf. I have a PoundShedders thing right now, but I'll notify you when I'm free.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(479719341895, "You got the Wolf. If you've also got the cash, we can do business.")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(205981379707, "We got disconnected. Let's give this another go.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(450435284152, "Hey! Talk to me!")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(453546769788, "I guess I'll be packing my bags then.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(565646668072, "My time's almost up. I need to know what your contract intentions are. I've got people waiting.")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(806165285161, "Looks like you got the Big Bad Wolf all to yourself for a little longer.")
    })
  },
  MedicalDeposit = "large",
  DurationDiscount = "long only",
  Haggling = "high",
  StartingSalary = 1150,
  SalaryLv1 = 600,
  SalaryMaxLv = 3500,
  LegacyNotes = [[
JA1:

Appropriately known as "Wolf", Peter Sanderson has been tracking down the enemy and acquiring a well-rounded knowledge of all mercenary disciplines as a member of A.I.M. over the past four years. His reputation is that of a proven professional." - A.I.M. Dossier, Jagged Alliance

JA2:

"Peter Sanderson just returned from a six-month absence. He booked off on personal leave to take an intensive physical training program and various other courses to top-off his status as a jack-of-all-trades. Having lost over forty pounds, he's in the best shape he has ever been in and A.I.M., as a result, has gladly renewed his membership.

Additional info: When not on assignment, Sanderson instructs a Wolverine Civil Defense unit during the evenings." - A.I.M. Dossier, Jagged Alliance 2

Just a solid guy to have around. For his price tag and skill set he's a great addition to almost any team. Wolf does prefer the life of a loner though, and will do better if no other merc is close by.]],
  StartingLevel = 3,
  MaxHitPoints = 90,
  Likes = {"Fox"},
  StartingPerks = {
    "Teacher",
    "JackOfAllTrades",
    "CancelShotPerk",
    "BeefedUp"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Wolf"})
  },
  Equipment = {"Wolf"},
  Tier = "Veteran",
  Specialization = "AllRounder",
  gender = "Male",
  blocked_spots = set("Weaponls", "Weaponrs"),
  VoiceResponseId = "Wolf"
}
