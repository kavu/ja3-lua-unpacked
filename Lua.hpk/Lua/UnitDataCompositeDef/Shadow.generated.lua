UndefineClass("Shadow")
DefineClass.Shadow = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 95,
  Agility = 96,
  Dexterity = 85,
  Strength = 89,
  Wisdom = 77,
  Leadership = 35,
  Marksmanship = 90,
  Mechanical = 12,
  Explosives = 22,
  Medical = 30,
  Portrait = "UI/MercsPortraits/Shadow",
  BigPortrait = "UI/Mercs/Shadow",
  Name = T(760643490639, "Kyle \"Shadow\" Simmons"),
  Nick = T(716325832691, "Shadow"),
  AllCapsNick = T(409225247825, "SHADOW"),
  Bio = T(501671952366, "Practically the American mirror image of Scope, A.I.M.'s top sharpshooter, Shadow, excels at moving swiftly across the battlefield to set up for a perfect kill shot. But where Scope is friendly and trained in urban combat, Shadow is a quiet loner who prefers to use the great outdoors as his battlefield. His skill in using stealth and camouflage to hide from his target until the time is right for a lethal strike makes him worth every penny. Kyle has recently finished a three-week training program called 'Cleft and Chasm: The Art of Declivity Impersonation' and is ready for assignment."),
  Nationality = "USA",
  Title = T(449003441115, "Can't Kill What You Can't See"),
  Email = T(642342715921, "shadow@aim.com"),
  snype_nick = T(790007421865, "shadow"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(773704481235, "I'm not going to be available. Let's just say I'm visiting a sick friend.")
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
          T(721179969282, "I don't work with rookies. Someone's bound to get hurt and I'll have to work extra hard to make sure it's not me. I am not a damn babysitter, so hire someone else.")
        })
      },
      "Conditions",
      {
        PlaceObj("CheckExpression", {
          Expression = function(self, obj)
            return table.count(gv_UnitData, function(ud)
              return gv_UnitData[ud].HireStatus == "Hired" and gv_UnitData[ud]:GetLevel() <= 3
            end) > 0
          end
        })
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(780554763122, "If you're getting this message, I may or may not be available. Let me know where you can be reached if you want me to return the call.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(921194090361, "Yes?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(565187982425, "I hate to waste time on calls. Let's get to a contract agreement or agree that you'll stop bothering me.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(280147332060, "Let's move this along. I got an Urban Camouflage seminar to sneak up on.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(951928325936, "Yeah, okay, we'll see how well we work together. You don't like my style or I don't like yours, we shake hands when the contract's over and call it a wash.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(604777995574, "Contract's almost up, in case it slipped your mind. I could make myself available if you want to give me an extension.")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(307984690371, "All right. I'm staying.")
    })
  },
  DurationDiscount = "none",
  StartingSalary = 2800,
  SalaryIncrease = 220,
  SalaryMaxLv = 4500,
  LegacyNotes = [[
This ex-Ranger and sniper has turned stalking into an art form. The Shadow could be lurking about right next to you and chances are you'd never know it. That snow drift, sand dune, or piece of shrubbery could be him. Kyle Simmons has made it his business to blend into any environment for any length of time. The Shadow brings his own camouflage supplies and he wishes to make it known up-front that he doesn't share."

Additional info:

Quiet, loner, low-key professional.
Comments are usually made to himself rather than as conversation.
A matter-of-fact type of guy, who doesn't draw attention to himself.
Voice: a confident sniper's whisper.]],
  StartingLevel = 5,
  MaxHitPoints = 95,
  StartingPerks = {
    "Stealthy",
    "Loner",
    "FleetingShadow",
    "Untraceable",
    "Infiltrator",
    "SwiftStrike",
    "LightningReaction"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Shadow",
      "Weight",
      50,
      "GameStates",
      set({Savanna = false, Wastelands = false})
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Shadow_Savanna",
      "Weight",
      50,
      "GameStates",
      set("Savanna")
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Shadow_Savanna",
      "Weight",
      50,
      "GameStates",
      set("Wastelands")
    })
  },
  Equipment = {"Shadow"},
  Tier = "Legendary",
  Specialization = "Marksmen",
  gender = "Male"
}
