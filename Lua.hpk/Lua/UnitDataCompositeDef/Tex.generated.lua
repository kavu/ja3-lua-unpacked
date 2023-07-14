UndefineClass("Tex")
DefineClass.Tex = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 81,
  Agility = 77,
  Dexterity = 75,
  Strength = 70,
  Wisdom = 51,
  Leadership = 1,
  Marksmanship = 88,
  Mechanical = 48,
  Explosives = 1,
  Medical = 4,
  Portrait = "UI/MercsPortraits/Tex",
  BigPortrait = "UI/Mercs/Tex",
  Name = T(686198945827, "Tex R. Colburn"),
  Nick = T(384280286220, "Tex"),
  AllCapsNick = T(656022978516, "TEX"),
  Bio = T(855301635048, [[
With scripts for Asian-themed westerns drying up like the proverbial Kyoto tumbleweed, Tex has returned to the mercenary trade. Not discouraged by this seeming reversal of fortune, the irrepressible Colburn loves showing off his ambidextrous skills and fancy pistol-twirling for his fellow mercs. 
On the battlefield, you can find him with the sun at his back, squinting a steely glare out from under his ten-gallon hat.]]),
  Nationality = "Japan",
  Title = T(415603758957, "Cowboy of the Rising Sun"),
  Email = T(595579036754, "cowboydirector@aim.com"),
  snype_nick = T(568991391705, "cowboydirector"),
  Refusals = {
    PlaceObj("MercChatRefusal", {
      "Lines",
      {
        PlaceObj("ChatMessage", {
          "Text",
          T(313041068988, "Very sad, partner. I have big scene coming up. Very hard stunt. I am working 24-hours a day. Try again another time.")
        })
      },
      "Conditions",
      {},
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
          T(435944476423, "Fox is there? She should be fighting in big movies, not little battlefields. She is so talented! I will be honored to work with her again. I will change schedule for this.")
        })
      },
      "Conditions",
      {
        PlaceObj("UnitHireStatus", {Status = "Hired", TargetUnit = "Fox"})
      },
      "chanceToRoll",
      100
    })
  },
  Offline = {
    PlaceObj("ChatMessage", {
      "Text",
      T(209674255281, "You have reached Tex R. Colburn - professional actor, stuntman, and mercenary. I am shooting a movie right now. Big scene, lots of special effects. I will reach you later. I may even give autograph.")
    })
  },
  GreetingAndOffer = {
    PlaceObj("ChatMessage", {
      "Text",
      T(454484491550, "Arigato. This is Tex. You are gathering a posse to fight?")
    })
  },
  ConversationRestart = {
    PlaceObj("ChatMessage", {
      "Text",
      T(699864175196, "Let us continue discussion, partner. You were saying?")
    })
  },
  IdleLine = {
    PlaceObj("ChatMessage", {
      "Text",
      T(684216191720, "I have a lot of autographs to sign, partner. Do not make wait. ")
    })
  },
  PartingWords = {
    PlaceObj("ChatMessage", {
      "Text",
      T(478717643527, "You have got yourself a deal, partner. This here cowboy is coming your way.")
    })
  },
  RehireIntro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(260654543464, "I have many calls for work, partner. If I continue saying no, we must make new deal.")
    })
  },
  RehireOutro = {
    PlaceObj("ChatMessage", {
      "Text",
      T(871041368651, "My six-shooter is ready, partner. Let's return to Dodge city.")
    })
  },
  StartingSalary = 1800,
  SalaryLv1 = 900,
  SalaryMaxLv = 4700,
  LegacyNotes = [[
JA1:

"A new member, Tex R. Colburn joins A.I.M. from the wide open ranges of Tokyo, Japan. This asian cowboy-wannabe has limited experience, but seems to pick up on things rather quickly. However, you will have to put up with some pretty annoying "B" western cliches!" 

JA2 Alumni:

"One of our more colourful warriors, Tex Colburn, handed in his six-shooters to fulfill his dream of starring on the big screen. As a rising star of japanese westerns, he played the lead in "Much Dust, Many Bullets." and has recieved glowing reviews for his roles in the classic films "Attack of the Clydesdales" and "Have Honda, will travel.". 

"One of out more colourful warriors, Tex Colburn has returned to the mercenary life. As a star of japanese westerns, he played the lead in "Much Dust, Many Bullets." and has recieved glowing reviews for his roles in the classic films "Attack of the Clydesdales" and "Have Honda, Will Travel." Tex is quick with a .357 in each hand, and travels with his own stage makeup". - M.E.R.C. dossier, v1.13

After taking leave from A.I.M. in Jagged Alliance 2, Tex appears again in Tracona, at Betty Fung Convenience Store and Video Outlet, on a celebrity tour of third-world countries to promote his latest movie, "Wild, Wild East".  Disgruntled with the life of a Hollywood celebrity and feeling nostalgic for his days as a mercenary with A.I.M., he can be easily persuaded to join forces with your mercenaries.]],
  StartingLevel = 4,
  CustomEquipGear = function(self, items)
    self:TryEquip(items, "Handheld A", "Firearm")
    self:TryEquip(items, "Handheld A", "Firearm")
  end,
  MaxHitPoints = 81,
  Likes = {"Fox", "Larry"},
  StartingPerks = {
    "Ambidextrous",
    "CQCTraining",
    "Claustrophobic",
    "DanceForMe",
    "OpportunisticKiller",
    "HitTheDeck",
    "SteadyBreathing"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Tex"})
  },
  Equipment = {"Tex"},
  Tier = "Elite",
  Specialization = "Marksmen",
  gender = "Male",
  blocked_spots = set("Weaponls", "Weaponrs"),
  VoiceResponseId = "Tex"
}
