UndefineClass("Buns")
DefineClass.Buns = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 79,
  Agility = 79,
  Dexterity = 87,
  Strength = 56,
  Wisdom = 93,
  Leadership = 24,
  Marksmanship = 86,
  Mechanical = 8,
  Explosives = 4,
  Medical = 49,
  Portrait = "UI/MercsPortraits/Buns",
  BigPortrait = "UI/Mercs/Buns",
  Name = T(956763701762, "Monica \"Buns\" Sondergaard"),
  Nick = T(730486601047, "Buns"),
  AllCapsNick = T(355208859292, "BUNS"),
  Bio = T(777309152047, "A woman whose skills extend far beyond just firearms and medicine, Monica's resum\195\169 reads like she's applying for a lifetime achievement award. She recently produced a series of instructional videos called \"Be Better\" where she teaches the viewer the best ways to home school, perform CPR, shoot automatic weapons, maintain cardiovascular health and lift yourself out of depression through rigorous self-improvement. \n\nAlthough many wonder what she could possibly want from the mercenary life, most fellow A.I.M. members appreciate her expertise and thorough - if priggish - tutoring style."),
  Nationality = "Denmark",
  Title = T(852578438925, "Buns Will Teach You"),
  Email = T(199610516408, "MonicaSondergaard@aim.com"),
  snype_nick = T(154054560014, "MonicaSondergaard"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(226180244539, "You've got Fox on your team. Obviously, you're more interested in the sizzle than the steak. Call me when you're looking for something more than a pretty face.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Fox"})
      }
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(236123461893, "You have a man on your team called Reaper. He's a seriously disturbed individual. Some other time, perhaps.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Reaper"})
      }
    })
  },
  Haggles = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(993128152189, "I have not worked with you before. It is prudent to require some additional financial guarantees when that is the case.")
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
          T(574540805848, "You hired that creep Reaper. There is something really, really wrong with him. If you want to keep me on, I will require extra compensation for the risks involved when working with such an individual.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Reaper"})
      }
    }),
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(998763690178, "I don't know what possessed you to hire that useless swimsuit model, Fox. Her head is as empty as her breasts. I'm sure they're fake. Pretty sure. Anyway, I'll need more money if I am to tolerate her presence.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Fox"})
      }
    })
  },
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(691020141104, "This is an offer I would normally refuse, but having Sidney on the team makes me feel like perhaps you know what you are doing. I'm in.")
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
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(545257109553, "This is Monica Sondergaard. You have naturally been drawn to my superior skills and neat and efficient manner. I am currently unavailable. Please contact me at another time. ")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(852499190735, "Hello. This is Monica Sondergaard. It is a pleasure to meet you. I assume this is about a job and you were drawn to my superior skills and overall neatness.")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(698087255368, "It is rude to end conversations abruptly but I will forgive you. Let us proceed.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(180203089731, "I do not tolerate time-wasting but I will make an exception. Benevolence is one of my many virtues. Now, let us continue.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(906674942216, "Very well. I look forward to working with you.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(918365695405, "Hello. My contract is expiring. The team will suffer without my superior skill set so I am willing to continue our arrangement.")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(558845485811, "Good. I am pleased we could come to an agreement to continue our contract.")
    })
  },
  MedicalDeposit = "large",
  StartingSalary = 655,
  SalaryIncrease = 260,
  SalaryLv1 = 400,
  SalaryMaxLv = 4300,
  LegacyNotes = [[
"The prim and proper Monica Sondergaard may seem to be an unlikely candidate for the rough and tumble mercenary life, but she more than meets the minimum requirements. Before settling on A.I.M., Buns explored a number of careers: kindergarten teacher, geriatric nurse, Danish sharpshooter at the Atlanta Olympic games, and professional soldier."

Additional info:

A prim and proper prude, her uptightedness goes hand-in-hand with her professionalism and skill.
Believes herself better than anyone else.
Has a sense of superiority. She's a merc because she wants to, not because she has to.
Puts her feelings before logic.
To a Danish person her dialect sounds German or Russian. (To a person with knowledge of the russian language and accent she definitely doesn't sound any russian at all. Ivan Dolvich has classic russian accent)]],
  StartingLevel = 2,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "Firearm")
    self:TryEquip(items, "Handheld B", "Firearm")
  end,
  MaxHitPoints = 79,
  Likes = {"Sidney"},
  Dislikes = {"Fox", "Reaper"},
  StartingPerks = {
    "BunsPerk",
    "Negotiator",
    "Teacher",
    "CancelShotPerk"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Buns"})
  },
  Equipment = {"Buns"},
  Tier = "Veteran",
  Specialization = "Marksmen",
  pollyvoice = "Amy",
  gender = "Female",
  VoiceResponseId = "Buns"
}
