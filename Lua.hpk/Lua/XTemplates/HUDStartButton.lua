PlaceObj("XTemplate", {
  __is_kind_of = "GenericHUDButtonFrame",
  group = "Zulu",
  id = "HUDStartButton",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "GenericHUDButtonFrame",
    "Id",
    "idStartButton",
    "MinWidth",
    200
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "HUDButton",
      "RolloverAnchor",
      "center-top",
      "Id",
      "idStartButtonInner",
      "IdNode",
      false,
      "Padding",
      box(5, 0, 5, 0),
      "HAlign",
      "stretch",
      "MinHeight",
      54,
      "MaxWidth",
      999999999,
      "MaxHeight",
      54,
      "FoldWhenHidden",
      true,
      "FXPress",
      "",
      "OnPress",
      function(self, gamepad)
        HideCombatLog("not_instant")
        local dlg = GetDialog(self)
        local alignMenuTo = self.parent.parent
        local node = alignMenuTo:ResolveId("node")
        if node.idStartMenu then
          return
        end
        local ctxMenu = XTemplateSpawn("StartButtonContextMenu", alignMenuTo, dlg)
        ctxMenu:SetZOrder(999)
        ctxMenu:SetAnchor(alignMenuTo.box)
        ctxMenu:Open()
        self.desktop:SetModalWindow(ctxMenu)
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idIcon",
        "Dock",
        "left",
        "VAlign",
        "center",
        "Image",
        "UI/Hud/pda",
        "Columns",
        2
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idLargeText",
        "Margins",
        box(0, 0, 5, 0),
        "VAlign",
        "center",
        "TextStyle",
        "HUDHeaderBigger",
        "Translate",
        true,
        "Text",
        T(892354137885, "COMMAND"),
        "WordWrap",
        false,
        "TextHAlign",
        "center"
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "Open(self)",
        "func",
        function(self)
          HUDButton.Open(self)
          local dlg = GetDialog(self)
          if IsKindOf(dlg, "IModeCommonUnitControl") then
            self:SetMinHeight(75)
            self:SetMaxHeight(75)
          end
          self:SetMouseCursor(gv_SatelliteView and "UI/Cursors/Pda_Hand.tga" or "UI/Cursors/Hand.tga")
        end
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "OnSetRollover(self, rollover)",
        "func",
        function(self, rollover)
          self:ResolveId("node").idIcon:SetColumn(rollover and 2 or 1)
          XButton.OnSetRollover(self, rollover)
        end
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "controller hint",
      "__context",
      function(parent, context)
        return "GamepadUIStyleChanged"
      end,
      "__class",
      "XText",
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
      T(979330466889, "<Back>")
    })
  })
})
