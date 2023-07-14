UndefineClass("Mouse")
DefineClass.Mouse = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 83,
  Agility = 99,
  Dexterity = 95,
  Strength = 50,
  Wisdom = 75,
  Leadership = 10,
  Marksmanship = 68,
  Mechanical = 4,
  Explosives = 0,
  Medical = 50,
  Portrait = "UI/MercsPortraits/Mouse",
  BigPortrait = "UI/Mercs/Mouse",
  Name = T(522606213949, "Anita \"Mouse\" Backman"),
  Nick = T(558332461192, "Mouse"),
  AllCapsNick = T(252782817625, "MOUSE"),
  Bio = T(491873398820, "While Anita, who recently re-joined the ranks of A.I.M., will not disclose her motivations, there is speculation that her relationship with Dr. Margaret \"Stella\" Trammel has fractured. Still others believe she was sent by that same woman on a very specific (and very secret) mission that required reestablishing old mercenary contacts. Whatever her reasons, Mouse's abilities to move about undetected are uncanny and would make a valuable addition to any team."),
  Nationality = "USA",
  Title = T(660752674735, "Squeaky Little Thing"),
  Email = T(752477644941, "squeaky@aim.com"),
  snype_nick = T(965473237479, "squeaky"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(891526878797, "I can't work with Fox, she's causing all kinds of trouble... It's only a question of time before somebody on the team pays the price for her behavior.")
        }),
        PlaceObj("ChatMessage", {
          "Text",
          T(682431868600, "I don't want to be there when that happens. Sorry.")
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
          T(841418933816, "I can't stand working with that old buffoon, Red. You will not make me. Sorry, I'm out.")
        })
      },
      "Conditions",
      {
        PlaceObj("AND", {
          Conditions = {
            PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Red"}),
            PlaceObj("MercIsLikedDisliked", {
              Object = "Red",
              Relation = "Dislikes",
              TargetUnit = "Mouse"
            })
          }
        })
      },
      "Type",
      "rehire"
    }),
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(619207175584, "I am super pissed Steroid is on the team! No way am I working with that chauvinist pig. I am sick of people like him. Find someone else, I quit.")
        })
      },
      "Conditions",
      {
        PlaceObj("AND", {
          Conditions = {
            PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Steroid"}),
            PlaceObj("MercIsLikedDisliked", {
              Object = "Steroid",
              Relation = "Dislikes",
              TargetUnit = "Mouse"
            })
          }
        })
      },
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
          T(180090348249, "Ugh. You only have boys with you. Boys are icky and they smell like poo. I guess I can live with it, but I expect to be paid extra.")
        })
      },
      "Conditions",
      {
        PlaceObj("CheckExpression", {
          Expression = function(self, obj)
            return table.count(gv_UnitData, "HireStatus", "Hired") > 3 and table.count(gv_UnitData, function(i, ud)
              return ud.HireStatus == "Hired" and ud.gender == "Female"
            end) == 0
          end
        })
      }
    })
  },
  HaggleRehire = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(640263685398, "I hate working with Fox. She is just... ugh. If you expect me to keep working with her, you need to offer me some extra cheese.")
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
          T(708602087780, "I want to say no but at least you have some girls out there. I guess you must not be that bad. ")
        })
      },
      "Conditions",
      {
        PlaceObj("CheckExpression", {
          Expression = function(self, obj)
            return table.count(gv_UnitData, function(ud)
              return gv_UnitData[ud].HireStatus == "Hired" and gv_UnitData[ud].gender == "Female"
            end) >= 3
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
      T(882365282152, "Hey! This is Anita Backman. I'm super busy right now. How about I notify you when I'm ready to talk?")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(194998168832, "Hi, Mouse here! You want me for a mission, right?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(675625901057, "Huh, usually I'm the one to disappear. So what were we talking about?")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(516121446556, "Hey, I know I'm good at making people ignore me, but this is ridiculous.")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(792755268170, "Great! Now I have to tell Stella. She will be a nightmare - she still can't get used to retirement.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(752819054890, "Hey. How about you extend my contract? ")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(814767561017, "Great! I will get out of your hair now. ")
    })
  },
  StartingSalary = 680,
  SalaryLv1 = 650,
  SalaryMaxLv = 4300,
  LegacyNotes = [[
JA1: DG

"Stella's friend, Anita, was a street performer throughout Europe and North Africa. Her mime act was panned in Paris, booed in Greece and stoned in Tripoli. But after meeting Miss Trammel, Mouse joined A.I.M., and brought her uncanny silence with her." - A.I.M. Dossier, Jagged Alliance: Deadly Games

JA2: Alumni

"Anita's stint with the organization was short and rather quiet.  Known for her uncanny ability to move about unnoticed, and not much else, Mouse handed in her resignation at the same time as Dr. Margaret "Stella" Trammel.  It is our understnading that they moved to the Virgin Islands together where Backman serves as nurse/receptionist at Trammel's newly opened medical clinic." -Jagged Alliance 2, Alumni Gallery]],
  MaxHitPoints = 85,
  Dislikes = {"Fox"},
  LearnToDislike = {"Steroid", "Red"},
  StartingPerks = {"Stealthy", "LightStep"},
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Mouse"})
  },
  Equipment = {"Mouse"},
  Specialization = "AllRounder",
  pollyvoice = "Joanna",
  gender = "Female",
  blocked_spots = set("Weaponls", "Weaponrs")
}
