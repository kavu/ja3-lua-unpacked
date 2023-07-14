PlaceObj("XTemplate", {
  Comment = "used for modes that dont have their own attack mode",
  __content = function(parent, context)
    return parent:ResolveId("idParent")
  end,
  group = "Zulu",
  id = "IModeCombatAttackBase",
  PlaceObj("XTemplateWindow", {
    "__class",
    "IModeCombatAttackBase"
  }, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "IModeCombatAttackBaseGeneric"
    })
  })
})
