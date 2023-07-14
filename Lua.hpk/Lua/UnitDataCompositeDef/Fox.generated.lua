UndefineClass("Fox")
DefineClass.Fox = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 78,
  Agility = 85,
  Dexterity = 100,
  Strength = 56,
  Wisdom = 76,
  Leadership = 21,
  Marksmanship = 69,
  Mechanical = 15,
  Explosives = 8,
  Medical = 69,
  Portrait = "UI/MercsPortraits/Fox",
  BigPortrait = "UI/Mercs/Fox",
  Name = T(653970492916, "Cynthia \"Fox\" Guzzman"),
  Nick = T(550680559818, "Fox"),
  AllCapsNick = T(533036246701, "FOX"),
  Bio = T(431815979541, "Contracted to model for a travel guide advertising the new and peaceful Arulco, Cynthia posed in bikinis on beaches and displayed her ambidextrous pistol shooting abilities at local talent shows. Never one to tolerate a dull moment, she also utilized her flawless knowledge of anatomy to make herself available for private tutoring lessons with the president's son. Recently, she has reported to A.I.M. that she is ready to make herself available to anyone, whenever and wherever."),
  Nationality = "USA",
  Title = T(643740690300, "The Pin-Up Pistoleer"),
  Email = T(275428567670, "foxy1@aim.com"),
  snype_nick = T(750146314874, "foxy1"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(968862205775, "Forget it! As long as you've got that muscle-brained moron, Steroid, working for you, then you can count me out!")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Steroid"})
      }
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(424506783398, "Sorry, I just remembered. I'm meeting a real Hollywood big shot at his beach bungalow in a closed casting call! This could be my big break! I can't wait to show him what I've got!")
        })
      },
      "Conditions",
      {},
      "chanceToRoll",
      20
    })
  },
  Haggles = {},
  HaggleRehire = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(690973322218, "You hiring that pumped-up pinhead, Steroid, has added a lot of stress to this job. I'm going to need added incentive to stay in the field.")
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
          T(545857097628, "That little creep, Smiley, is driving me crazy! If you want me to stay on the team, you're going to have to pay me more to give me a reason not to chop off his wandering hands!")
        })
      },
      "Conditions",
      {
        PlaceObj("AND", {
          Conditions = {
            PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Smiley"}),
            PlaceObj("MercIsLikedDisliked", {
              Object = "Smiley",
              Relation = "Dislikes",
              TargetUnit = "Fox"
            })
          }
        })
      }
    })
  },
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(160370239004, "If Wolfy is already on the payroll, then sign me up! I can't wait to show him my new bathing suit!")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Wolf"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(158023635837, "Any team that includes my Grizzly bear is the team I want to be on!")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Grizzly"})
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
          T(168114906666, "OK, it's a deal. By the way, I hear Wolf is available and I love working with him. I'd be soooooo appreciative if you hired him too!")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Wolf"})
      }
    }),
    PlaceObj("MercChatBranch", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(202992877509, "OK, it's a deal! Just a suggestion, but I know Grizzly is available to work. I can be sooooo much more flexible to work with when I have my Grizzly bear around!")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Grizzly"})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(372042629873, "This is Cynthia Guzman. I'm tied up right now, but I check my box as often as I can, so leave me a message and maybe we can get together some time!")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(303692254961, "Fox here. If this is about a job, I'm all ears. Well, that's not completely true. I have other parts, too.")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(258922001582, "Back again, huh? I knew you wouldn't be able to stay away.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(173758988412, "Is this going to take long? I have a waxing appointment to go to.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(210052524908, "Great! I just have to pick up some sun tan lotion and a pack of surgical gauze and I'll see you soon.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(972810372163, "I'm a busy girl and there are a lot of people who'd like to get serviced by me. You don't want to wait until the last minute to make a commitment to our future. ")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(760883994778, "I'm glad to know you like what you see. Get ready to see some more.")
    })
  },
  MedicalDeposit = "large",
  DurationDiscount = "long only",
  StartingSalary = 560,
  SalaryIncrease = 280,
  SalaryLv1 = 222,
  SalaryMaxLv = 4200,
  LegacyNotes = [[
JA 1

"Dangerous, desirable and devious, Cynthia Guzzman is the latest female addition to our organization. A former nurse from Newark with a doctor's attitude, the Fox is known for her field treatment of casualties, excellent agility and amazing dexterity."

JA2

"Initially trained as an emergency room nurse, Fox Guzzman was recently featured in "Babes and Bullets," a prestigious monthly mercenary magazine. Her article on controlling hemorrhaging while on the battlefield was almost as highly praised as her centerfold layout."
Additional Info: Guzzman has recently spent a lot of time on the firing range and it has paid off handsomely."

JA2 WF

"Originally trained as a nurse, Fox Guzzmann was highlighted in an outstanding monthly magazine for mercenaries. The special article was entitled "Curves in Uniform". In the article, her medical skills on the combat field were almost as highly praised as her front and backsides."

Additional info:
The pin-up girl of A.I.M., stunning and seductive.
Dialogue is often vaguely (or not so vaguely) sexual
Conscious of her appearance, and is not afraid to take advantage of her good looks
Voice is seductive in all games except Back In Action
It is implied that she and Peter "Wolf" Sanderson are more than just friends. Openly mentions past affairs with a few other male mercenaries (and implies even more).]],
  StartingLevel = 2,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "Firearm")
    self:TryEquip(items, "Handheld A", "Firearm")
  end,
  MaxHitPoints = 77,
  Likes = {"Wolf", "Grizzly"},
  LearnToLike = {"Fauda"},
  Dislikes = {"Steroid"},
  LearnToDislike = {"Smiley"},
  StartingPerks = {
    "Teacher",
    "Ambidextrous",
    "Scoundrel",
    "FoxPerk",
    "OpportunisticKiller"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Fox"})
  },
  Equipment = {"Fox"},
  Specialization = "Doctor",
  pollyvoice = "Nicole",
  gender = "Female",
  VoiceResponseId = "Fox"
}
