UndefineClass("Fauda")
DefineClass.Fauda = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 78,
  Agility = 79,
  Dexterity = 45,
  Strength = 82,
  Wisdom = 81,
  Leadership = 64,
  Marksmanship = 80,
  Mechanical = 61,
  Explosives = 66,
  Medical = 19,
  Portrait = "UI/MercsPortraits/Fauda",
  BigPortrait = "UI/Mercs/Fauda",
  Name = T(433525179007, "Kevi \"Fauda\" Agit"),
  Nick = T(786968855598, "Fauda"),
  AllCapsNick = T(560956094378, "FAUDA"),
  Bio = T(847511420495, "For several years, Kevi and her brother Zoran were legendary fighters for the Peshmerga. After an ambush by Iraqi Nationalists left Zoran dead and Kevi traumatized, she was forcibly retired from active duty. Not ready to give up the fight, she joined A.I.M. and resolved to earn enough money that she could one day raise her own personal army and return to her homeland to avenge her brother. In combat, Kevi earned the name \"Fauda\" because she alternates between being recklessly aggressive and overly cautious. What never wavers, however, is her stunning ability with big guns and thrown explosives, both of which she wields with deadly effectiveness."),
  Nationality = "Iraq",
  Title = T(301899503224, "Peshmerga Deadly Dervish"),
  Email = T(990035155352, "Fauda@aim.com"),
  snype_nick = T(910030716918, "FaudaAgit"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(608786325446, "How can you hire anyone if you are a beggar? Come back when you can afford to hire good soldiers, then we will talk.")
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
          T(431816852528, "How can you keep me if you have no money? I told you to take all spoils from battle but you do not listen. If you cannot keep a big war chest, I will not continue to work for you.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionMoney", {})
      },
      "Type",
      "rehire"
    })
  },
  HaggleRehire = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(905829914489, "Working for you is dull and pointless. I came to fight and kill the agents of Shaitan. Instead, I sit in camp doing empty work. I spit on this. If I am to be doing nothing you will pay me more!")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionCombatParticipate", {})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(510251097592, "This machine is made by Shaitan! Where is button? ...Oh. Ahem. This is Fauda Agit. I am not in machine right now. I am on a job. Contact me again when I am not on a job. Machine will know.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(803966294859, "Greetings. I am Fauda. Do you have a job for me?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(109033566183, "Shaitan moves through machine to interrupt us, but he is weak and we are strong. Now we can continue our discussion.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(170860465782, "Did Shaitan take your tongue? Speak!")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(929498218341, "Good. I will kill your enemies in the name of my brother so I can face him with clear eyes when I die. ")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(647351259105, "I want to continue my contract. Do you agree?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(913491882738, "Good. Enough of this now. Let us return to our work.")
    })
  },
  StartingSalary = 2350,
  SalaryIncrease = 200,
  SalaryLv1 = 500,
  SalaryMaxLv = 4000,
  StartingLevel = 7,
  MaxHitPoints = 80,
  LearnToDislike = {"Kalyna", "Fox"},
  StartingPerks = {
    "HeavyWeaponsTraining",
    "OldDog",
    "KillingWind",
    "HitTheDeck",
    "SteadyBreathing",
    "StressManagement",
    "CancelShotPerk",
    "TakeAim",
    "BreachAndClear",
    "Ironclad"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Fauda"})
  },
  Equipment = {"Fauda"},
  Tier = "Legendary",
  Specialization = "ExplosiveExpert",
  pollyvoice = "Joanna",
  gender = "Female",
  VoiceResponseId = "Fauda"
}
