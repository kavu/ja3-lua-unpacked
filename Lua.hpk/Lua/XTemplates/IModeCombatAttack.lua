PlaceObj("XTemplate", {
  Comment = "single target, crosshair shooty attacks",
  group = "Zulu",
  id = "IModeCombatAttack",
  PlaceObj("XTemplateWindow", {
    "__class",
    "IModeCombatAttack"
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "NextTarget",
      "ActionName",
      T(812476569100, "Next Target"),
      "ActionBindable",
      true,
      "OnAction",
      function(self, host, source, ...)
        host:NextTarget()
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "PrevTarget",
      "ActionName",
      T(906030229318, "Prev Target"),
      "ActionBindable",
      true,
      "OnAction",
      function(self, host, source, ...)
        host:PrevTarget()
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "IModeCombatAttackBaseGeneric"
    })
  })
})
