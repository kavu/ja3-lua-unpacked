PlaceObj("XTemplate", {
  __is_kind_of = "GenericHUDButtonFrame",
  group = "Zulu",
  id = "PDAStartButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "Id",
    "idStartButton",
    "Margins",
    box(45, 0, 0, 15),
    "HAlign",
    "left",
    "VAlign",
    "top",
    "MinWidth",
    203,
    "MinHeight",
    44,
    "MaxHeight",
    44,
    "Background",
    RGBA(0, 0, 0, 0),
    "MouseCursor",
    "UI/Cursors/Pda_Hand.tga",
    "FXMouseIn",
    "buttonRollover",
    "FXPressDisabled",
    "IactDisabled",
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "OnPress",
    function(self, gamepad)
      local dlg = GetDialog("PDADialog")
      local ctxMenu = XTemplateSpawn("StartButtonContextMenu", dlg.idDisplayPopupHost, dlg)
      ctxMenu:SetZOrder(999)
      ctxMenu:SetAnchor(self.box)
      ctxMenu:Open()
      self.desktop:SetModalWindow(ctxMenu)
    end,
    "RolloverBackground",
    RGBA(0, 0, 0, 0),
    "PressedBackground",
    RGBA(0, 0, 0, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Dock",
      "box",
      "Image",
      "UI/PDA/os_background",
      "FrameBox",
      box(5, 5, 5, 5)
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idIcon",
      "Margins",
      box(10, 0, 5, 0),
      "Dock",
      "left",
      "VAlign",
      "center",
      "Image",
      "UI/Hud/pda",
      "Columns",
      2,
      "ImageScale",
      point(800, 800)
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "controller hint",
        "__context",
        function(parent, context)
          return "GamepadUIStyleChanged"
        end,
        "__class",
        "XText",
        "Margins",
        box(-5, 0, 0, -5),
        "HAlign",
        "left",
        "VAlign",
        "bottom",
        "ScaleModifier",
        point(700, 700),
        "TextStyle",
        "HUDHeaderBig",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          self:SetVisible(GetUIStyleGamepad())
          XText.OnContextUpdate(self, context, ...)
        end,
        "Translate",
        true,
        "Text",
        T(473300507532, "<Back>")
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idLargeText",
      "Margins",
      box(0, 0, 5, 0),
      "HAlign",
      "center",
      "VAlign",
      "center",
      "TextStyle",
      "HUDHeaderBigger",
      "Translate",
      true,
      "Text",
      T(658560684995, "COMMAND"),
      "TextHAlign",
      "center",
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self.idIcon:SetColumn(rollover and 2 or 1)
        XButton.OnSetRollover(self, rollover)
      end
    })
  })
})
