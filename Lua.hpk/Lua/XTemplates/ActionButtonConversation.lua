PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "ActionButtonConversation",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "VAlign",
    "top",
    "MinHeight",
    53,
    "MaxWidth",
    500,
    "Background",
    RGBA(0, 0, 0, 0),
    "FadeInTime",
    300,
    "FadeOutTime",
    300,
    "FXMouseIn",
    "activityHover_Conversation",
    "FXPress",
    "activityButtonPress_ConversationSelect",
    "FXPressDisabled",
    "IactDisabled",
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "RolloverBackground",
    RGBA(0, 0, 0, 0),
    "PressedBackground",
    RGBA(0, 0, 0, 0)
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "OnPressButtonFn(self)",
      "func",
      function(self)
        local dlg = GetDialog(self)
        if dlg:IsUIControllable() then
          if dlg.window_state ~= "destroying" and dlg.phrase_start_time and now() > dlg.phrase_start_time + const.UIButtonPressDelay + dlg:GetAnimStart() and not dlg.phrase_chosen and not dlg.anim_hide then
            dlg.phrase_chosen = true
            self:CreateThread(function()
              for i = 1, 6 do
                local choice = dlg["choice" .. i]
                if choice ~= self then
                  choice:SetVisible(false)
                end
              end
              local additional = {
                "11",
                "31",
                "41",
                "61"
              }
              for _, i in ipairs(additional) do
                local choice = dlg["choice" .. i]
                if choice ~= self then
                  choice:SetVisible(false)
                end
              end
              Sleep(300)
              dlg:PhraseChoice(self.OnPressParam)
            end)
          end
        else
          NetSyncEvent("AdviseConversationChoice", self.OnPressParam)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "ButtonA" then
          self:OnPressButtonFn()
          return "break"
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idContainer",
      "VAlign",
      "center",
      "MaxWidth",
      500
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Id",
        "idEffect",
        "Transparency",
        170,
        "HandleKeyboard",
        false,
        "Image",
        "UI/Common/screen_effect",
        "TileFrame",
        true,
        "SqueezeX",
        false,
        "SqueezeY",
        false
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "UIEffectModifierId",
        "MainMenuMainBar",
        "Id",
        "idImage",
        "IdNode",
        false,
        "Background",
        RGBA(32, 35, 47, 255),
        "Transparency",
        50,
        "HandleMouse",
        true,
        "DisabledBackground",
        RGBA(80, 80, 75, 255)
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idTextPart",
        "Padding",
        box(7, 3, 7, 3),
        "MinWidth",
        378,
        "MinHeight",
        53,
        "MaxWidth",
        378
      }, {
        PlaceObj("XTemplateWindow", nil, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "Id",
            "idRolloverFrame",
            "IdNode",
            false,
            "Visible",
            false,
            "Background",
            RGBA(215, 159, 80, 255),
            "HandleMouse",
            true,
            "DisabledBackground",
            RGBA(80, 80, 75, 255)
          }),
          PlaceObj("XTemplateWindow", {
            "Padding",
            box(10, 0, 10, 0),
            "VAlign",
            "center",
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idText",
              "IdNode",
              false,
              "MaxWidth",
              360,
              "DrawOnTop",
              true,
              "HandleMouse",
              false,
              "TextStyle",
              "ConversationChoiceNormal",
              "Translate",
              true,
              "TextVAlign",
              "center"
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "SetStarImage(self, rollover)",
                "func",
                function(self, rollover)
                  local node = self:ResolveId("node")
                  local r, g, b, a
                  if self:GetEnabled() then
                    r, g, b, a = GetRGBA(rollover and self:GetRolloverTextColor() or self:GetTextColor())
                    node.idImageStar:SetImageColor(RGBA(r, g, b, a))
                  else
                    r, g, b, a = GetRGBA(rollover and self:GetDisabledRolloverTextColor() or self:GetDisabledTextColor())
                    node.idImageStar:SetDisabledImageColor(RGBA(r, g, b, a))
                  end
                  node.idImageStar:SetVisible(rawget(node, "StarImage"))
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnSetRollover(self, rollover)",
                "func",
                function(self, rollover)
                  local dimmed = rawget(self, "dimmed")
                  self:SetTransparency(dimmed and 100 or 0)
                  if dimmed then
                    self:SetTextStyle("ConversationChoiceDimmed")
                  else
                    self:SetTextStyle(rollover and "ConversationChoiceNormalRollover" or "ConversationChoiceNormal")
                  end
                end
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Id",
              "idImageStar",
              "HAlign",
              "left",
              "VAlign",
              "top",
              "MinWidth",
              9,
              "MinHeight",
              9,
              "MaxWidth",
              9,
              "MaxHeight",
              9,
              "FoldWhenHidden",
              true,
              "DrawOnTop",
              true,
              "Image",
              "UI/Conversation/T_Choice_Star",
              "ImageFit",
              "stretch",
              "DisabledImageColor",
              RGBA(195, 189, 172, 77)
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "OnSetRollover(self, rollover)",
                "func",
                function(self, rollover)
                  local node = self:ResolveId("node")
                  local dimmed = rawget(node.idText, "dimmed")
                  self:SetTransparency(dimmed and 100 or 0)
                end
              })
            })
          })
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "__context",
        function(parent, context)
          return "g_CoOpConversationOptionAdvice"
        end,
        "__template",
        "CoOpOtherPlayerMark",
        "Id",
        "idCoOpAdvice",
        "HAlign",
        "left",
        "VAlign",
        "center",
        "MinWidth",
        35,
        "MinHeight",
        35,
        "MaxWidth",
        35,
        "MaxHeight",
        35,
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local node = self:ResolveId("node")
          local isAdvisedOption = node.OnPressParam == g_CoOpConversationOptionAdvice
          local dlg = GetDialog(self)
          if not dlg:IsUIControllable() then
            self:SetVisible(false)
            node:SetRolloverMode(isAdvisedOption)
            return
          end
          self:SetVisible(isAdvisedOption)
        end
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetEnabled(self, enabled)",
      "func",
      function(self, enabled)
        XButton.SetEnabled(self, enabled)
        XText.SetEnabled(self.idText, enabled)
        XImage.SetEnabled(self.idImageStar, enabled)
        XFrame.SetEnabled(self.idImage, enabled)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self:SetRolloverMode(rollover)
        XButton.OnSetRollover(self, rollover)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetRolloverMode(self, rollover)",
      "func",
      function(self, rollover)
        XText.SetRollover(self.idText, rollover)
        XImage.SetRollover(self.idImageStar, rollover)
        self.idImage:SetVisible(true)
        local dimmed = rawget(self.idText, "dimmed")
        if dimmed then
          self.idImage:SetBackground(rollover and RGBA(215, 159, 80, 200) or RGBA(27, 31, 45, 200))
          self.idImage:SetTransparency(50)
        else
          self.idImage:SetBackground(rollover and RGB(215, 159, 80) or RGB(27, 31, 45))
        end
        self.idImage:SetUIEffectModifierId(rollover and "MainMenuHighlight" or "MainMenuMainBar")
        if self:GetEnabled() or rollover then
          self.idImage:SetDesaturation(0)
        else
          self.idImage:SetDesaturation(50)
        end
        self.idText:SetStarImage(rollover)
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "Text",
    "editor",
    "text",
    "Set",
    function(self, value)
      self.idText:SetText(value)
      self.idText:SetStarImage()
      self:SetRolloverText(rawget(self, "ConversationRolloverText"))
    end,
    "Get",
    function(self)
      return self.idText:GetText()
    end
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "ConversationRolloverText",
    "editor",
    "text",
    "Set",
    function(self, value)
      rawset(self, "ConversationRolloverText", value)
    end,
    "Get",
    function(self)
      return rawget(self, "ConversationRolloverText")
    end
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "Align",
    "editor",
    "choice",
    "items",
    function(self)
      return {"left", "right"}
    end,
    "translate",
    false,
    "Set",
    function(self, value)
      self.idText:SetTextHAlign("left")
      self.idContainer:SetHAlign(value)
      self:SetHAlign(value)
      self.idCoOpAdvice:SetMargins(value == "right" and box(0, 0, -40, 0) or box(-40, 0, 0, 0))
      self.idCoOpAdvice:SetHAlign(value)
    end,
    "Get",
    function(self)
      return self.idContainer:GetHAlign()
    end
  })
})
