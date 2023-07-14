PlaceObj("XTemplate", {
  Comment = [[
Need to add:
- Option for Landsbach when Outro_SuperSoldiersDone.
- Evidence option when Corazon is killed.]],
  group = "Comic",
  id = "Outro",
  PlaceObj("XTemplateTemplate", {"__template", "Comic"}, {
    PlaceObj("XTemplateThread", {
      "CloseOnFinish",
      true
    }, {
      PlaceObj("XTemplateSlide", {
        "comment",
        "INITIAL SCENE",
        "transition",
        "Fade-to-black",
        "transition_time",
        1000
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Image",
          "UI/Comics/Outro/Scene_00"
        })
      }),
      PlaceObj("XTemplateVoice", {
        "TimeBefore",
        800,
        "TimeAfter",
        1000,
        "Actor",
        "narrator",
        "Text",
        T(205461986270, [[
<em>TWO MONTHS LATER</em>
Hello!
Sorry for the lapse in communication, but I've been busy putting out fires. ]])
      }),
      PlaceObj("XTemplateVoice", {
        "TimeAfter",
        300,
        "Actor",
        "narrator",
        "Text",
        T(841289598468, "Your actions helped shape the changes that are happening in my country and you certainly deserve a full report.")
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "SCENE 1A - PEACE - President saved, Faucheux killed",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set("Outro_PeaceRestored")
          })
        }
      }, {
        PlaceObj("XTemplateSlide", {
          "transition",
          "Fade-to-black",
          "transition_time",
          1000
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Image",
            "UI/Comics/Outro/Art_01"
          })
        }),
        PlaceObj("XTemplateVoice", {
          "TimeBefore",
          300,
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(642481438001, "Thanks to you, <em>Father</em> came back to the capital just in time to prevent the military coup.")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          300,
          "Actor",
          "narrator",
          "Text",
          T(914611054891, "Without <em>Colonel Faucheux</em>, the battalion commanders who intended to join him instead attempted to flee the country. My father made certain they did not.")
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre free, major killed",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set("Outro_PierreLiberated")
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorDead")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_02"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(272945905653, "<em>Pierre</em> helped restore order to the <em>Adjani</em> region. ")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(451552008672, "My father enlisted him as a special military advisor and he worked day and night to disband, and in some cases destroy, the last remnants of the <em>Legion</em>. ")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(610935670008, "He has proven himself to be a noble and compassionate person. I think he always was, he just fell in with the wrong crowd. I believe I - I mean, we - helped him to change into a better man. ")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(324549978266, "There are many reasons I am glad that the <em>Major</em> is dead, but perhaps chief among them is that I wouldn't want him having any further influence on my Pierre - I mean, my people.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre free, major recruited",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set("Outro_PierreLiberated")
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorRecruited")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_02"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(272945905653, "<em>Pierre</em> helped restore order to the <em>Adjani</em> region. ")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(775658476918, "My father enlisted him as a special military advisor and he worked day and night to disband, and in some cases destroy, the last remnants of the <em>Legion</em>.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(610935670008, "He has proven himself to be a noble and compassionate person. I think he always was, he just fell in with the wrong crowd. I believe I - I mean, we - helped him to change into a better man. ")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(901311133164, "As for the <em>Major</em>, he will never again be allowed within the borders of Grand Chien. I don't want him having any further influence on my Pierre - I mean, my people.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre free, major jailed",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set("Outro_PierreLiberated")
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorJail")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_02"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(272945905653, "<em>Pierre</em> helped restore order to the <em>Adjani</em> region. ")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(775658476918, "My father enlisted him as a special military advisor and he worked day and night to disband, and in some cases destroy, the last remnants of the <em>Legion</em>.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(489219634668, "He has proven himself to be a noble and compassionate person. I think he always was, he just fell in with the wrong crowd. I believe I - I mean, we - helped him to change into a better man.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(620533909252, "I worry that Pierre spends too much time playing chess with the <em>Major</em> when he visits him in prison, but that man no longer seems to have the same hold on him he once did. I guess it is possible he has changed as well.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre not free, major jailed",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set({Outro_PierreLiberated = false})
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorJail")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_03"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(574001318938, "Although it was difficult, we finally restored order to the <em>Adjani</em> region.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(323685911083, "My father proclaimed the <em>Legion</em> a terrorist organization and offered rewards for the death or capture of its commanders.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(811739920920, "This resulted in many Legion commanders being turned in by their own troops, especially after they learned the <em>Major</em> had committed suicide in prison. The Legion officers now await their trials.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre not free, major killed",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set({Outro_PierreLiberated = false})
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorDead")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_03"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(972696203740, "We are still having trouble restoring order to the <em>Adjani</em> region.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(200402227711, "When you killed the <em>Major</em>, his <em>Legion</em> turned him into a symbol of resistance - wearing T-Shirts and tattoos of his face, burning villages in his memory.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(664870566227, "The army is making steady progress towards destroying <em>Legion</em> units, but it will be some time until the <em>Major's</em> evil influence has been completely eradicated.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre not free, Major recruited (NEW combo of lines)",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set({Outro_PierreLiberated = false})
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorRecruited")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_07"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(972696203740, "We are still having trouble restoring order to the <em>Adjani</em> region.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(347103403548, "After completing his service to you, the <em>Major</em> slipped out of the country unnoticed. His <em>Legion</em>, however, remained. They scattered into small bandit groups and resumed terrorizing the region.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(664870566227, "The army is making steady progress towards destroying <em>Legion</em> units, but it will be some time until the <em>Major's</em> evil influence has been completely eradicated.")
          })
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "SCENE 1B - CIVIL WAR",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set("Outro_CivilWar")
          })
        }
      }, {
        PlaceObj("XTemplateConditionList", {
          "comment",
          "President saved, Faucheux survived",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "05_TakeDownMajor",
              Vars = set({PresidentDead = false})
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_04"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(989245695100, "Thanks to you, <em>Father</em> came back to the capital just in time to act against the military coup.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(675901943554, "Unfortunately, <em>Colonel Faucheux</em> managed to rally many of the army's battalion commanders to his cause. The country began to descend into civil war.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(674005586341, "Father appointed me Provisional <em>Governor</em> of the Adjani. It became my responsibility to safeguard the lives of the citizens of this region until the crisis passed.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "President dead, Faucheux killed",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "05_TakeDownMajor",
              Vars = set("PresidentDead")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_05"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(668489328676, "Thanks to you, <em>Colonel Faucheux</em> is dead, but the trouble he caused has outlived him.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(615029658310, "Without my father's influence, the government was on the verge of collapse. Only the threat of civil war was holding it together. Thankfully, without <em>Faucheux</em> to lead them, the battalion commanders in open rebellion were not united.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(683733731718, "I was appointed Provisional <em>Governor</em> of the Adjani. It became my responsibility to safeguard the lives of the citizens of this region until the crisis passed.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre free, Major killed/jailed",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set("Outro_PierreLiberated")
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorDead", "MajorJail")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_06"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(917144114244, "That's why I accepted the help of your friend <em>Pierre</em> and his Ernie Rangers.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(688481214432, "This conflict might have lasted for years - but thanks to his bravery, the renegade forces were defeated and we averted a prolonged <em>civil war</em>.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(867658934743, "However, he paid the ultimate price and died a hero to his country. I wish I had known him better.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre free, Major recruited",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set("Outro_PierreLiberated")
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorRecruited")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_06"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(116165149003, "I had hoped that your friend <em>Pierre</em> and his Ernie Rangers would help us, but... he did not answer our requests for aid.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(281436638156, "I heard he was busy hunting down and killing the <em>Major</em>. The man certainly deserved to die, but it was selfish of Pierre to pursue his vendetta while his country needed him.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(227337844076, "As a result, the rebellious army battalions could not be isolated and the country has descended into <em>civil war</em>.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "TimeAdd",
            300,
            "Actor",
            "narrator",
            "Text",
            T(328535990359, "I'm certain we will emerge victorious in the end - but it will take years and many will die before that happens.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre not free, Major jailed",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set({Outro_PierreLiberated = false})
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorJail")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_06"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(734414628635, "I was given permission to make a deal with the devil. I offered the <em>Major</em> the opportunity to earn an official pardon if he agreed to fight on our side. He accepted.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(349383646476, "He fought bravely and lead our troops to many victories before dying from mortal wounds. Thanks to his sacrifice, the renegade forces were scattered and we averted a <em>civil war</em>.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(625828632372, "I awarded him a posthumous pardon and waived all criminal charges against the <em>Legion</em>. I dislike the injustice of that, but at least there is peace.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre not free, Major killed",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set({Outro_PierreLiberated = false})
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorDead")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_07"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(863930040189, "And the situation in the <em>Adjani</em> region is a disaster.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(200402227711, "When you killed the <em>Major</em>, his <em>Legion</em> turned him into a symbol of resistance - wearing T-Shirts and tattoos of his face, burning villages in his memory.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(948414720926, "With the Legion rampaging, the rebellious army battalions could not be isolated and the country has descended into <em>civil war</em>.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(328535990359, "I'm certain we will emerge victorious in the end - but it will take years and many will die before that happens.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre not free, Major recruited",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set({Outro_PierreLiberated = false})
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorRecruited")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_07"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(863930040189, "And the situation in the <em>Adjani</em> region is a disaster.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(347103403548, "After completing his service to you, the <em>Major</em> slipped out of the country unnoticed. His <em>Legion</em>, however, remained. They scattered into small bandit groups and resumed terrorizing the region.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(528412518131, "With so much instability, the rebellious army battalions could not be isolated and the country has descended into <em>civil war</em>.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(328535990359, "I'm certain we will emerge victorious in the end - but it will take years and many will die before that happens.")
          })
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "SCENE 1C - COUP - President dead, Faucheux survived",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set("Outro_Coup")
          })
        }
      }, {
        PlaceObj("XTemplateSlide", {
          "transition",
          "Fade-to-black",
          "transition_time",
          1000
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Image",
            "UI/Comics/Outro/Art_08"
          })
        }),
        PlaceObj("XTemplateVoice", {
          "TimeBefore",
          300,
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(688585342461, "Despite my best efforts to rally support against him, <em>Colonel Faucheux's</em> coup has succeeded.")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(492749711198, "He managed to convince most of the battalion commanders to join him, and with <em>Father</em> dead, no one dared try to stop them. ")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          300,
          "Actor",
          "narrator",
          "Text",
          T(367229965469, "They established a <em>military junta</em>, suspended the Constitution and introduced martial law. ")
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre free, Major killed/jailed",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set("Outro_PierreLiberated")
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorDead", "MajorJail")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_09"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(522208334435, "But sometimes help comes unasked for, and heroism is shown when not expected. Your friend <em>Pierre</em> has proven to be a true hero to his country.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(174634922705, "He was one of the very few who openly opposed the junta. During their very first military parade, he smuggled a gun past the checkpoints and assassinated <em>Colonel Faucheux</em>. ")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(451656696313, "He paid for his defiance with his life, but his sacrifice united those who were once mortal enemies - the <em>Adjani Militia</em> and the remnants of the <em>Legion</em>.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(395033425929, "Even now they fight against the usurpers. I help them in whatever ways I can, but I do not think this <em>civil war</em> will end anytime soon... or well for us.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre free, Major recruited",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set("Outro_PierreLiberated")
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorRecruited")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_10"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(783445919815, "In a remarkable act of bravery, both the <em>Adjani Militia</em> and the remnants of the <em>Legion</em> chose to defy the usurpers.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(113821025677, "I had hoped that your friend <em>Pierre</em> would lead the resistance, but he was preoccupied with his foolish vendetta against the <em>Major</em>. ")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(236623762101, "Fractured and leaderless, the uprising was easily crushed by the junta's forces.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(109097510172, "My father's supporters were arrested and thrown in prison. I barely managed to escape. I fear I will have to live the rest of my life in <em>exile</em>.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre not free, Major jailed",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set({Outro_PierreLiberated = false})
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorJail")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_11"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "Actor",
            "narrator",
            "Text",
            T(306285666006, "Soon after the coup, the junta began arresting and killing all dissidents, starting with the <em>Legion</em>.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(481108233946, "To make an example, <em>Faucheux</em> had the <em>Major</em> publicly executed by a firing squad, and Legion soldiers everywhere ran for their lives.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(109097510172, "My father's supporters were arrested and thrown in prison. I barely managed to escape. I fear I will have to live the rest of my life in <em>exile</em>.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre not free, Major killed",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set({Outro_PierreLiberated = false})
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorDead")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_10"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "Actor",
            "narrator",
            "Text",
            T(783445919815, "In a remarkable act of bravery, both the <em>Adjani Militia</em> and the remnants of the <em>Legion</em> chose to defy the usurpers.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(874501132760, "But with the <em>Major</em> dead and no one else to lead them, the fractured resistance was easily crushed.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(109097510172, "My father's supporters were arrested and thrown in prison. I barely managed to escape. I fear I will have to live the rest of my life in <em>exile</em>.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "SCENE 2 - Pierre not free, Major recruited",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set({Outro_PierreLiberated = false})
            }),
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "05_TakeDownMajor",
              Vars = set("MajorRecruited")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_10"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(783445919815, "In a remarkable act of bravery, both the <em>Adjani Militia</em> and the remnants of the <em>Legion</em> chose to defy the usurpers.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(589646207909, "But since the <em>Major</em> slipped out of the country unnoticed after completing his service to you, there was no one to lead them. The uprising was easily crushed.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(109097510172, "My father's supporters were arrested and thrown in prison. I barely managed to escape. I fear I will have to live the rest of my life in <em>exile</em>.")
          })
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "SCENE 3 - Red Rabies Done",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set("Outro_RedRabiesDone")
          })
        }
      }, {
        PlaceObj("XTemplateConditionList", {
          "comment",
          "Peace",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set("Outro_PeaceRestored")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_12"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(832096991270, "Grand Chien has suffered not just from the fighting but also from the <em>Red Rabies</em> epidemic.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(609000529960, "Thanks to your efforts, it has been contained and the production of a <em>vaccine</em> has begun.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(728615600953, "<em>Dr. Kronenberg</em> was awarded a posthumous Grand Chien Medallion of Merit for her sacrifice. Her peers vow to continue studying ways to combat the disease in her honor.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "War",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "06_Endgame",
              Vars = set("TCE_CivilWar", "TCE_Coup")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_13"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(832096991270, "Grand Chien has suffered not just from the fighting but also from the <em>Red Rabies</em> epidemic.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(374368545160, "Thanks to your efforts, it has been at least partially contained. There is even talk of producing a <em>vaccine</em>, but it is still in development.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(673507415498, "The work of <em>Dr. Kronenberg</em> was left unfinished and more research is needed. In the meantime, the disease continues to spread at an alarming rate.")
          })
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "SCENE 3 - Red Rabies NOT Done",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set({Outro_RedRabiesDone = false})
          })
        }
      }, {
        PlaceObj("XTemplateSlide", {
          "transition",
          "Fade-to-black",
          "transition_time",
          1000
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Image",
            "UI/Comics/Outro/Art_13"
          })
        }),
        PlaceObj("XTemplateVoice", {
          "TimeBefore",
          300,
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(832096991270, "Grand Chien has suffered not just from the fighting but also from the <em>Red Rabies</em> epidemic.")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(681162836767, "This horrible disease has spread all over the country and there are reports of <em>outbreaks</em> all over the world.")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(572420483091, "The WHO has officially labeled it a \"pandemic\" and is issuing confusing and often contradictory safety recommendations every other day. In the meantime, people are dying. ")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          300,
          "Actor",
          "narrator",
          "Text",
          T(130557993842, "Of course, none of this is your fault. I blame myself for focusing entirely on my father and Grand Chien. I did not even notice there was a worldwide threat until it was too late.")
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "SCENE 4 - Diesel production stopped",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set("Outro_DieselStopped")
          })
        }
      }, {
        PlaceObj("XTemplateSlide", {
          "transition",
          "Fade-to-black",
          "transition_time",
          1000
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Image",
            "UI/Comics/Outro/Art_22"
          })
        }),
        PlaceObj("XTemplateVoice", {
          "TimeBefore",
          300,
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(649234424232, "Speaking of health risks, I was alarmed to discover that someone had been experimenting on my people with <em>combat drugs<em>!")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          300,
          "Actor",
          "narrator",
          "Text",
          T(222103454383, "I am glad that you stopped the production of <em>Diesel</em> in Landsbach. The only \"super soldiers\" my country ever needed were your mercs.")
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "SCENE 4 - Diesel and Super Soldiers - Need MID option when only SuperSoldiersDone",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set({Outro_DieselStopped = false, Outro_SuperSoldiersDone = false})
          })
        }
      }, {
        PlaceObj("XTemplateSlide", {
          "transition",
          "Fade-to-black",
          "transition_time",
          1000
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Image",
            "UI/Comics/Outro/Art_21"
          })
        }),
        PlaceObj("XTemplateVoice", {
          "TimeBefore",
          300,
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(649234424232, "Speaking of health risks, I was alarmed to discover that someone had been experimenting on my people with <em>combat drugs<em>!")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(531786448320, "It seems that those reckless people in Landsbach have created some kind of biolaboratory dedicated to making <em>super soldiers</em>.")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          300,
          "Actor",
          "narrator",
          "Text",
          T(193357851118, "Of course, it was not a problem you were ever expected to solve. Still, I wish you were here. I can't think of anyone better to deal with \"super soldiers\" than you.")
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "SCENE 5 - Pantagruel Done",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set("Outro_PantagruelDone")
          })
        }
      }, {
        PlaceObj("XTemplateConditionList", {
          "comment",
          "Peace",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "06_Endgame",
              Vars = set("Outro_PeaceRestored")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_14"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(561007938009, "One bright spot to emerge from the darkness of the Adjani hostilities is the marriage of <em>Maman Lilliane</em> and <em>Mr. Chimurenga</em>! It has made many people very happy.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(361466433631, "The two of them are already organizing the next <em>Pantagruel</em> Carnival celebrations and they plan to turn it into a world-class event!")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(542303571497, "There will be drinks, dance, fireworks, and a honor guard of female <em>Red Maquis</em> to keep the peace. I think you would like their uniforms! They are very... eye-catching.")
          })
        }),
        PlaceObj("XTemplateConditionList", {
          "comment",
          "War",
          "conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              Condition = "or",
              QuestId = "06_Endgame",
              Vars = set("TCE_CivilWar", "TCE_Coup")
            })
          }
        }, {
          PlaceObj("XTemplateSlide", {
            "transition",
            "Fade-to-black",
            "transition_time",
            1000
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Comics/Outro/Art_15"
            })
          }),
          PlaceObj("XTemplateVoice", {
            "TimeBefore",
            300,
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(561007938009, "One bright spot to emerge from the darkness of the Adjani hostilities is the marriage of <em>Maman Lilliane</em> and <em>Mr. Chimurenga</em>! It has made many people very happy.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            1000,
            "Actor",
            "narrator",
            "Text",
            T(473678628064, "The two of them announced Pantagruel to be a free city and the <em>Maquis</em> fiercely defend it from any armed forces who would say otherwise.")
          }),
          PlaceObj("XTemplateVoice", {
            "TimeAfter",
            300,
            "Actor",
            "narrator",
            "Text",
            T(815451142296, "<em>Le Lys Rouge</em> has become a shelter for refugees and wounded.")
          })
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "SCENE 5 - Pantagruel NOT Done",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set({Outro_PantagruelDone = false})
          })
        }
      }, {
        PlaceObj("XTemplateSlide", {
          "transition",
          "Fade-to-black",
          "transition_time",
          1000
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Image",
            "UI/Comics/Outro/Art_23"
          })
        }),
        PlaceObj("XTemplateVoice", {
          "TimeBefore",
          300,
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(804470238518, "One thing is certain - the Adjani valley will never be the same. Much has been lost.")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(335466523050, "One of the most heartbreaking examples of this is <em>Le Lys Rouge</em> in Pantagruel.")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          300,
          "Actor",
          "narrator",
          "Text",
          T(393825271905, "One night, a group of drunken Legion thugs set it on fire and it burned to the ground. I do not think the <em>Carnival</em> celebrations in Pantagruel will ever be the same... if they ever happen again.")
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "SCENE BEFORE LAST - Green Diamond AIM",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set("Outro_GreenDiamondAIM")
          })
        }
      }, {
        PlaceObj("XTemplateSlide", {
          "transition",
          "Fade-to-black",
          "transition_time",
          1000
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Image",
            "UI/Comics/Outro/Art_16"
          })
        }),
        PlaceObj("XTemplateVoice", {
          "TimeBefore",
          300,
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(995551402647, "But enough talking about our troubles. I heard that a very peculiar <em>green diamond</em> called \"Pride of the Adjani\" was auctioned for $55 million! ")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(892803756052, "...And 50% of the sum was anonymously donated to the Fund for the Restoration of Grand Chien!")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(769711569252, "Now I want to thank that \"anonymous\" person... or should I say \"persons\"? I love you all! You have hearts of gold.")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          300,
          "Actor",
          "narrator",
          "Text",
          T(698939552179, "You risked your lives for us, and yet you did something that no other mercenaries would do. You are so much more than mercs!")
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "SCENE BEFORE LAST - Green Diamond MERC",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set("Outro_GreenDiamondMERC")
          })
        }
      }, {
        PlaceObj("XTemplateSlide", {
          "transition",
          "Fade-to-black",
          "transition_time",
          1000
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Image",
            "UI/Comics/Outro/Art_16"
          })
        }),
        PlaceObj("XTemplateVoice", {
          "TimeBefore",
          300,
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(995551402647, "But enough talking about our troubles. I heard that a very peculiar <em>green diamond</em> called \"Pride of the Adjani\" was auctioned for $55 million! ")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(726212928687, "The seller was someone named <em>Biff Apscott</em> and he apparently spent all the money on a new boat, a luxury mansion for his mercenary agency, and a social network called \"MercSpace.\"")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          300,
          "Actor",
          "narrator",
          "Text",
          T(787556958391, "I am livid! Do you know this person?! That diamond is an important part of my people's history. It belongs in a Grand Chien museum!")
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "SCENE BEFORE LAST - Green Diamond Emma",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set("Outro_GreenDiamondEmma")
          })
        }
      }, {
        PlaceObj("XTemplateSlide", {
          "transition",
          "Fade-to-black",
          "transition_time",
          1000
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Image",
            "UI/Comics/Outro/Art_16"
          })
        }),
        PlaceObj("XTemplateVoice", {
          "TimeBefore",
          300,
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(878574781976, "But enough talking about our troubles. Have you heard about a very peculiar <em>green diamond</em> that was recently discovered and shown at the Museum of the Adjani?")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(593503715143, "I want to thank you once again for returning it to us. The \"Pride of the Adjani\" is a symbol of my country and, thanks to you, it will help unite us even in our darkest times. ")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          300,
          "Actor",
          "narrator",
          "Text",
          T(279132519390, "I love you all! You have hearts of gold. ")
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "SCENE BEFORE LAST - Green Diamond FAIL",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set({
              Outro_GreenDiamondAIM = false,
              Outro_GreenDiamondEmma = false,
              Outro_GreenDiamondMERC = false
            })
          })
        }
      }, {
        PlaceObj("XTemplateSlide", {
          "transition",
          "Fade-to-black",
          "transition_time",
          1000
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Image",
            "UI/Comics/Outro/Art_16"
          })
        }),
        PlaceObj("XTemplateVoice", {
          "TimeBefore",
          300,
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(995551402647, "But enough talking about our troubles. I heard that a very peculiar <em>green diamond</em> called \"Pride of the Adjani\" was auctioned for $55 million! ")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          300,
          "Actor",
          "narrator",
          "Text",
          T(814489178702, "I am livid! That diamond is an important part of my people's history. It belongs in a Grand Chien museum!")
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "LAST SCENE - Corazon Trial",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set("Outro_CorazoneGoodEnd")
          })
        }
      }, {
        PlaceObj("XTemplateSlide", {
          "transition",
          "Fade-to-black",
          "transition_time",
          1000
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Image",
            "UI/Comics/Outro/Art_17"
          })
        }),
        PlaceObj("XTemplateVoice", {
          "TimeBefore",
          300,
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(257731151870, "Ah, but my attention is being called elsewhere, my friend. Let me just say one last thing. I learned that <em>Corazon Santiago</em> faced trial and you destroyed her in court!")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(579894714699, "My heart swelled when I saw that she was found guilty of war crimes, and that <em>Adonis</em> now faces law suits and falling stock prices.")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(445612629345, "I can only imagine what a blow to your reputation it would have been for you had you not won the case.")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          300,
          "Actor",
          "narrator",
          "Text",
          T(567703306670, "I'm sure that now you will have many new contracts - which means more opportunities to do good in your own unique way. Best wishes to you. Au revoir.")
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "LAST SCENE - Corazon & AIM Trial",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set("Outro_CorazoneMidEnd")
          })
        }
      }, {
        PlaceObj("XTemplateSlide", {
          "transition",
          "Fade-to-black",
          "transition_time",
          1000
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Image",
            "UI/Comics/Outro/Art_18"
          })
        }),
        PlaceObj("XTemplateVoice", {
          "TimeBefore",
          300,
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(214442236338, "Ah, but my attention is being called elsewhere, my friend. Let me just say one last thing. I learned that <em>Corazon Santiago</em> faced trial and was exposed in court.")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(883435808979, "Simply exposing her for embezzlement and sedition is not good enough! She deserves to rot in prison for her involvement in the war crimes she pinned on you!")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(192284049273, "I can only imagine what a blow to your reputation that is for you.")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          300,
          "Actor",
          "narrator",
          "Text",
          T(934684705211, "I'm sure that the truth will eventually be revealed. I'll do what I can to help. Until then, you have my best wishes. Au revoir.")
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "LAST SCENE - Mercs Wanted",
        "conditions",
        {
          PlaceObj("QuestIsVariableBool", {
            QuestId = "06_Endgame",
            Vars = set({Outro_CorazoneGoodEnd = false, Outro_CorazoneMidEnd = false})
          })
        }
      }, {
        PlaceObj("XTemplateSlide", {
          "transition",
          "Fade-to-black",
          "transition_time",
          1000
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Image",
            "UI/Comics/Outro/Art_19"
          })
        }),
        PlaceObj("XTemplateVoice", {
          "TimeBefore",
          300,
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(685520217635, "Ah, but my attention is being called elsewhere, my friend. Let me just say one last thing. I learned that <em>Corazon Santiago</em> faced trial but there wasn't enough evidence to expose her.")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(248863713382, "She deserves to rot in prison for her involvement in the war crimes she pinned on you!")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          1000,
          "Actor",
          "narrator",
          "Text",
          T(105264108741, "I can only imagine what a blow to your reputation that is for you. I'm sure that the truth will eventually be revealed. ")
        }),
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          300,
          "Actor",
          "narrator",
          "Text",
          T(412536902879, "I'll do what I can to help. Until then, you have my best wishes. Au revoir.")
        })
      })
    })
  })
})
