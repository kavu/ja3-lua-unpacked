UndefineClass("Blood")
DefineClass.Blood = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 84,
  Agility = 94,
  Dexterity = 88,
  Strength = 83,
  Wisdom = 73,
  Leadership = 6,
  Marksmanship = 78,
  Mechanical = 23,
  Explosives = 31,
  Medical = 51,
  Portrait = "UI/MercsPortraits/Blood",
  BigPortrait = "UI/Mercs/Blood",
  Name = T(341095663210, "Keith \"Blood\" Hanson"),
  Nick = T(697027342093, "Blood"),
  AllCapsNick = T(941246151451, "BLOOD"),
  Bio = T(879797808599, "Don't let Blood's genial disposition fool you. He knows thirty different ways to kill a person using just his hands, although his preference is by doing it with a skillfully thrown knife. A former member of the ANC, nothing gives Keith more pleasure than helping a downtrodden people overthrow their oppressors, preferably by using exceptionally violent methods."),
  Nationality = "SouthAfrica",
  Title = T(656795996276, "There Will Be Blood"),
  Email = T(672490755828, "soulfood_warrior@aim.com"),
  snype_nick = T(240898156196, "soulfood_warrior"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(426442139990, "You see, I gotta get paid, and your portfolio looks a bit thin right now.")
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
          T(475250829783, "You are a new face to me. I usually don't like to work with strangers, but if we can agree to up my rate a bit, I'll make an exception.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionRehire", {})
      },
      "chanceToRoll",
      20
    })
  },
  HaggleRehire = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(588114353209, "I expected to see a little more action. You want me to hang around camp and cook meals, that's just fine, but I'm going to need some fancier ingredients to stay interested. What say you kick in a little more money?")
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
          T(205066005249, "Anyone who's got Magic Walker on their team's gotta be doing something right. You got me, too.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Magic"})
      },
      "chanceToRoll",
      100
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(267868205180, "Check out this high-tech messenger service! Very cool! Welcome to the 21st century! Leave a message and I'll get right back to you.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(199682617046, "Blood here. What is up?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(277793194502, "Let's pick up where we left off.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(905505064939, "Pick up the pace, man. I got dinner cooking.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(303024294883, "All right! Now you're cooking with fire!")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(408648943422, "Sorry to say it, man, but my time here's almost up. What are we thinking?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(729529774361, "Good! Now we can get back to enjoying local cuisine and killing bad guys!")
    })
  },
  MedicalDeposit = "large",
  StartingSalary = 770,
  SalaryLv1 = 350,
  SalaryMaxLv = 3000,
  LegacyNotes = [[
"Whether it's jungle warfare or close-quartered combat, Blood Hanson is your man for the assignment. Trained in the martial arts, his ability to fling a combat knife into an enemy's neck is a sight to behold: it seems to come out of nowhere, sails an impossibly large distance, then slices through it's target with unerring accuracy.

Additional info: Keith Hanson is a former member of the ANC." - A.I.M. Dossier]],
  StartingLevel = 3,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "Firearm")
    self:TryEquip(items, "Handheld B", "MeleeWeapon")
  end,
  MaxHitPoints = 84,
  Likes = {"Magic"},
  StartingPerks = {
    "MartialArts",
    "HundredKnives",
    "BreachAndClear",
    "OptimalPerformance",
    "Throwing"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Blood"})
  },
  Equipment = {"Blood"},
  Tier = "Veteran",
  Specialization = "Marksmen",
  gender = "Male"
}
