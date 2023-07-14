UndefineClass("Nails")
DefineClass.Nails = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 71,
  Dexterity = 88,
  Strength = 90,
  Wisdom = 79,
  Leadership = 30,
  Marksmanship = 84,
  Mechanical = 63,
  Explosives = 78,
  Medical = 11,
  Portrait = "UI/MercsPortraits/Nails",
  BigPortrait = "UI/Mercs/Nails",
  Name = T(837593519203, "Edgar \"Nails\" Smorth"),
  Nick = T(516388631352, "Nails"),
  AllCapsNick = T(597544800039, "NAILS"),
  Bio = T(622487091001, "Soon after starting Arulco's first biker gang, Nails resigned in disgust when he couldn't convince the other members that robbing liquor stores and blowing up gas stations (just the lame ones, of course) should be central pillars of their charter. Nails is ready to make his talents with explosives, tools and badassery available to the highest bidder. He's willing to go anywhere and shoot anyone, just don't ever ask him to take off his leather jacket, even though it has several bullet holes in it and is starting to smell like belly button lint."),
  Nationality = "USA",
  Title = T(494228139073, "Don't Touch the Vest"),
  Email = T(150606437691, "hellbent4lthr@aim.com"),
  snype_nick = T(309985618460, "hellbent4lthr"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(766632300489, "The bank teller won't even give ya the time of day! How about ya get some cash first, then try to do business?")
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
          T(456685093723, "Sorry, Scooter. I got a rally soon. Maybe some other time.")
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
          T(321697258530, "I could flip a coin as to whether I come back alive. I'm OK with a gamble but at a better price, Scooter.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionDeathToll", {PresetValue = "2+"})
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
          T(429290818592, "When the tough want to get going, the price goes up. I'm feelin' the need for the open road. You want me to stay, then you gotta pony up some extra dough, Scooter.")
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
          T(857732043501, "Hey, the Fox is with you, I'm with you. You can bank on that.")
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
          T(632674475914, "How about ya hire the Fox? It'll be good for, uh, morale - know what I'm sayin'? She's handy on a mission too. She's reeeeeeal good with her hands.")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(818028279133, "Whatever, I gotta split before I reach ya. ")
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
      T(927826728791, "This is Nails. I'll get to you when I get to you. I'm busy doing stuff right now.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(487748725487, "Hey Scooter, need someone to ride in, get the job done, and ride out, do ya?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(635363764783, "Back from looking at porn, are ya Scooter? Let's get back to business.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(315553885416, "Scooter! Stop watching celebrity sex videos on my time. I got shit to do.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(490165429885, "We got a deal. Just one thing you should know. My vest goes with me everywhere. I never take it off. Ever. And don't... EVER... ASK.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(223858526991, "We're coming up on the end of this contract, Scooter. What's the crystal ball telling ya?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(418152484689, "We got a deal. Looks like I'll be getting in more trouble around these parts.")
    })
  },
  MedicalDeposit = "none",
  StartingSalary = 1600,
  SalaryLv1 = 400,
  SalaryMaxLv = 3900,
  LegacyNotes = [[
JA1:

"Edgar Smorth was the leader of the largest biker gang on the continent. He's as tough as, you guessed it, Nails, and he's wanted in just about every country with law. For now, Nails has decided to lie low in A.I.M.. A word of warning - Don't mess with the vest!" - Jagged Alliance

JA2:

"Edgar Smorth traded in his bike, leathers, and vest to become a full-time A.I.M. mercenary. In the year he's been with the organization, Nails has taken advantage of his knowledge about car bombs to become a military explosives expert. Despite his career change, he hasn't lost his combative edge or substantial belly he developed as a renegade biker. Edgar has a knack for getting into inaccessible places, just as long as they aren't too small and narrow." - Jagged Alliance 2

Additional info:

Ex-biker, tough guy.
Voice: Heavy, deep and raspy.
Takes a jovial pleasure in killing.
Likes let out a sick laugh when he's having fun.
Calls people Scooter; a friendly put-down.
Do not even think about touching the leather jacket.]],
  StartingLevel = 4,
  MaxHitPoints = 72,
  Likes = {"Fox"},
  StartingPerks = {
    "MeleeTraining",
    "Psycho",
    "Claustrophobic",
    "NailsPerk",
    "TakeAim",
    "InstantAutopsy",
    "LineBreaker"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Nails"})
  },
  Equipment = {"Nails"},
  Tier = "Elite",
  Specialization = "ExplosiveExpert",
  gender = "Male"
}
