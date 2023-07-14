UndefineClass("Ice")
DefineClass.Ice = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 90,
  Agility = 88,
  Dexterity = 87,
  Strength = 84,
  Wisdom = 78,
  Leadership = 25,
  Marksmanship = 87,
  Mechanical = 42,
  Explosives = 3,
  Medical = 7,
  Portrait = "UI/MercsPortraits/Ice",
  BigPortrait = "UI/Mercs/Ice",
  Name = T(487023376427, "Ice Williams"),
  Nick = T(176437286252, "Ice"),
  AllCapsNick = T(117433013766, "ICE"),
  Bio = T(207628950939, "One of A.I.M.'s most popular mercs among both new and frequent clients, Ice's smooth and friendly demeanor makes him highly sought after. Although an expert marksman with a sniper rifle, nothing gives Ice greater joy than going full auto. He can often be found teaching other mercs how to control muzzle climb during sustained bursts."),
  Nationality = "USA",
  Title = T(634721638536, "Ice is in da House"),
  Email = T(234986731479, "ice_cold@aim.com"),
  snype_nick = T(680935424578, "ice_cold"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(980198563693, "Looks to me like you ain't got the cheddar. No cheddar, no bling. No bling, no Iceman, know what I'm sayin?")
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
          T(947420046783, "Oh, damn dude. Totally forgot. I promised my homie I'd help him move into his new crib. My bad. Peace.")
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
          T(449305513325, "Ain't worth my time to do no short stint. I need a longer term gig.")
        })
      },
      "Type",
      "duration"
    })
  },
  Haggles = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(253254561122, "I ain't never worked with you. You might be cool... might not be. Throw in a little extra and we'll see.")
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
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(451725402409, "Yo, I'm always down to work with Magic. I'm in.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Magic"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(220360813308, "Grizzly is quality. If he's on your team, then I guess you're all right. Count me in.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Grizzly"})
      },
      "chanceToRoll",
      100
    }),
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(196058391078, "Daaaamn... You got Blood working for you? That dude's the real deal. Aight. Sign me up.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Blood"})
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
          T(355937024201, "It's a deal. And yo, check it out. Magic's my man. You should hire him too.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Magic"})
      }
    }),
    PlaceObj("MercChatBranch", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(446131633228, "It's a deal. And if you really mean business, you should hire Grizzly. He's pretty fly.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Grizzly"})
      }
    }),
    PlaceObj("MercChatBranch", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(354674179288, "It's a deal. I hear Blood is lookin for work. You should hire him. That dude's got talent.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Blood"})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(439765835734, "This is Ice Williams. I ain't available right now, but if you got a job you need me to do, then leave a note. I'll holla back at ya.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(796351074859, "Ice here. S'up?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(394207735795, "Hit me up with an offer. Let's do this.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(879227309291, "You playin some kinda game? Am I supposed to guess what's on your mind?")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(306254363554, "Aight, let's give it a spin.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(722650285343, "Contract's almost done. We gonna re-up?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(425548162876, "Cool, cool. Let's get back to business.")
    })
  },
  DurationDiscount = "long only",
  StartingSalary = 900,
  SalaryIncrease = 260,
  SalaryLv1 = 520,
  SalaryMaxLv = 4500,
  LegacyNotes = [[
JA1:

A.I.M. Dossier - Jagged Alliance

"A longtime member, Ice Williams has been primarily used as a sniper since joining the organization. Undaunted by the prospect of working for those of unknown reputation, he instead prides himself in helping those new to the mercenary game establish themselves."
A.I.M. Dossier - Deadly Games

"A longtime member, Ice Williams has been primarily used as a sniper since joining the organization almost nine years ago. "Casual" is probably the word that best describes this nonchalant soldier for hire. "Lethal" would be another."

JA2:

A.I.M. Dossier

"The Iceman is back. After a short yet disastrous stint with one of our competitors--and we use that term loosely-Ice gained insight and wisdom on the merits of dealing with a professional organization. Williams owes a debt of gratitude to Magic for getting him reinstated."
"Additional Info: His weapon of choice is the automatic."
Additional info:

Cool, laid-back, patient and friendly.
Never gets overly excited. He's always got it covered.
Lives life for the moment, by the moment.
Conversation has a street corner, rather than combat zone, feel to it.
Ice's patience and friendly demeanor make him an ideal instructor.
It can be inferred from his JA2 bio (worked for a competitor) and his JA1 bio (loves helping the new guy) that he spent a short (very short) time working for M.E.R.C.]],
  StartingLevel = 3,
  MaxHitPoints = 90,
  Likes = {
    "Magic",
    "Grizzly",
    "Blood"
  },
  LearnToLike = {"Livewire"},
  StartingPerks = {
    "AutoWeapons",
    "IcePerk",
    "Flanker",
    "LightningReaction"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Ice"})
  },
  Equipment = {"Ice"},
  Tier = "Veteran",
  Specialization = "Marksmen",
  gender = "Male"
}
