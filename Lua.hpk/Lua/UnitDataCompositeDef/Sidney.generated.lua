UndefineClass("Sidney")
DefineClass.Sidney = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 75,
  Agility = 70,
  Dexterity = 90,
  Strength = 74,
  Wisdom = 79,
  Leadership = 39,
  Marksmanship = 92,
  Mechanical = 0,
  Explosives = 15,
  Medical = 44,
  Portrait = "UI/MercsPortraits/SidneyN",
  BigPortrait = "UI/Mercs/SidneyN",
  Name = T(841570945724, "Sidney Nettleson"),
  Nick = T(753322319118, "Sidney"),
  AllCapsNick = T(897461283861, "SIDNEY"),
  Bio = T(199288355089, "The unflappable Sidney Nettleson can most often be found at the nearest bridge club, taking tricks and trading quips with the city's upper crust. That is, of course, unless he is working - in which case you can find him stoically staring down a hail of bullets while coolly dispatching his foes with throwing knives, grenades or any firearm within reach. Afterwards, over tea, he'll be happy to tell you exactly how he did it: with aplomb and a stiff upper lip, naturally."),
  Nationality = "England",
  Title = T(887910706417, "Her Majesty's Humble Servant"),
  Email = T(148356789359, "fancy_chap@aim.com"),
  snype_nick = T(509119494377, "fancy_chap"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(647545826862, "Oh, bother. Terribly sorry, but I just realized I made an appointment to see a chap in Leeds regarding the relative merits of our competing football teams. I'm afraid it can't be avoided. Cheerio!")
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
          T(687315673351, "Frightfully sorry, but I only commit myself to long term contracts. Bit of a bother doing short term work. You understand.")
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
          T(528608115027, "Sorry. I don't mean to be abrupt, but I was rather hoping to catch the start of butterfly season. I suppose I could put it off until next year, but would it bother you terribly if I asked for a bit of compensation?")
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
          T(523907038825, "I've heard you hired Scope. Smashing! Good show! I love working with her. Such a professional. Consider me as good as hired.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Scope"})
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
          T(354256993142, "Excellent! Looking forward to working with you. By the way, might I suggest you hire Scope? I believe she's available. You certainly won't regret it.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Scope"})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(500449552384, "Sidney Nettleson. I'm afraid I am indisposed at the moment. If this is regarding future employment, please don't hesitate to contact me again when I am on-line.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(917305404813, "Sidney Nettleson. At your service.")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(341175474329, "Hello! Very glad to be chatting with you again.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(398847119897, "Are you still there? The little light says that you're there, but sometimes these bloody computers lie.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(591742548820, "We are in agreement. I shall be there without any unnecessary delay.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(158779961719, "Sorry for the bother, but I thought I should mention that my contract shall be completed in full shortly.")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(962444405635, "Jolly good! I enjoy getting those minor technicalities out of the way so I can concentrate on the matters at hand.")
    })
  },
  StartingSalary = 3600,
  SalaryIncrease = 220,
  SalaryLv1 = 370,
  SalaryMaxLv = 4200,
  LegacyNotes = [[
JA1:
"A quiet and reflective member in excellent standing, Sidney Nettleson entertains a certain fondness for putting things to sleep permanently. Sometimes referred to as the "Sandman," his low-key approach doesn't alter the fact that he is a harsh professional." - Jagged Alliance

JA2:

"Whether it's sharing a spot of tea with British blue-bloods or putting a .38 slug into an unwanted nuisance, Sidney does it with poise and dignity. Sidney combines the mannerisms of the upper crust with the lighting quickness of a Wild West gunslinger. Years of avid cricket-playing have also given him a much-feared throwing arm." - Jagged Alliance 2]],
  StartingLevel = 5,
  MaxHitPoints = 80,
  Likes = {"Scope"},
  StartingPerks = {
    "Throwing",
    "Negotiator",
    "SidneyPerk",
    "Hotblood",
    "Deadeye",
    "BreachAndClear",
    "Instagib"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Sidney"})
  },
  Equipment = {"Sidney"},
  Tier = "Legendary",
  Specialization = "Marksmen",
  gender = "Male",
  VoiceResponseId = "Sidney"
}
