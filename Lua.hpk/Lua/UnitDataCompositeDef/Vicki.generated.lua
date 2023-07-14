UndefineClass("Vicki")
DefineClass.Vicki = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 79,
  Agility = 84,
  Dexterity = 72,
  Strength = 70,
  Wisdom = 85,
  Leadership = 33,
  Marksmanship = 85,
  Mechanical = 95,
  Explosives = 28,
  Medical = 18,
  Portrait = "UI/MercsPortraits/Vicky",
  BigPortrait = "UI/Mercs/Vicky",
  Name = T(997941066310, "Victoria \"Vicki\" Waters"),
  Nick = T(982571881202, "Vicki"),
  AllCapsNick = T(912931350387, "VICKI"),
  Bio = T(978581055615, "A crack shot with pistols, the ambidextrous Vicki Waters is an asset to any team. She's currently working as a mechanic for James \"Skyrider\" Bullock, keeping his helicopter flying while he offers aerial tours of Arulco. The rumor is their partnership isn't just financial, but Vicki has informed A.I.M. she is ready for action should a good contract come her way."),
  Nationality = "Jamaica",
  Title = T(584992608799, "The Maven of Mechanics and Mayhem"),
  Email = T(459711242023, "deadly_vicki@aim.com"),
  snype_nick = T(600504575562, "deadly_vicki"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(486816886469, "No thanks, man. I hear it's a boys club in your team. I will not be doing this to myself again. All them boys acting like teenagers around me.")
        })
      },
      "Conditions",
      {
        PlaceObj("CheckExpression", {
          Expression = function(self, obj)
            return table.count(gv_UnitData, "HireStatus", "Hired") > 3 and table.count(gv_UnitData, function(ud)
              return gv_UnitData[ud].HireStatus == "Hired" and gv_UnitData[ud].gender == "Female"
            end) == 0
          end
        })
      }
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(249681548198, "No thanks, man. There are some nasty rumors flyin' around about you. I need to make some calls before I can trust you. Call me another time.")
        })
      },
      "Conditions",
      {},
      "chanceToRoll",
      20
    })
  },
  Haggles = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(723908821448, "I don't trust you, man. You be having some dead mercs and that's a red flag. I am good enough to survive but you'll be payin' me extra.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionDeathToll", {PresetValue = "1"})
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
          T(901575776171, "You need to be payin' me more as a fine for having hired a creep like Smiley. That boy needs to be taught some respect.")
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
              TargetUnit = "Vicki"
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
          T(581903016213, "Well, I be tellin' ya, I've had better offers, but it will be nice to work with women for a change. It's an all boys clubs these days. I guess I'm in.")
        })
      },
      "Conditions",
      {
        PlaceObj("CheckExpression", {
          Expression = function(self, obj)
            return table.count(gv_UnitData, function(ud)
              return gv_UnitData[ud].HireStatus == "Hired" and gv_UnitData[ud].gender == "Female"
            end) >= 2
          end
        })
      },
      "chanceToRoll",
      100
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(155504263416, "This is Vicki Waters. I be either on assignment or at the shop. So, leave me your vitals, and I be getting back to you as soon as I can.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(390177396694, "Vicki Waters. Who I be speaking with?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(654047163706, "Back again? Good.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(166872348899, "Come on, mon, spit it out.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(490243743780, "Good to come to an agreement with you! I'll show you how a real merc performs.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(105250329735, "My contract be almost up, mon. Would you be wantin' to renew it?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(672945741836, "That's right! You get a taste of Vicki Waters, you always come back for more!")
    })
  },
  MedicalDeposit = "large",
  StartingSalary = 2000,
  SalaryIncrease = 290,
  SalaryLv1 = 700,
  SalaryMaxLv = 5300,
  LegacyNotes = "\"Victoria Waters is without a doubt A.I.M.\194\146s finest female mercenary. Possessing deadly aim, determination and an experience class any mercenary would be proud of, Victoria works best with her hands and is currently restoring her dad\194\146s '64 Chevy.\" - Jagged Alliance\n\nJA1:\n\n\"Whether it's repairing a handgun or firing off automatic weapon bursts, the ambidextrous Victoria Waters works best with her hands. Aside from working for A.I.M., Vicki spends her spare time managing Vicki's Vintage Automobiles, her own restoration and antique car dealership. Despite constant teasing, Vicki insists on using the stairs no matter how tall the building.\" - Jagged Alliance 2\n\nJA2:\n\nAdditional info:\nJamaican accent.\nVery methodical and determined. No-nonsense.\nThe easy-going accent, contrasts her forceful dialogue. It also contrasts her mechanical abilities by giving her a sense of sophistication.",
  StartingLevel = 4,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "Firearm")
    self:TryEquip(items, "Handheld A", "Firearm")
  end,
  MaxHitPoints = 79,
  LearnToDislike = {"Smiley"},
  StartingPerks = {
    "Ambidextrous",
    "Throwing",
    "Claustrophobic",
    "WeaponPersonalization",
    "TakeAim",
    "Hobbler",
    "Flanker"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Vicki"})
  },
  Equipment = {"Vicki"},
  Tier = "Elite",
  Specialization = "Mechanic",
  pollyvoice = "Aditi",
  gender = "Female",
  VoiceResponseId = "Vicki"
}
