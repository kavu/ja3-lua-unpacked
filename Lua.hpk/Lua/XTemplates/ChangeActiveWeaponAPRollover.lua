PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu",
  id = "ChangeActiveWeaponAPRollover",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XRolloverWindow",
    "Margins",
    box(0, 0, 0, 10),
    "BorderWidth",
    0,
    "Background",
    RGBA(215, 159, 80, 255)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "Margins",
      box(0, 2, 0, 2),
      "OnContextUpdate",
      function(self, context, ...)
        local control = context.control
        local enabled = control:GetEnabled()
        self.idTitle:SetText(not enabled and context.RolloverDisabledText ~= "" and context.RolloverDisabledText or context.RolloverText ~= "" and context.RolloverText or control:GetRolloverText())
      end
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
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idTitle",
        "Padding",
        box(4, 4, 4, 4),
        "HAlign",
        "left",
        "VAlign",
        "center",
        "Clip",
        false,
        "UseClipBox",
        false,
        "FoldWhenHidden",
        true,
        "TextStyle",
        "InventoryRolloverAP",
        "Translate",
        true,
        "TextVAlign",
        "center"
      })
    })
  })
})
