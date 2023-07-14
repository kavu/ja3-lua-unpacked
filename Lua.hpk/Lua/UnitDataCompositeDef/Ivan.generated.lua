UndefineClass("Ivan")
DefineClass.Ivan = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 94,
  Agility = 91,
  Dexterity = 95,
  Strength = 87,
  Wisdom = 82,
  Leadership = 35,
  Marksmanship = 92,
  Mechanical = 14,
  Explosives = 55,
  Medical = 15,
  Portrait = "UI/MercsPortraits/IvanPortrait",
  BigPortrait = "UI/Mercs/Ivan",
  Name = T(748830427164, "Ivan Dolvich"),
  Nick = T(493354712045, "Ivan"),
  AllCapsNick = T(857448797342, "IVAN"),
  Bio = T(631392006133, "Once a Major in the Red Army, Ivan took his combat skills to the free market after the collapse of the Soviet Union. Although he still struggles to put anything more than the simplest of phrases into English, his enormous martial talents have only grown during his membership with A.I.M. His feats are so legendary, Hollywood tried to make a movie about him, but since he insisted on starring in it and only using live ammunition the project was canceled."),
  Nationality = "Russia",
  Title = T(659068379440, "The Russian Juggernaut"),
  Email = T(435235065061, "ivan@aim.com"),
  snype_nick = T(306981357442, "\208\184\208\178\208\176\208\189"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(801318908726, "\208\152\208\179\208\190\209\128\209\140 \208\191\208\190\208\179\208\184\208\177, \208\191\208\190\209\130\208\190\208\188\209\131 \209\135\209\130\208\190 \209\129\208\178\209\143\208\183\208\176\208\187\209\129\209\143 \209\129 \208\186\209\128\208\181\209\130\208\184\208\189\208\176\208\188\208\184 \208\178\209\128\208\190\208\180\208\181 \209\130\208\181\208\177\209\143. I will not accept. You are bad commander and let Igor die.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Dead", TargetUnit = "Igor"})
      }
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(385900044934, "Nyet! Problems, money. \208\175 \209\131\209\129\209\130\208\176\208\187 \208\190\209\130 \208\180\209\131\209\128\208\176\208\186\208\190\208\178 \208\177\208\181\208\183 \208\180\208\181\208\189\208\181\208\179, \208\183\208\176 \208\186\208\190\209\130\208\190\209\128\209\139\208\188\208\184 \208\188\208\189\208\181 \208\191\208\190\209\130\208\190\208\188 \208\191\208\190\208\180\209\130\208\184\209\128\208\176\209\130\209\140.")
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
          T(405562095128, "This is stupid mission but I will accept. Igor is family and I keep watch on him. \208\161\208\186\208\190\208\187\209\140\208\186\208\190 \209\128\208\176\208\183 \208\188\208\189\208\181 \208\184\208\183-\208\183\208\176 \208\152\208\179\208\190\209\128\209\143 \208\181\209\137\208\181 \208\191\209\128\208\184\208\180\208\181\209\130\209\129\209\143 \209\129 \209\130\208\176\208\186\208\184\208\188\208\184 \208\184\208\180\208\184\208\190\209\130\208\176\208\188\208\184 \209\128\208\176\208\177\208\190\209\130\208\176\209\130\209\140...")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Igor"})
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
          T(166369730019, "You should hire nephew. \208\158\208\189, \208\186\208\190\208\189\208\181\209\135\208\189\208\190, \208\179\208\190\208\178\208\189\208\176 \208\177\208\181\209\129\208\191\208\190\208\187\208\181\208\183\208\189\208\190\208\179\208\190 \208\186\209\131\209\129\208\190\208\186, \208\189\208\190 \209\130\208\176\208\186 \208\190\208\189 \209\133\208\190\209\130\209\140 \208\186\208\176\208\186\208\190\208\181-\209\130\208\190 \208\178\209\128\208\181\208\188\209\143 \208\191\208\184\209\130\209\140 \208\189\208\181 \208\177\209\131\208\180\208\181\209\130.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {
          Negate = true,
          Status = "Hired",
          TargetUnit = "Igor"
        })
      }
    }),
    PlaceObj("MercChatBranch", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(152187545209, "\208\175 \209\129\208\187\209\139\209\136\208\176\208\187, \208\147\209\128\209\131\208\189\209\130\208\184 \208\184\209\137\208\181\209\130 \209\128\208\176\208\177\208\190\209\130\209\131. \208\147\209\128\209\131\208\189\209\130\208\184 - \209\133\208\190\209\128\208\190\209\136\208\184\208\185 \209\129\208\190\208\187\208\180\208\176\209\130. \208\157\208\176\208\185\208\188\208\184 \208\181\208\179\208\190.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {TargetUnit = "Grunty"})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(638867606061, "This is Ivan Dolvich. I am on mission. I will contact later. \208\149\209\129\208\187\208\184 \209\130\209\139 \208\180\209\131\209\128\208\176\208\186, \208\177\208\190\208\187\209\140\209\136\208\181 \208\189\208\181 \208\183\208\178\208\190\208\189\208\184.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(618731597504, "This is Ivan Dolvich. You want to go on mission? \208\158\209\135\208\181\209\128\208\181\208\180\208\189\208\190\208\185 \208\180\208\181\208\177\208\184\208\187 \209\133\208\190\209\135\208\181\209\130 \208\188\208\181\208\189\209\143 \208\189\208\176\208\189\209\143\209\130\209\140. \208\157\208\176\208\180\208\181\209\142\209\129\209\140, \209\133\208\190\209\130\209\143 \208\177\209\139 \209\131 \209\141\209\130\208\190\208\179\208\190 \208\180\208\181\208\189\209\140\208\179\208\184 \208\177\209\131\208\180\209\131\209\130.")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(163444722395, "Where did you go? \208\152\208\180\208\184\208\190\209\130\209\139, \209\130\209\128\208\176\209\130\209\143\209\130 \208\188\208\190\208\181 \208\178\209\128\208\181\208\188\209\143...")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(191528611145, "\208\162\209\139 \208\183\208\180\208\181\209\129\209\140, \208\184\208\180\208\184\208\190\209\130\208\184\208\189\208\176? Ivan is busy. No time for wasting.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(370387628463, "Good. We have agreement. I will go to this Grand Chien place.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(429789494124, "Ivan contract expires soon. Let us renegotiate. \208\162\209\139 \209\135\209\130\208\190, \209\129\208\190\208\178\209\129\208\181\208\188 \208\180\209\131\209\128\208\176\208\186 - \208\190\209\129\209\130\208\176\209\130\209\140\209\129\209\143 \208\177\208\181\208\183 \208\152\208\178\208\176\208\189\208\176?")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(231732374331, "Good. \208\173\209\130\208\190\209\130, \208\191\208\190\209\133\208\190\208\182\208\181, \208\189\208\181 \208\189\208\176\209\129\209\130\208\190\208\187\209\140\208\186\208\190 \208\180\209\131\209\128\208\176\208\186, \208\186\208\176\208\186 \208\178\209\129\208\181 \208\190\209\129\209\130\208\176\208\187\209\140\208\189\209\139\208\181, \209\128\208\176\208\183 \209\133\208\190\209\135\208\181\209\130 \209\129\208\190 \208\188\208\189\208\190\208\185 \209\128\208\176\208\177\208\190\209\130\208\176\209\130\209\140.")
    })
  },
  StartingSalary = 2650,
  SalaryIncrease = 200,
  SalaryLv1 = 1400,
  SalaryMaxLv = 6200,
  LegacyNotes = [[
JA1

"A new member and a onetime decorated Major in the Red Army, Ivan Dolvich has, like his country, switched from killing for Lenin to dying for Lincolns. However, unlike his homeland, Ivan actually appears to be good at it." 

JA2

"Ivan, a former highly decorated Red Army Major, joined the organization over three years ago on a freelance assignment. Despite serious difficulties communicating in English, he took the mercenary world by storm, breaking all kill-rate records and tallying up the kind of stats that perhaps only he himself is capable of breaking. Ivan himself says it best, 'gun, all gun, like finger on hand.' In order to improve his relationship with commanders, Ivan has enrolled in an "English as a second language" course."

Skills - Auto Weapons; Heavy Weapons]],
  StartingLevel = 4,
  MaxHitPoints = 94,
  Likes = {"Igor", "Grunty"},
  StartingPerks = {
    "YouSeeIgor",
    "AutoWeapons",
    "Flanker",
    "BeefedUp",
    "TakeAim"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Ivan"})
  },
  Equipment = {"Ivan"},
  Tier = "Elite",
  Specialization = "Marksmen",
  pollyvoice = "Russell",
  gender = "Male",
  VoiceResponseId = "Ivan"
}
