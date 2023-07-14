UndefineClass("Len")
DefineClass.Len = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 87,
  Agility = 78,
  Dexterity = 88,
  Strength = 77,
  Wisdom = 83,
  Leadership = 68,
  Marksmanship = 83,
  Mechanical = 54,
  Explosives = 47,
  Medical = 35,
  Portrait = "UI/MercsPortraits/Len",
  BigPortrait = "UI/Mercs/Len",
  Name = T(856122685331, "Corp. Len Anderson"),
  Nick = T(100823268874, "Len"),
  AllCapsNick = T(765224105732, "LEN"),
  Bio = T(651747616157, "Recruited out of high school directly into the military, Len has seen combat for most of his adult life. After being honorably discharged from the Green Berets, Len became a soldier of fortune and was one of A.I.M.'s first members. With elite skills in every aspect of soldiering and years of battling warlords and rescuing kidnapped businessmen, Len has earned a reputation as a revered leader and mentor to mercenaries and feared adversary to third world dictators the world over."),
  Nationality = "USA",
  Title = T(452293562944, "The Soldier's Soldier"),
  Email = T(159574405546, "corporal_anderson@aim.com"),
  snype_nick = T(152770436506, "corporal_anderson"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(728045541164, "I hear stories about your style of command. A lot of soldiers come home in body bags. To survive as many battles as I have, I had to learn when to say no. This is one of those times.")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(334870751923, "I decline your offer. Goodbye.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionDeathToll", {PresetValue = "2+"})
      }
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(779667141211, "Something about you just does not sit right with me. I have earned the right to pick my commanders and you do not fit the bill.")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(615940175069, "I decline your offer. Goodbye.")
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
          T(252206147171, "I am sorry, Commander, but your leadership is sloppy. Good people lost their lives under your command. I do not want to be next. ")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(483984421915, "I'm afraid I cannot extend my contract with you.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionDeathToll", {PresetValue = "2+"})
      },
      "Type",
      "rehire"
    })
  },
  Haggles = {},
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(775023517205, "In the time I've known Dr. Q., he has proven himself to be an exceptional soldier and a master of medicine. It would be a pleasure to work with him again.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "DrQ"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(226612508863, "Not that your leadership isn't without its problems, but working with Vicki does allow me to cut you some slack.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Vicki"})
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
          T(130371395685, "Very well. I agree to these terms. I would highly suggest you hire Dr. Q. - an exceptional soldier and medic. It will be a pleasure working with him again.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "DrQ"})
      }
    }),
    PlaceObj("MercChatBranch", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(989283642424, "Very well. I agree to these terms. By the way, if you are looking for an excellent mechanic, Vicki is the woman for the job. She even got my old Chevy purring like a kitten.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Vicki"})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(593193742103, "This is Corporal Len Anderson. I am currently unavailable. When I am present, I will make sure to notify you.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(499964957820, "Good day. Corporal Len Anderson at your service. I am currently available for recruitment. Please state your offer.")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(623982343340, "Damn technology stopped working for a spell. Where were we?")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(794781501609, "I am not in the business of abiding time-wasting. Can we move along?")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(453156990394, "Excellent. I will start my preparations and will arrive on the dot.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(531047441945, "Commander, my contract needs to be extended if my service is to continue. I suggest we get to it.")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(822598459526, "An excellent outcome. Now, let's get back to the task at hand.")
    })
  },
  StartingSalary = 2150,
  SalaryIncrease = 210,
  SalaryLv1 = 170,
  SalaryMaxLv = 3600,
  LegacyNotes = [[
JA1:

"A member in excellent standing, Len Anderson has been fighting for truth and justice since his teens. A onetime member of the Green berets and a longtime member of A.I.M., his salary may seem excessive, but his extraordinary abilities easily merit the price." - Jagged Alliance.

JA2:
"A career military man, Anderson was barely out of his teens before he joined the Green berets. After serving with distinction, he joined A.I.M. as one of its original members and fought alongside A.I.M.s founders in the battle for Angetta. Len is a strong leader, his tours of duty has earned him the respect and appreciation of many." - Jagged Alliance 2

Additional info:
Back in his home town, the community minded Anderson teaches a NRA course on the proper care and handling of automatic weapons.

Notes:
In Jagged Alliance 2, Len's skills and experience don't advance. This is intended and not a bug (old dog and new tricks) and partly explain his very low price for his level. His baseline skills still make him worth hiring however, especially towards endgame.
Somewhat gravelly voice. Tough as nails, no-nonsense and honest in his assessments.
Respect is earned and not given with this man.
Has no fear of criticising poor leadership.
Reminds of a hard but honest drill sergeant. Tends to be very by-the-book, otherwise.]],
  StartingLevel = 7,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "Firearm")
    self:TryEquip(items, "Handheld B", "Firearm")
  end,
  MaxHitPoints = 89,
  Likes = {
    "Spike",
    "Vicki",
    "DrQ"
  },
  LearnToDislike = {"Omryn"},
  StartingPerks = {
    "Teacher",
    "OnMyTarget",
    "OldDog",
    "Flanker",
    "LightningReaction",
    "Deadeye",
    "Counterfire",
    "Hobbler",
    "StressManagement"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Len"})
  },
  Equipment = {"Len"},
  Tier = "Legendary",
  Specialization = "Leader",
  pollyvoice = "Russell",
  gender = "Male",
  VoiceResponseId = "Len"
}
