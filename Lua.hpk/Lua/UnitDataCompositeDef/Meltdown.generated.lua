UndefineClass("Meltdown")
DefineClass.Meltdown = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 78,
  Agility = 77,
  Dexterity = 84,
  Strength = 76,
  Wisdom = 80,
  Leadership = 24,
  Marksmanship = 83,
  Mechanical = 22,
  Explosives = 40,
  Medical = 3,
  Portrait = "UI/MercsPortraits/Meltdown",
  BigPortrait = "UI/Mercs/Meltdown",
  Name = T(627005316845, "Norma \"Meltdown\" Jessop"),
  Nick = T(801416212893, "Meltdown"),
  AllCapsNick = T(518123328833, "MELTDOWN"),
  Bio = T(973893751536, "As fierce as she is profane, Norma Jessop is a woman not to be taken lightly. Always ready and eager for a fight, Meltdown revels in killing her enemies in the bloodiest and most explosive way imaginable. Although ambidextrous and often seen with a pistol in each hand, her preference is for heavy weapons. As she likes to say, 'if there isn't at least a little collateral damage, you didn't do it right'. Property insurers refuse to pay out any claims in locations Norma recently visited."),
  Nationality = "USA",
  Title = T(771770749853, "Goddamned Role Model"),
  Email = T(337960420959, "trailerqueen69@aim.com"),
  snype_nick = T(672285437236, "trailerqueen69"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(585931569314, "Aw damn! Goddamn dogs are fightin again... Hang on... Shit. Gotta go. Gotta take the neighbor's kid to the hospital again. MY FRIGGIN DOGS AIN'T FOR PETTIN! Says so right there on the sign.")
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
          T(461192928382, "No way, pal! You got a bad rep for gettin mercs killed. If I wanted to do something suicidal, I'd move back in with my ex!")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionDeathToll", {PresetValue = "2+"})
      }
    })
  },
  HaggleRehire = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(569509023059, "Hey! I thought I was gonna see some action. Most danger I seen so far was the tacos I had for lunch. Thought I'd never get off the toilet. I got better things to do than hang around and look pretty for ya. Kick in some extra money or I'll start these boots a-walkin.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionCombatParticipate", {})
      }
    })
  },
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(108651033026, "I was about to tell you where to stick it, but I see you're sitting on a fat wad of dough. Mama like. I hope that means you'll buy me some nice toys to play with. All right, I'm in.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionMoney", {PresetValue = ">=50"})
      },
      "chanceToRoll",
      100
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(853843382687, "This here's Meltdown's account. You want to offer me a job? Leave a message. Otherwise, piss off.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(359198286308, "Meltdown here. This about a job?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(805237372457, "You again? The hell you want?")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(533736630214, "Hey, you still there? You lookin at porn or something? You better not be doing that thing with peanut butter my ex used to do when he was on the internet.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(221657714144, "All right. Deal. Get ready. Hurricane Norma's a-comin.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(933208110208, "Hey there, boss. Our little contract is almost up. You want me to keep killing folk for you or what?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(450120703239, "Good enough. I'll stick around. You keep giving me targets and I'll keep giving you bodies.")
    })
  },
  MedicalDeposit = "large",
  StartingSalary = 720,
  SalaryLv1 = 200,
  SalaryMaxLv = 3100,
  LegacyNotes = [[
"Don't mess with Meltdown. She may be smiling in her file photo, but that smile is certainly deceptive. This mercenary is legendary; an enemy once died at her feet from fear before Meltdown had even raised her weapon. As for her taste in weapons, the bigger, the better. In fact, Meltdown has a tendency for overkill in virtually every aspect of her life. Jessop is remarkably ambidextrous; she can easily fire two weapons simultaneously. " A.I.M Dossier

Additional info:

A foul-mouthed, kickass woman who could clear a bar in no time.
You'd shake in fear just looking at her.
Loves violence and killing.
Generally misanthropic, and has especially little time for cowards. Admires Rothman for his ability to instill discipline, and Rothman appreciates her no-nonsense attitude.]],
  StartingLevel = 3,
  MaxHitPoints = 78,
  StartingPerks = {
    "HeavyWeaponsTraining",
    "Ambidextrous",
    "Psycho",
    "BeefedUp",
    "TakeAim",
    "VengefulTemperament"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Meltdown"})
  },
  Equipment = {"Meltdown"},
  Tier = "Veteran",
  Specialization = "AllRounder",
  pollyvoice = "Kendra",
  gender = "Female",
  blocked_spots = set("Weaponls", "Weaponrs"),
  VoiceResponseId = "Meltdown"
}
