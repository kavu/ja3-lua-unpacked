UndefineClass("Scully")
DefineClass.Scully = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 89,
  Agility = 88,
  Dexterity = 95,
  Strength = 87,
  Wisdom = 93,
  Leadership = 70,
  Marksmanship = 92,
  Mechanical = 61,
  Explosives = 66,
  Medical = 36,
  Portrait = "UI/MercsPortraits/Scully",
  BigPortrait = "UI/Mercs/Scully",
  Name = T(357879375429, "Robert James Sullivan"),
  Nick = T(639079993068, "Scully"),
  AllCapsNick = T(250215016589, "SCULLY"),
  Bio = T(953273652898, "Although he hails from the British Isles, considerable time spent catching waves down under has made Scully all but indistinguishable from an Aussie. Many mercs consider him to be perhaps the best soldier in A.I.M.'s ranks, although his friendly disposition no doubt contributes to his popularity. Regardless, there is very little this man can't do and do well. He excels at knife fighting but can reliably work with firearms and explosives as well as toolboxes and med kits."),
  Nationality = "England",
  Title = T(167544469426, "Unchained Virility"),
  Email = T(681435230668, "surfercad@aim.com"),
  snype_nick = T(160407166740, "surfercad"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(745877789753, "Tough luck, mate. Would have liked to help you out, but I got to get paid and you don't look like you will be able to pay for long. ")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionMoney", {})
      }
    })
  },
  Haggles = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(818027287856, "These ex-wives, mate. They want the shirt off my back. I'll need something extra to be able to pay them all. ")
        })
      },
      "Conditions",
      {}
    })
  },
  HaggleRehire = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(912379028022, "One of my kids needs something for school. Or college. Or kindergarten. Hard to keep track. Anyway, I need you to spare some more green. Right, mate?")
        })
      },
      "Conditions",
      {}
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(856479969152, "This is Robert James Sullivan. I'm out right now, mate. I'll make sure to let you know when I'm back, unless you are one of my exes. In which case, piss off.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(216691834397, "Hey, mate. Got some business for me?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(315006940630, "Hey, mate. Good to hear from you again.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(724445502375, "Time is money, mate. And I need it for paying alimony. Let's speed this up.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(460394638505, "Great! I can definitely use some time away from here.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(491402142223, "Clock's running, mate. This gig's coming to a close. Are we renewing or what?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(376480401551, "All right, mate. It's back to business.")
    })
  },
  Haggling = "low",
  StartingSalary = 4300,
  SalaryIncrease = 200,
  SalaryLv1 = 1900,
  SalaryMaxLv = 6800,
  LegacyNotes = [[
JA1:

"Robert James Sullivan is a distinguished member of A.I.M. and is known in the business as a fearless "finisher". When the chips are down and the enemy's jugular is exposed, there's no better man with a knife in his hand than "Scully"."

JA2:

"The amiable Scully Sullivan is a long-time A.I.M. member. He's one of our most distinguished mercenaries and perhaps the most respected among his peers. Scully holds the A.I.M. record for the highest number of combat engagements in almost as many different countries. Need someone to snap the last breath from an enemy? Then Sullivan's your man. Scully is well-known for his skills with a bladed weapon."

Additional info:

Scully is a super friendly guy. He's been married eight times and has twenty one kids.
Though British, he has a out-going demeanor easily mistaken for Australian. His cockney accent, tanned complexion and propensity to call people "mate" doesn't help.
Deadly, yet exhibits no fascination for gore.
We are told, over and over, that Scully is well known for his skill with blades.
He likely holds the record for combat engagements in Jagged Alliance 2 now due to the departure of his old friend Mike.]],
  StartingLevel = 5,
  MaxHitPoints = 90,
  StartingPerks = {
    "MeleeTraining",
    "Optimist",
    "ShoulderToShoulder",
    "BeefedUp",
    "TrueGrit",
    "HoldPosition",
    "Deadeye"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Scully"})
  },
  Equipment = {"Scully"},
  Tier = "Legendary",
  Specialization = "Leader",
  gender = "Male"
}
