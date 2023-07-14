PlaceObj("XTemplate", {
  group = "Zulu",
  id = "NewGameMenuSettings",
  PlaceObj("XTemplateTemplate", {
    "comment",
    "settings",
    "__template",
    "NewGameCategory",
    "IdNode",
    false,
    "OnLayoutComplete",
    function(self)
      self.idName:SetText(T(431897134719, "Settings"))
    end
  }),
  PlaceObj("XTemplateTemplate", {
    "__context",
    function(parent, context)
      return {
        display_name = T(367240474542, "Show Tutorials"),
        description = T(205693698076, "Display tutorial messages during your playthrough."),
        id = "HintsEnabled"
      }
    end,
    "__template",
    "NewGameBoolEntry",
    "IdNode",
    false
  }),
  PlaceObj("XTemplateTemplate", {
    "__context",
    function(parent, context)
      return {
        display_name = T(736123287789, "Left Click Moves (Exploration)"),
        description = T(246835769185, "Use left-click to move mercs while not in combat."),
        id = "LeftClickMoveExploration"
      }
    end,
    "__template",
    "NewGameBoolEntry",
    "IdNode",
    false
  }),
  PlaceObj("XTemplateTemplate", {
    "__context",
    function(parent, context)
      return {
        display_name = T(227204678948, "Targeting Action Camera"),
        description = T(819569684768, [[
A special cinematic camera view will be used while aiming an attack.

The action camera is always used with long-range weapons like sniper rifles.]]),
        id = "ActionCamera"
      }
    end,
    "__template",
    "NewGameBoolEntry",
    "IdNode",
    false
  }),
  PlaceObj("XTemplateTemplate", {
    "__context",
    function(parent, context)
      return {
        display_name = T(431312590003, "Auto-Pause Conversations"),
        description = T(118088730513, "Wait for input before continuing to the next conversation line."),
        id = "PauseConversation"
      }
    end,
    "__template",
    "NewGameBoolEntry",
    "IdNode",
    false
  })
})
