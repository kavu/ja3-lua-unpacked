PlaceObj("XTemplate", {
  __is_kind_of = "XTextButton",
  group = "Zulu",
  id = "EnemyHeadIconButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XTextButton",
    "LayoutMethod",
    "Box",
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(0, 0, 0, 0),
    "OnContextUpdate",
    function(self, context, ...)
      self:UpdateStyle()
      self:SetText(self.Text)
      XContextControl.OnContextUpdate(self, context)
    end,
    "FXMouseIn",
    "HeadButtonRollover",
    "FXPress",
    "HeadButtonPress",
    "FXPressDisabled",
    "HeadButtonDisabled",
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "RolloverBackground",
    RGBA(0, 0, 0, 0),
    "PressedBackground",
    RGBA(0, 0, 0, 0),
    "TextStyle",
    "UICircleButtonText"
  }, {
    PlaceObj("XTemplateWindow", {"UseClipBox", false}, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idHeadIcon",
        "IdNode",
        false,
        "HAlign",
        "center",
        "VAlign",
        "center",
        "UseClipBox",
        false,
        "Image",
        "UI/Hud/enemy_head",
        "Rows",
        2,
        "Columns",
        2,
        "ImageColor",
        RGBA(195, 186, 172, 255)
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idSpecialIcon",
        "Padding",
        box(0, -15, -20, 0),
        "HAlign",
        "center",
        "VAlign",
        "center",
        "UseClipBox",
        false,
        "FoldWhenHidden",
        true,
        "ImageScale",
        point(750, 750)
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "precalc observer",
      "__context",
      function(parent, context)
        return "unit_precalc"
      end,
      "__class",
      "XContextWindow",
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:OnContextUpdate()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "UpdateStyle(self, rollover)",
      "func",
      function(self, rollover)
        if not self.visible then
          return
        end
        local unit = self.context
        rollover = rollover or self:MouseInWindow(terminal.GetMousePos())
        if GetUIStyleGamepad() then
          local igi = GetInGameInterfaceModeDlg()
          if igi and igi.target == unit then
            rollover = true
          end
        end
        self.idHeadIcon:SetColumn(rollover and 2 or 1)
        if unit.ui_badge then
          unit.ui_badge:SetActive(rollover, "head-icon-rollover")
        end
        local greyOut = false
        local isVisibleCurrent = true
        if SelectedObj then
          isVisibleCurrent = UIEnemyCanSee(unit)
        end
        if not isVisibleCurrent then
          greyOut = true
        end
        local previousState = rawget(self, "greyOut")
        if greyOut == previousState then
          return
        end
        rawset(self, "greyOut", greyOut)
        local image = false
        if unit.villain then
          image = "UI/Hud/enemy_boss"
        else
          local rolePreset = Presets.EnemyRole.Default[unit.role or "Default"]
          image = rolePreset.Icon or "UI/Hud/enemy_head"
        end
        local headIcon = self.idHeadIcon
        if headIcon.Image ~= image then
          headIcon:SetImage(image)
        end
        headIcon:SetDesaturation(greyOut and 255 or 0)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        self.idHeadIcon:SetRow(selected and 2 or 1)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self:UpdateStyle(rollover)
        XTextButton.OnSetRollover(self, rollover)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete(self)",
      "func",
      function(self)
        local unit = self.context
        if unit.ui_badge then
          unit.ui_badge:SetActive(false, "head-icon-rollover")
        end
      end
    })
  })
})
