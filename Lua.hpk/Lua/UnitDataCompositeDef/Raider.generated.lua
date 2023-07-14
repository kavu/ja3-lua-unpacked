UndefineClass("Raider")
DefineClass.Raider = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 80,
  Agility = 71,
  Dexterity = 78,
  Strength = 80,
  Wisdom = 76,
  Leadership = 91,
  Marksmanship = 84,
  Mechanical = 12,
  Explosives = 20,
  Medical = 11,
  Portrait = "UI/MercsPortraits/Raider",
  BigPortrait = "UI/Mercs/Raider",
  Name = T(931473807439, "Ron \"Raider\" Higgens"),
  Nick = T(730316817764, "Raider"),
  AllCapsNick = T(627615371784, "RAIDER"),
  Bio = T(153322253794, "After helping to liberate Arulco, Ron and his wife Charlene decided to take some time off and went for a cruise in the Red Sea. Their ship was attacked by Somali pirates, which turned out to be very unfortunate for the pirates. Using skills from his days as a SWAT team leader, Ron quickly instructed a number of young junior assistant pursers how to fire pistols and then proceeded to repel all boarders. Rested and relaxed, he and his wife are ready for assignment."),
  Nationality = "USA",
  Title = T(435483333529, "Officer Trust Fall"),
  Email = T(699223544963, "ron_higgens@aim.com"),
  snype_nick = T(477901286663, "ron_higgens"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(461295796241, "Sorry, but the answer's no. You have hired that sleazeball Henessy. I don't want to work with that dirtbag.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Hitman"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(500784963638, "Can't talk right now. I need to grieve after... I just need to grieve, for God's sake! Leave me alone!")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Dead", TargetUnit = "Raven"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(500784963638, "Can't talk right now. I need to grieve after... I just need to grieve, for God's sake! Leave me alone!")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Dead", TargetUnit = "Raven"})
      },
      "chanceToRoll",
      100,
      "Type",
      "rehire"
    })
  },
  Haggles = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(152229577577, "I think we can make this work, but I don't know you. I will need some extra assurance in case our working relationship isn't a smooth one.")
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
          T(607540753610, "Look, I have no issues with you whatsoever, but that sleazeball is really getting on my nerves. I can continue to tolerate him, but it's gonna cost you extra.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Hitman"})
      },
      "chanceToRoll",
      100
    })
  },
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(784584870498, "Normally, I would have said no, but Raven and I are a team. Where she goes, I'll gladly follow.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Raven"})
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
          T(346994478220, "Glad to be a part of a team again. By the way, why not hire Raven, as well? She gets ornery if she's alone in the house for too long. Might hunt the whole country to extinction by the time I'm back.")
        })
      },
      "Conditions",
      {
        PlaceObj("AND", {
          Conditions = {
            PlaceObj("UnitHireStatus", {TargetUnit = "Raven"})
          }
        })
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatBranch", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(762507617971, "It will be good to be working with Raven again. Just a word of caution - Hitman Henessy is a sleazeball who hits on my wife and I will not stand for it. If you want a squad at peace, you better not hire that dirtbag.")
        })
      },
      "Conditions",
      {
        PlaceObj("AND", {
          Conditions = {
            PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Raven"}),
            PlaceObj("UnitHireStatus", {TargetUnit = "Hitman"})
          }
        })
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatBranch", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(969430937663, "I'm glad to be part of any team Raven's a part of.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Raven"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatBranch", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(293660560234, "Thanks. It will be weird working with both Hitman and Raven. I hope we can avoid working too closely with him, but if that sleazeball hits on her, I swear...")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(663569190804, "Let's just say I'm glad to be part of any team Raven's a part of.")
        })
      },
      "Conditions",
      {
        PlaceObj("AND", {
          Conditions = {
            PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Raven"}),
            PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Hitman"})
          }
        })
      },
      "chanceToRoll",
      100
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(327572518181, "Y'ello. This is Ron Higgens. I am probably out hunting. Or in an undisclosed location. Probably with Raven. Used to be top cop, now I am for hire. Call me if you need me.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(209759364976, "Y'ello. Ron here. Is this about a job? If so, I'm interested.")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(809685478401, "Had some urgent matters to take care of? Anyway, where were we?")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(817195692149, "I don't like wasting time. Can we move on?")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(787993971305, "Glad to be a part of a team again. See you soon.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(925115055169, "It's time to renegotiate my contract.")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(826231578564, "Well that's that. Now let's move. ")
    })
  },
  StartingSalary = 1800,
  SalaryIncrease = 220,
  SalaryLv1 = 760,
  SalaryMaxLv = 4200,
  LegacyNotes = "\"Lt. Ron Higgens is a former commander of the Los Angeles SWAT team. When he fell in love with his ace sniper, Sgt. Charlene Higgens, they managed to keep their relationship a secret up until a year ago. When they decided to marry, the L.A.P.D. refused to allow them to continue working together, so they joined A.I.M. He's organized, experienced, and decisive. Raider is a natural leader. \"",
  StartingLevel = 4,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "Firearm")
    self:TryEquip(items, "Handheld B", "Firearm")
  end,
  MaxHitPoints = 80,
  Likes = {"Raven"},
  Dislikes = {"Hitman"},
  StartingPerks = {
    "Negotiator",
    "Teacher",
    "TagTeam",
    "Flanker",
    "HitTheDeck",
    "Shatterhand"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Raider"})
  },
  Equipment = {"Raider"},
  Tier = "Elite",
  Specialization = "Leader",
  pollyvoice = "Matthew",
  gender = "Male",
  blocked_spots = set("Weaponls", "Weaponrs"),
  VoiceResponseId = "Raider"
}
