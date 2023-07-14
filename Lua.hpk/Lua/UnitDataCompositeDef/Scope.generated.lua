UndefineClass("Scope")
DefineClass.Scope = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 86,
  Agility = 89,
  Dexterity = 76,
  Strength = 64,
  Wisdom = 83,
  Leadership = 39,
  Marksmanship = 99,
  Mechanical = 4,
  Explosives = 21,
  Medical = 17,
  Portrait = "UI/MercsPortraits/Scope",
  BigPortrait = "UI/Mercs/Scope",
  Name = T(630357922162, "Sheila \"Scope\" Sterling"),
  Nick = T(616337703669, "Scope"),
  AllCapsNick = T(947910685503, "SCOPE"),
  Bio = T(706856939539, "Formerly with the British SAS, nobody gets into position quicker and makes the kill shot better than Scope. She once recorded six confirmed kills in one night-raid on an enemy military base, moving so quickly between buildings in the dark that the opposition thought they were being attacked on all sides. A consummate professional, Scope is also generous with passing on to other mercs her various tips and tricks."),
  Nationality = "England",
  Title = T(125612851314, "Guardian Mother of the Battlefield"),
  Email = T(792449207788, "scopeandbiscuits@aim.com"),
  snype_nick = T(110116698394, "scopeandbiscuits"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(491860556098, "I am afraid your rather sorry financial situation puts a damper on things. I do not work unless I am sure I will get paid. Beg your pardon.")
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
          T(233936267389, "Unfortunately, your casualty rate is frightening and reflects a carelessness on your part I simply cannot excuse. I will not be entering your employment.")
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
          T(934501718003, "I want to spend more time with my kids. I have already missed so much time with them. I prefer to have a shorter contract, thank you.")
        })
      },
      "Type",
      "duration",
      "Duration",
      "long"
    })
  },
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(144156829230, "I'd never allow an opportunity to work with Sidney to pass me by. I shall put my misgivings about you aside and agree to your terms.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Sidney"})
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
          T(533577545840, "Great, love. Now, I will give you a bit of advice for free - whenever you can, hire Sidney. He is a legend and will make sure your plans work.")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(548856167739, "Ta, until then. Must go. Biscuits in the oven. I'll bring you some!")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Sidney"})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(945988831482, "This is Scope Sterling. Unfortunately, I am currently offline. I will make certain you are notified when I am available.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(700818684654, "Hello. You have my undivided attention. Shall we start?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(762646434698, "Alas, we got disconnected. How about we carry on?")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(232882685066, "I don't suppose we could speed things up? I've biscuits in the oven.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(635926695231, "Cheers, love. Now that all that's in order, I can't wait to meet you. I'll bring biscuits and we'll have a spot of tea.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(606582024557, "Pardon the intrusion but my contract is coming to an end. Shall we continue to work together?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(294477608448, "Brilliant. Now that's settled, let's carry on.")
    })
  },
  DurationDiscount = "none",
  StartingSalary = 2600,
  SalaryIncrease = 200,
  SalaryMaxLv = 4900,
  LegacyNotes = [[
"As a former member of the British Special Forces, Sheila Sterlin was stationed in Belfast. She is en expert sharpshooter and trained in the art of urban warfare. Though she's new in the organization, Scope is a professional with impressive credentials." - A.I.M. Dossier, Jagged Alliance: Deadly Games

"First off, a correction is in order: Sterling's previous bio mistakenly stated that she was a member of the British Special Forces when, in fact, no such service exsists. She served with the British Special Air Service (SAS). A.I.M. regrets the error and any inconvenience it may have caused.

Additional Info: Trained in urban warfare, Scope is an expert markwoman and is well-versed in night operations." - A.I.M. Dossier, Jagged Alliance 2]],
  StartingLevel = 5,
  MaxHitPoints = 87,
  Likes = {"Sidney"},
  StartingPerks = {
    "NightOps",
    "HawksEye",
    "CancelShotPerk",
    "SteadyBreathing",
    "DeathFromAbove",
    "OpportunisticKiller"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Scope"})
  },
  Equipment = {"Scope"},
  Tier = "Legendary",
  Specialization = "Marksmen",
  pollyvoice = "Kendra",
  gender = "Female",
  blocked_spots = set("Weaponls", "Weaponrs"),
  VoiceResponseId = "Scope"
}
