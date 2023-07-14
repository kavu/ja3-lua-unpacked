PlaceObj("XTemplate", {
  __is_kind_of = "NewGameCategory",
  group = "Zulu",
  id = "NewGameMenuDifficulty",
  PlaceObj("XTemplateTemplate", {
    "comment",
    "difficulty",
    "__template",
    "NewGameCategory",
    "IdNode",
    false,
    "Name",
    T(409710114741, "Difficulty")
  }),
  PlaceObj("XTemplateTemplate", {
    "__context",
    function(parent, context)
      return GameDifficulties.Normal
    end,
    "__template",
    "NewGameDiffEntry",
    "Id",
    "idNormal",
    "IdNode",
    false
  }),
  PlaceObj("XTemplateTemplate", {
    "__context",
    function(parent, context)
      return GameDifficulties.Hard
    end,
    "__template",
    "NewGameDiffEntry",
    "Id",
    "idHard",
    "IdNode",
    false
  }),
  PlaceObj("XTemplateTemplate", {
    "__context",
    function(parent, context)
      return GameDifficulties.VeryHard
    end,
    "__template",
    "NewGameDiffEntry",
    "Id",
    "idVeryHard",
    "IdNode",
    false
  })
})
