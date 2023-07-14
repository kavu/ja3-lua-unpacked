PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu Badges",
  id = "EnemyDeploymentBadgeArrow",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "HAlign",
    "left",
    "VAlign",
    "top",
    "ChildrenHandleMouse",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XBadgeArrow",
      "Id",
      "idArrow",
      "IdNode",
      false,
      "Image",
      "UI/Hud/enemy_marker"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Margins",
      box(17, 15, 0, 0),
      "HAlign",
      "left",
      "VAlign",
      "top",
      "UseClipBox",
      false,
      "Image",
      "UI/Hud/enemy_incoming"
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "Open(self)",
        "func",
        function(self)
          XImage.Open(self)
          local arrowMod = table.copy(self:ResolveId("node").modifiers[1])
          arrowMod.faceTargetOffScreen = const.badgeNoRotate
          self:AddDynamicPosModifier(arrowMod)
        end
      })
    })
  })
})
