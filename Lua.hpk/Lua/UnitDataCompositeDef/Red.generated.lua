UndefineClass("Red")
DefineClass.Red = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 66,
  Agility = 66,
  Dexterity = 81,
  Strength = 68,
  Wisdom = 79,
  Leadership = 21,
  Marksmanship = 78,
  Mechanical = 35,
  Explosives = 100,
  Medical = 5,
  Portrait = "UI/MercsPortraits/Red",
  BigPortrait = "UI/Mercs/Red",
  Name = T(929255472486, "Ernie \"Red\" Spragg"),
  Nick = T(898873386961, "Red"),
  AllCapsNick = T(402554487810, "RED"),
  Bio = T(519116089912, [[
Other mercs like to joke that Ernie's been blowing up bridges for Scottish Highlander regiments since The Great War, but Ernie remains one of A.I.M.'s foremost explosives experts and effective soldiers despite his age.
Although he can often be dour and sometimes excitable in a firefight, Red makes planting and removing mines look like child's play.
Don't let his old-fashioned ideas about the world fool you, in the field of high explosives he's as interested in new ideas as anyone else.]]),
  Nationality = "Scotland",
  Title = T(610428368333, "The Scottish Tornado"),
  Email = T(738518702343, "feckoff@aim.com"),
  snype_nick = T(286093352279, "feckoff"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(204277783053, "There's one teenie problem with me working for ya. I like being alive too much. Not that it's much of a life, but it's supposed to be better than being dead. Ye got a squaddie killed and I feel like I may be next.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionDeathToll", {PresetValue = "1"})
      }
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(996587913004, "I think you should know I dinnae like travelling half the fucking globe just to do a wee job. I need a longer contract or I'm out.")
        })
      },
      "Type",
      "duration"
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(635542348486, "I hear ya got Buns on your team. That's no good. She thinks everyone in the world is wrong and it's her job to correct 'em. Come back after you've come to your senses and fired her and we'll talk.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Buns"})
      }
    })
  },
  Haggles = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(423476528097, "I dinnae like guns in the hands of women and you seem to be having a lot of those. I will need something extra in the renumeration department to keep my nerves steady if I am to accept.")
        })
      },
      "Conditions",
      {
        PlaceObj("CheckExpression", {
          Expression = function(self, obj)
            return table.count(gv_UnitData, function(ud)
              return gv_UnitData[ud].HireStatus == "Hired" and gv_UnitData[ud].gender == "Female"
            end) >= 3
          end
        })
      }
    })
  },
  HaggleRehire = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(596918996231, "I want some extra cash for puttin' up with the incessant chattering of Livewire. Listening to her all day makes my ears bleed, so you can chalk it up as a medical expense.")
        })
      },
      "Conditions",
      {
        PlaceObj("AND", {
          Conditions = {
            PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Livewire"}),
            PlaceObj("MercIsLikedDisliked", {
              Object = "Livewire",
              Relation = "Dislikes",
              TargetUnit = "Red"
            })
          }
        })
      }
    })
  },
  Mitigations = {},
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(477851657674, "This is Ernie Spragg. No explosion's too big and no bang is too loud. Either there's curling on the telly, or I don't like your face and don't want to talk to ya.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(442588283020, "This is Ernie Spragg. So you want me to go to another shithole country? Why don't I ever get called to some nice place? I look damn fine in my kilt, I'll have ya know!")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(913839648044, "Ach! Where did you bugger off to? Let's get this over with.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(468996036878, "You still there or did ye start playin' video games? Ach! Ye kids with yer games!")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(156162799216, "Aye, that's done. Now I need to get some factor thousand sunscreen or I will be tits up in freckles.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(981721812446, "My contract's expiring and I was wondering if you'd be willing to rectify the situation?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(728306294667, "You are not a total pile of shite. So, I guess I am kind of glad we are still working together. ")
    })
  },
  MedicalDeposit = "extreme",
  StartingSalary = 800,
  SalaryIncrease = 280,
  SalaryLv1 = 100,
  SalaryMaxLv = 2750,
  LegacyNotes = [[
"This mad, mumbling Scotsman is from the old school of explosives where your instructor would fly by in pieces and you quickly moved up the ranks. Spragg is a survivor. With many years of experience under his wire cutters, he takes pride in teaching those military college kids a thing or two about detonation devices. Don't be thrown by Red's frantic ravings; the situation is rarely as dire as he likes to believe."

Additional info:

Easily excitable. Goes off rants. Bit of a hothead
Pessimist. Sees situations for their worst.
Heavy Scottish accent.
Well liked by most of the other explosive experts despite his attitude.]],
  StartingLevel = 4,
  MaxHitPoints = 68,
  Dislikes = {"Buns"},
  LearnToDislike = {"Livewire"},
  StartingPerks = {
    "MrFixit",
    "Pessimist",
    "HaveABlast",
    "BreachAndClear",
    "Deadeye",
    "Hobbler"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Red"})
  },
  Equipment = {"Red"},
  Tier = "Elite",
  Specialization = "ExplosiveExpert",
  pollyvoice = "Geraint",
  gender = "Male",
  VoiceResponseId = "Red"
}
