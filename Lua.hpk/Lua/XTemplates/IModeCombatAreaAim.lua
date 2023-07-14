PlaceObj("XTemplate", {
  group = "Zulu",
  id = "IModeCombatAreaAim",
  PlaceObj("XTemplateWindow", {
    "__class",
    "IModeCombatAreaAim"
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "NextTarget",
      "ActionName",
      T(910326087871, "Next Target"),
      "ActionShortcut",
      "E",
      "ActionBindable",
      true,
      "ActionState",
      function(self, host)
        if host.context.free_aim and not host.crosshair then
          return "disabled"
        end
        return host.action.IsTargetableAttack and "enabled" or "disabled"
      end,
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
      T(444114518534, "Prev Target"),
      "ActionShortcut",
      "Q",
      "ActionBindable",
      true,
      "ActionState",
      function(self, host)
        if host.context.free_aim and not host.crosshair then
          return "disabled"
        end
        return host.action.IsTargetableAttack and "enabled" or "disabled"
      end,
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
