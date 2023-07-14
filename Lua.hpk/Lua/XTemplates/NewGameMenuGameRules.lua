PlaceObj("XTemplate", {
  __is_kind_of = "NewGameCategory",
  group = "Zulu",
  id = "NewGameMenuGameRules",
  PlaceObj("XTemplateTemplate", {
    "comment",
    "game rules",
    "__template",
    "NewGameCategory",
    "IdNode",
    false,
    "Name",
    T(468039426572, "Game Rules")
  }),
  PlaceObj("XTemplateTemplate", {
    "__context",
    function(parent, context)
      return GameRuleDefs.ForgivingMode
    end,
    "__template",
    "NewGameBoolEntry",
    "IdNode",
    false
  }),
  PlaceObj("XTemplateTemplate", {
    "__context",
    function(parent, context)
      return GameRuleDefs.DeadIsDead
    end,
    "__template",
    "NewGameBoolEntry",
    "IdNode",
    false
  }),
  PlaceObj("XTemplateTemplate", {
    "__context",
    function(parent, context)
      return GameRuleDefs.Ironman
    end,
    "__template",
    "NewGameBoolEntry",
    "IdNode",
    false
  }),
  PlaceObj("XTemplateTemplate", {
    "__context",
    function(parent, context)
      return GameRuleDefs.LethalWeapons
    end,
    "__template",
    "NewGameBoolEntry",
    "IdNode",
    false
  })
})
