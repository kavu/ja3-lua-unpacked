PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu Rollover",
  id = "StatusEffectsRollover",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XRolloverWindow",
    "RolloverAnchor",
    "left",
    "BorderWidth",
    0,
    "UseClipBox",
    false,
    "Background",
    RGBA(0, 0, 0, 0),
    "AnchorType",
    "right"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "UseClipBox",
      false
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "Open",
        "func",
        function(self, ...)
          XContextControl.Open(self, ...)
          local control = self.context.control
          local offset = control and control:GetRolloverOffset()
          if offset and offset ~= box(0, 0, 0, 0) then
            self.parent:SetMargins(self.parent.Margins + offset)
          end
        end
      }),
      PlaceObj("XTemplateTemplate", {
        "__context",
        function(parent, context)
          return ResolvePropObj(context)
        end,
        "__condition",
        function(parent, context)
          return IsKindOf(context, "StatusEffectObject") and context:HasVisibleEffects()
        end,
        "__template",
        "MercStatusEffectsMoreInfo"
      }, {
        PlaceObj("XTemplateCode", {
          "comment",
          "Make always visible",
          "run",
          function(self, parent, context)
            parent:SetVisible(true)
            parent.SetVisible = empty_func
          end
        })
      })
    })
  })
})
