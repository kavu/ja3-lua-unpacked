UndefineClass("DrQ")
DefineClass.DrQ = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 88,
  Agility = 94,
  Dexterity = 81,
  Strength = 73,
  Wisdom = 87,
  Leadership = 26,
  Mechanical = 19,
  Explosives = 20,
  Medical = 88,
  Portrait = "UI/MercsPortraits/DrQ",
  BigPortrait = "UI/Mercs/DrQ",
  Name = T(231173544601, "Dr. Q. Huaong"),
  Nick = T(293945362464, "Dr. Q"),
  AllCapsNick = T(562036496158, "DR. Q"),
  Bio = T(527433658116, "While attending a seminar on acupuncture where he served as guest lecturer, Dr. Q had the opportunity to use his skills in night operations and martial arts to infiltrate the compound of a nearby drug lord to liberate a hoard of medical supplies and deliver them to a local hospital. It is rumored he waived his usual fee for such services, but Huaong denies it."),
  Nationality = "China",
  Title = T(727721975643, "Expert in Aggressive Acupuncture"),
  Email = T(970559294874, "sage_q@aim.com"),
  snype_nick = T(893736356942, "sage_q"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(614053168152, "I must sorrowfully decline. I am participating in the review of a new treatment. Perhaps our paths are still destined to meet somewhere in the future.")
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
          T(767241591939, "I cannot accept. I believe you are reckless with the lives of your soldiers.")
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
          T(656350600015, "I don't wish to embarrass you, but your bank balance tells me there are financial considerations you have not fully taken into account. I cannot accept.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionMoney", {})
      }
    })
  },
  Mitigations = {
    PlaceObj("MercChatMitigation", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(144557312468, "I question some of your decisions. Nevertheless, I will defer to the judgement of Victoria Waters, whom I have learned to trust. I agree to the arrangement.")
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
          T(275961281267, "It is my wish to inform you that hiring Victoria Waters, whom people call Vicki, will be most beneficial to our mutual endeavors.")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(882968834068, "Now that we have reached this agreement, I must prepare to depart. Thank you.")
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
      T(959106516354, "This is Dr. Q. Huaong. I am otherwise employed right now. I will notify you of my return or you may try me again later.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(342206637305, "This is Dr. Q. Huaong. Speak.")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(958782603918, "Let us empty our minds from the clutter and attempt to reach a mutually beneficial arrangement again.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(476696721288, "I seem to be afflicted by the impatience of technology. I find myself awaiting more words from you.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(835003965086, "The arrangement is mutually beneficial. I agree to the terms.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(591231386836, "The end of our mutual agreement draws close. Do you wish to discuss an extension?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(614588738362, "The renewal is agreeable to me.")
    })
  },
  MedicalDeposit = "none",
  StartingSalary = 1350,
  SalaryIncrease = 200,
  SalaryLv1 = 380,
  SalaryMaxLv = 4000,
  LegacyNotes = [[
"Doctor Huaong draws much of his medical knowledge from the branches of the ancient healing traditions. His marksmanship may be a little poor, but Dr. Q's expertise in so many other disciplines--night operations, guerrilla warfare tactics, and martial arts-more than make up for it, and he could easily double his fees. "

Additional info:
His salary is currently undergoing renegotiation.]],
  StartingLevel = 3,
  MaxHitPoints = 88,
  Likes = {"Vicki"},
  StartingPerks = {
    "MartialArts",
    "NightOps",
    "ExplodingPalm",
    "SwiftStrike",
    "Savior"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "DrQ"})
  },
  Equipment = {"DrQ"},
  Tier = "Elite",
  Specialization = "Doctor",
  gender = "Male"
}
