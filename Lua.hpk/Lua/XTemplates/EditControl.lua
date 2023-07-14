PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu",
  id = "EditControl",
  PlaceObj("XTemplateWindow", {
    "IdNode",
    true,
    "Padding",
    box(10, 5, 10, 0)
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "GetText",
      "func",
      function(self, ...)
        local user_input = self:ResolveId("idEdit")
        return user_input and user_input:GetText()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetText(self, text)",
      "func",
      function(self, text)
        local user_input = self:ResolveId("idEdit")
        return user_input and user_input:SetText(text)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "ZOrder",
      -1,
      "Margins",
      box(-11, -5, -11, -5),
      "Dock",
      "box",
      "BorderColor",
      RGBA(32, 35, 47, 255),
      "Background",
      RGBA(32, 35, 47, 255),
      "BackgroundRectGlowColor",
      RGBA(32, 35, 47, 255)
    }),
    PlaceObj("XTemplateWindow", {
      "VAlign",
      "center",
      "BorderColor",
      RGBA(0, 0, 0, 0)
    }, {
      PlaceObj("XTemplateFunc", {
        "comment",
        "spawn and setup an Edit control",
        "name",
        "Open",
        "func",
        function(self, ...)
          local multiline = self.parent:GetMultiline()
          local edit_ctrl
          if multiline then
            edit_ctrl = XTemplateSpawn("XMultiLineEdit", self, self.context)
          else
            edit_ctrl = XTemplateSpawn("XEdit", self, self.context)
          end
          rawset(edit_ctrl, "UnfocusedText", self.parent:GetUnfocusedText())
          rawset(edit_ctrl, "FocusedBlinkingText", self.parent:GetFocusedBlinkingText())
          edit_ctrl:SetHint(_InternalTranslate(rawget(edit_ctrl, "UnfocusedText") or ""))
          edit_ctrl:SetMaxLen(rawget(self.parent, "MaxLen"))
          edit_ctrl:SetTextStyle(rawget(self.parent, "TextStyle"))
          edit_ctrl:SetId("idEdit")
          edit_ctrl:SetBorderWidth(0)
          edit_ctrl:SetBackground(RGBA(32, 35, 47, 255))
          edit_ctrl:SetFocusedBackground(RGBA(32, 35, 47, 255))
          edit_ctrl:SetHintColor(RGB(140, 139, 135))
          local init_text = rawget(self.parent, "InitialText")
          if (init_text or "") ~= "" then
            edit_ctrl:SetText(init_text)
          end
          local class = multiline and XMultiLineEdit or XEdit
          function edit_ctrl.OnSetFocus(this, ...)
            if this:GetText() == "" then
              local blinking_text = rawget(this, "FocusedBlinkingText")
              if blinking_text then
                this:SetHint(_InternalTranslate(blinking_text))
                if (blinking_text or "") ~= "" then
                  this:AddInterpolation({
                    id = "Blink",
                    type = const.intAlpha,
                    startValue = 0,
                    endValue = 255,
                    duration = 1000,
                    flags = const.intfLooping
                  })
                end
              end
            end
            class.OnSetFocus(this, ...)
          end
          function edit_ctrl.OnKillFocus(this, ...)
            this:RemoveModifier("Blink")
            if this:GetText() == "" then
              this:SetHint(_InternalTranslate(rawget(this, "UnfocusedText") or ""))
            end
            class.OnKillFocus(this, ...)
          end
          function edit_ctrl.OnTextChanged(this, ...)
            if this:GetText() == "" then
              local blinking_text = rawget(this, "FocusedBlinkingText")
              if blinking_text then
                this:SetHint(_InternalTranslate(blinking_text))
                if (blinking_text or "") ~= "" then
                  this:AddInterpolation({
                    id = "Blink",
                    type = const.intAlpha,
                    startValue = 0,
                    endValue = 255,
                    duration = 1000,
                    flags = const.intfLooping
                  })
                end
              end
            else
              this:RemoveModifier("Blink")
            end
            class.OnTextChanged(this, ...)
          end
          XWindow.Open(self, ...)
        end
      })
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "FocusedBlinkingText",
    "editor",
    "text",
    "Set",
    function(self, value)
      rawset(self, "FocusedBlinkingText", value)
    end,
    "Get",
    function(self)
      return rawget(self, "FocusedBlinkingText")
    end,
    "name",
    T(638591891287, "Focused Text"),
    "help",
    T(201250189360, "Will be blinking when the text field is focused.")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "InitialText",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      rawset(self, "InitialText", value)
    end,
    "Get",
    function(self)
      return rawget(self, "InitialText")
    end,
    "name",
    T(177266495989, "Initial Text"),
    "help",
    T(193129633000, "The edit control will be filled with this text upon creation.")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "UnfocusedText",
    "editor",
    "text",
    "Set",
    function(self, value)
      rawset(self, "UnfocusedText", value)
    end,
    "Get",
    function(self)
      return rawget(self, "UnfocusedText")
    end,
    "name",
    T(732771389157, "Unfocused Text"),
    "help",
    T(335703474650, "Will be displayed when the text field is not focused.")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "Multiline",
    "Set",
    function(self, value)
      rawset(self, "Multiline", value)
    end,
    "Get",
    function(self)
      return rawget(self, "Multiline")
    end,
    "name",
    T(724383084999, "Multi-line")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "MaxLen",
    "editor",
    "number",
    "default",
    511,
    "Set",
    function(self, value)
      rawset(self, "MaxLen", value)
    end,
    "Get",
    function(self)
      return rawget(self, "MaxLen")
    end,
    "name",
    T(834795715045, "Max Length")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "TextStyle",
    "editor",
    "text",
    "default",
    "PDAActivityDescription",
    "items",
    function(self)
      return Presets.TextStyle
    end,
    "translate",
    false,
    "Set",
    function(self, value)
      rawset(self, "TextStyle", value)
    end,
    "Get",
    function(self)
      return rawget(self, "TextStyle")
    end,
    "name",
    T(389299955934, "Text Style")
  })
})
