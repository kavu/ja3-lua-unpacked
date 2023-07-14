UndefineClass("Fidel")
DefineClass.Fidel = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 88,
  Agility = 83,
  Dexterity = 64,
  Strength = 83,
  Wisdom = 62,
  Leadership = 1,
  Marksmanship = 86,
  Mechanical = 6,
  Explosives = 98,
  Medical = 3,
  Portrait = "UI/MercsPortraits/Fidel",
  BigPortrait = "UI/Mercs/Fidel",
  Name = T(118909675158, "Fidel Dahan"),
  Nick = T(489035873223, "Fidel"),
  AllCapsNick = T(127950817003, "FIDEL"),
  Bio = T(888155597181, "Although not officially listed as a suspect by Arulco authorities, there is little doubt at A.I.M. that Fidel blew up a video store in Alma after the proprietor refused to allow him into the back room. Thankfully, no one was hurt - a fact Fidel seems to lament - and A.I.M. has cleared him for active duty due to the high demand for his skills with explosives and firearms."),
  Nationality = "Cuba",
  Title = T(337961143159, "The Continuing Cuban Crisis"),
  Email = T(735301247589, "fidelmakeboom@aim.com"),
  snype_nick = T(843991705045, "fidelmakeboom"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(601499126033, "Nasty teenagers write bad words on Fidel's door. So, Fidel waits and when booby trap explodes, Fidel must nail the body parts to the door to teach them lesson. So, Fidel is busy now. Maybe later.")
        })
      },
      "Conditions",
      {},
      "chanceToRoll",
      10
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(322149216469, "Fidel is bored with job. You don't use Fidel to kill enemy. Fidel no more work for you.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionCombatParticipate", {})
      },
      "Type",
      "rehire"
    })
  },
  HaggleRehire = {},
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(821638510526, "This is machine that talks like Fidel. Fidel is killing enemy now. If you want to hire Fidel to kill enemy, contact later. If you are enemy, Fidel is coming for you.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(400111149290, "This is machine that talks like Fidel. You want Fidel to kill enemies? Fidel also want to kill enemies. What is job?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(781594867566, "You had urge to kill enemy instead of talking? No worries. Fidel has same urges.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(101738114840, "TALK, MACHINE! TALK! FIDEL WILL BLOW YOU UP! ")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(783316549514, "I hope there is a lot of enemy. Fidel is bored.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(337330388680, "Machine says Fidel contract expires. There is still more enemy. Hire Fidel to kill enemy.")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(100497682392, "Good. Now, we go kill.")
    })
  },
  MedicalDeposit = "none",
  StartingSalary = 2000,
  SalaryLv1 = 700,
  SalaryMaxLv = 4250,
  LegacyNotes = [[
JA1:

"The irrepressible Fidel Dahan was bred for this business. At ease with firearms and explosives, he is wanted on a worldwide warrant for his role in the Cancun Catastrophe, but has managed to stay one step ahead of the organisations seeking his capture." - A.I.M. Dossier, Jagged Alliance

JA2: 

"Due to numerous employee complaints concerning his refusal to follow orders, Fidel "Leave me alone, I'm busy!" Dahan was recently suspended for a thirty-day period. Promising a changed attitude, he was returned to active duty by A.I.M. though because he is so proficient with both firearms and explosives." - A.I.M. Dossier, Jagged Alliance 2

Additional info:

Has a comical ruthlessness to him. Conveyed by a short, heavy, Cuban accent.
Usually mad about something, shows hints of a softer side but even that is tainted.
Extremely impatient. Type of guy that would force a square into a circle while blaming the square for his frustration.
Jagged Alliance 2 has Fidel "Not being quite himself lately". There are some hints suggesting this has something to do with the disappearance of Hurl E. Cutter.
Trivial bits of dialogue in various games suggest he may be homosexual.]],
  StartingLevel = 3,
  MaxHitPoints = 88,
  LearnToLike = {"Flay"},
  StartingPerks = {
    "MeleeTraining",
    "DoubleToss",
    "Psycho",
    "BreachAndClear",
    "InstantAutopsy"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Fidel"})
  },
  Equipment = {"Fidel"},
  Tier = "Veteran",
  Specialization = "ExplosiveExpert",
  gender = "Male",
  VoiceResponseId = "Fidel"
}
