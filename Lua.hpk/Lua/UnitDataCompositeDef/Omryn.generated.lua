UndefineClass("Omryn")
DefineClass.Omryn = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 67,
  Agility = 75,
  Dexterity = 66,
  Strength = 85,
  Wisdom = 77,
  Leadership = 15,
  Marksmanship = 80,
  Mechanical = 43,
  Explosives = 7,
  Medical = 13,
  Portrait = "UI/MercsPortraits/Omryn",
  BigPortrait = "UI/Mercs/Omryn",
  Name = T(991660835571, "Yuri Omryn"),
  Nick = T(703536100724, "Omryn"),
  AllCapsNick = T(586907860855, "OMRYN"),
  Bio = T(503386258599, "Born and raised among the Chukchi peoples of far eastern Russia, Omryn began mercenary life helping M.E.R.C. track smugglers through the wilds of Siberia. It gave him a taste of adventure, so he left Russia and joined the French Foreign Legion, eventually claiming France as his home. His excellent marksmanship, uncanny perception, stolid manner, and mastery of English, French, and Russian languages earned him respect as well as commendations. Never an ambitious or energetic man, Omryn grew tired of full-time service and took the first opportunity to become an A.I.M. mercenary, working where and when it suited him."),
  Nationality = "Russia",
  Title = T(136809018730, "The Very Hungry Hunter"),
  Email = T(568909169483, "yura@aim.com"),
  snype_nick = T(796275464087, "yura"),
  Haggles = {
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(455048670549, "I sense an evil omen, Glavny. This means work will be hard. I will need more rations to be able to do difficult work.")
        })
      },
      "Conditions",
      {},
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
          T(885814480955, "I like work for you, Glavny, but food is definitely not enough. Give me more money for rations so I do not starve and we will spit on it.")
        })
      },
      "Conditions",
      {},
      "chanceToRoll",
      10
    }),
    PlaceObj("MercChatHaggle", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(956878799729, "There is too many battles and too little rest, Glavny, I get dizzy if I do not rest. I will need more food and that needs more money. Give more money and we spit on it.")
        })
      },
      "Conditions",
      {
        PlaceObj("MercChatConditionCombatParticipate", {PresetValue = ">=10"})
      }
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(902519634531, "This is Omryn. Today is holy day and I must not work. When holy days are over I will contact you.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(927832147316, "I am Omryn. You must be the Glavny. Do you have job? Is it easy? ")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(620358003115, "Did you go to take nap? Always good to take nap. I will take one as soon as we are done.")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(343432743008, "Good. You also take time for a quick bite during talks. We will get along well, Glavny!")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(441195752933, "Good. We spit on it. I will come to this Grand Chien place. But now I must eat and nap so I have strength when I am there.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(280135101598, "Glavny, contract is nearly over. Omryn needs money for food. Let us make new contract.")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(763826917260, "We will spit on it and then I will eat and nap.")
    })
  },
  StartingSalary = 650,
  SalaryLv1 = 375,
  SalaryMaxLv = 3300,
  StartingLevel = 2,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld B", "MeleeWeapon")
  end,
  MaxHitPoints = 67,
  StartingPerks = {
    "AutoWeapons",
    "Claustrophobic",
    "Spiritual",
    "EyesOnTheBack",
    "CancelShotPerk"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Omryn"})
  },
  Equipment = {"Omryn"},
  Specialization = "Marksmen",
  gender = "Male",
  VoiceResponseId = "Omryn"
}
