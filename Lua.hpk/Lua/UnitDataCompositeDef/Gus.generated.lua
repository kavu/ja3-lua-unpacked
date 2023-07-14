UndefineClass("Gus")
DefineClass.Gus = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 74,
  Agility = 71,
  Dexterity = 84,
  Strength = 81,
  Wisdom = 94,
  Leadership = 85,
  Marksmanship = 95,
  Mechanical = 80,
  Explosives = 76,
  Medical = 71,
  Portrait = "UI/MercsPortraits/Gus",
  BigPortrait = "UI/Mercs/Gus",
  Name = T(427138476543, "Gus Tarballs"),
  Nick = T(732907985726, "Gus"),
  AllCapsNick = T(980126090528, "GUS"),
  HireStatus = "Retired",
  Bio = T(257144197846, "Although offered a position as senior military advisor to the restored monarchy in Arulco, the badly limping Tarballs reportedly turned down the offer because he wasn't 'a dang paper pusher'. After spending a couple of weeks helping to train a few squads of Arulco's new army in the use of heavy weapons, he grumbled something about finding himself a new leg and disappeared into the hinterland. As of this moment, he is still on A.I.M.'s active duty roster, but he hasn't checked his voicemail in months."),
  Nationality = "USA",
  Title = T(453788960669, "Not Cut Out for Management"),
  Email = T(844112356581, "morningnapalm@aim.com"),
  snype_nick = T(568370092426, "morningnapalm"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(367663661849, "No can do, Woodsman. I am retired now. Not that I ain't itching to get back into combat, but this damn leg hurts like a sunuvabitch.")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(434798682432, "I still dream of going out there with my old buddies, but most of them are dead by now. I miss those bastards. Anyhoo, retired means retired, Woody. Go bark up some other tree. ")
        })
      },
      "Conditions",
      {
        PlaceObj("CheckExpression", {})
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
          T(263880823235, "Dammit, I am retired, Woody. I should be staying at home doing whatever it is that retired people do. But being on the field again with Len... and it's not like you can't afford me either. ")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(886757961404, "Damn... I'm in, Woodruff. Don't make me regret my decision. ")
        })
      },
      "Conditions",
      {
        PlaceObj("AND", {
          Conditions = {
            PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Len"}),
            PlaceObj("MercChatConditionMoney", {PresetValue = ">=50"})
          }
        })
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(700927801510, "You really need to check what retired means, Woody. It means being a miserable old coot as far as I can tell. ")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(976770556216, "But you convinced Scully to join and even paid all his alimony, so I guess you ain't so bad. Damn you, Woodstuff, you have me convinced. I'm going with you. Screw retirement.")
        })
      },
      "Conditions",
      {
        PlaceObj("AND", {
          Conditions = {
            PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Scully"}),
            PlaceObj("MercChatConditionMoney", {PresetValue = ">=50"})
          }
        })
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
          T(498050185462, "Since you're putting the old gang back together, why not hire Scully as well? He's top notch and he'll be happy to get away from the ex-wives for a while.")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(476258380189, "Anyway, Tarballs out. I'll be seeing you soon, Woodchip.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Scully"})
      }
    }),
    PlaceObj("MercChatBranch", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(723868347890, "I hear Len is still out and about. He's a good soldier, even if he acts like he has a stick up his ass most of the time. If you're into old geezers like me, you should get him as well. ")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(476258380189, "Anyway, Tarballs out. I'll be seeing you soon, Woodchip.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Len"})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(318037696742, "I am retired. Leave me alone. No more jobs, just freaking retirement. All day every day. Don't contact me again.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(535111747196, "No. No way, Woody. I am out. For real this time. I can barely walk, anyway, with this blasted leg. ")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(623440416332, "Nope, Woody. I'm not going senile. You can't call me 5 minutes later and expect me to have forgotten our conversation. I'm still out.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(174739397106, "I'm supposed to be the old geezer out of touch with technology. What's the matter? Cat got your tongue? Or your mouse?")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(374431190814, "I guess I'll be seeing you soon, Woodward.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(615386056408, "Hey, Woody! Since you got me out and about the least you can do is extend my goddamned contract.")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(509965443319, "Damn right. Now let's get the bastards before my leg starts hurting again.")
    })
  },
  DurationDiscount = "none",
  StartingSalary = 4600,
  SalaryIncrease = 200,
  SalaryLv1 = 1800,
  SalaryMaxLv = 6500,
  LegacyNotes = [[
JA1:

Gus' officially appears for the first time in Deadly Games as a non-player character who hires the commander to perform a series of missions, eventually culminating in a takedown of terrorist organization DFK.

If there's room in the team, Gus will join your merc squad on the very last mission to take on the DFK in their own headquarters. He carries with him high stats all around with the exception of a slightly subpar agility and medical skill, high level gear (to match the gear the squad has undoubtedly accumulated at this point) and joins for free. He performs the entire mission with a huge smile on his face, no matter what's going on. Evidently he really meant it when he said he wanted to get onto the field.

JA2:


"After rather heated negotiations, A.I.M. is pleased to announce that the legendary DFK annihilator, Gus Tarballs, is now a member of our ranks. Gus's induction was delayed slightly when his mobile home slipped from its support blocks while he was in the process cleaning the septic hosing. Fortunately, his crushed right leg has healed rather nicely. Additional info: Our medical staff has recently cleared heavy weapons specialist Tarballs for full active duty." - A.I.M. dossier, Jagged Alliance 2

JA2WF:

Health problems have caused Gus to retire from active mercenary service. Old leg injuries have finally caught up to him. We are nevertheless proud that we have this mature and experienced mercenary on our board of directors where he can continue to advise us on strategic matters." - Jagged Alliance 2: Wildfire Alumni gallery

Additional Info:

Appearing to have a outgoing personality, Gus actually prefers the life of a loner and does better if no one is around him watching his every move. As he would say: "Leave me the hell alone, woody"
Refers to the player as "Woody", a likely reference to one of Sir-Tech's founders, Robert Woodhead.]],
  StartingLevel = 8,
  MaxHitPoints = 75,
  Likes = {"Len", "Scully"},
  StartingPerks = {
    "HeavyWeaponsTraining",
    "Loner",
    "OldDog",
    "WeGotThis",
    "CancelShotPerk",
    "LeadFromTheFront",
    "TrickShot",
    "TakeAim",
    "BeefedUp",
    "Flanker",
    "Hotblood"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Gus"})
  },
  Equipment = {"Gus"},
  Tier = "Legendary",
  Specialization = "Leader",
  gender = "Male",
  blocked_spots = set("Weaponls", "Weaponrs")
}
