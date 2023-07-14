PlaceObj("XTemplate", {
  __is_kind_of = "XBadgeArrow",
  group = "Zulu Badges",
  id = "DeploymentBadgeArrow",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XBadgeArrow",
    "Image",
    "UI/Hud/deploy_marker"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "UseClipBox",
      false,
      "Image",
      "UI/Hud/iw_deployment_zone"
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
