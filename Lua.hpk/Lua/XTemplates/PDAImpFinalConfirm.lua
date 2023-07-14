PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAImpFinalConfirm",
  PlaceObj("XTemplateProperty", {
    "id",
    "HeaderButtonId",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.HeaderButtonId = value
    end,
    "Get",
    function(self)
      return self.HeaderButtonId
    end,
    "name",
    T(818027610859, "HeaderButtonId")
  }),
  PlaceObj("XTemplateWindow", {
    "LayoutMethod",
    "VList",
    "LayoutVSpacing",
    8
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XWindow.Open(self, ...)
        PDAImpHeaderEnable(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        XWindow.OnDelete(self, ...)
        PDAImpHeaderDisable(self)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextFrame",
      "Id",
      "idAnswers",
      "Image",
      "UI/PDA/imp_panel",
      "FrameBox",
      box(8, 8, 8, 8),
      "ContextUpdateOnOpen",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(20, 20, 20, 20),
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        5
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "top",
          "HandleMouse",
          false,
          "TextStyle",
          "PDAIMPContentTitle",
          "Translate",
          true,
          "Text",
          T(767221303643, "Confirmation Page")
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "top",
          "HandleMouse",
          false,
          "TextStyle",
          "PDAIMPContentText",
          "Translate",
          true,
          "Text",
          T(709573996800, [[
We can offer you only 1 slot for a mercenary certificate.
Are you sure this is your choice of mercenary?]])
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextFrame",
          "IdNode",
          false,
          "Margins",
          box(8, 8, 8, 8),
          "Image",
          "UI/PDA/imp_panel_2",
          "FrameBox",
          box(5, 5, 5, 5)
        }, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idList",
            "Margins",
            box(5, 5, 5, 5),
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            4
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "SelNext(self)",
              "func",
              function(self)
                local count = #self
                local idx = 1
                for i = 1, count do
                  local ctrl = self[i]
                  local tgl = ctrl.idbtnChecked:GetToggled()
                  if tgl then
                    idx = i
                    break
                  end
                end
                idx = count > idx and idx + 1 or 1
                self[idx]:Toggle(true)
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "SelPrev(self)",
              "func",
              function(self)
                local count = #self
                local idx = count
                for i = 1, count do
                  local ctrl = self[i]
                  local tgl = ctrl.idbtnChecked:GetToggled()
                  if tgl then
                    idx = i
                    break
                  end
                end
                idx = 1 < idx and idx - 1 or count
                self[idx]:Toggle(true)
              end
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContextControl",
              "Id",
              "idGoBack",
              "MinHeight",
              40,
              "LayoutMethod",
              "HList",
              "LayoutHSpacing",
              10,
              "Background",
              RGBA(255, 255, 255, 0),
              "MouseCursor",
              "UI/Cursors/Pda_Hand.tga",
              "OnContextUpdate",
              function(self, context, ...)
                if not CanPay(const.Imp.CertificateCost) then
                  self:Toggle(true)
                end
              end,
              "FXMouseIn",
              "buttonRollover",
              "FXPress",
              "buttonPress",
              "FXPressDisabled",
              "IactDisabled"
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "Toggle(self, toggled)",
                "func",
                function(self, toggled)
                  local prev = self.idbtnChecked.Toggled
                  self.idbtnChecked:SetToggled(toggled)
                  self.idbtnChecked:SetIconRow(toggled and 2 or 1)
                  self.idAnswer:SetTextStyle(toggled and "PDAIMPAnswerSelected" or "PDAIMPAnswer")
                  self.idBack:SetBackground(toggled and GameColors.L or RGBA(255, 255, 255, 0))
                  local node = self.parent:ResolveId("node")
                  local dlg = GetDialog(self)
                  dlg.impconfirm.back = toggled
                  if toggled then
                    node.idConfirm:Toggle(false)
                    dlg.impconfirm.confirm = false
                  end
                  dlg:ActionsUpdated()
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnMouseButtonDown(self, pos, button)",
                "func",
                function(self, pos, button)
                  if button == "L" then
                    self.idbtnChecked:OnPress()
                    PlayFX("buttonPress", "start")
                    return "break"
                  end
                end
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XToggleButton",
                "Id",
                "idbtnChecked",
                "Margins",
                box(10, 0, 0, 0),
                "VAlign",
                "center",
                "Background",
                RGBA(255, 255, 255, 0),
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "FXMouseIn",
                "buttonRollover",
                "FXPress",
                "buttonPress",
                "FXPressDisabled",
                "IactDisabled",
                "FocusedBackground",
                RGBA(255, 255, 255, 0),
                "OnPress",
                function(self, gamepad)
                  XTextButton.OnPress(self)
                  self.parent:Toggle(not self.Toggled)
                end,
                "RolloverBackground",
                RGBA(255, 255, 255, 0),
                "PressedBackground",
                RGBA(255, 255, 255, 0),
                "Icon",
                "UI/PDA/imp_radio_button",
                "IconRows",
                2
              }),
              PlaceObj("XTemplateWindow", {
                "Id",
                "idBack",
                "Margins",
                box(35, 4, 4, 4),
                "Dock",
                "box"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idAnswer",
                "VAlign",
                "center",
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "FXMouseIn",
                "buttonRollover",
                "FXPress",
                "buttonPress",
                "FXPressDisabled",
                "IactDisabled",
                "TextStyle",
                "PDAIMPAnswer",
                "Translate",
                true,
                "Text",
                T(138806340028, "Go Back")
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnMouseButtonDown(self, pos, button)",
                  "func",
                  function(self, pos, button)
                    XText.OnMouseButtonDown(self, pos, button)
                    if button == "L" then
                      self.parent.idbtnChecked:OnPress()
                      return "break"
                    end
                  end
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContextControl",
              "Id",
              "idConfirm",
              "MinHeight",
              40,
              "LayoutMethod",
              "HList",
              "LayoutHSpacing",
              10,
              "Background",
              RGBA(255, 255, 255, 0),
              "MouseCursor",
              "UI/Cursors/Pda_Hand.tga",
              "OnContextUpdate",
              function(self, context, ...)
                self.idAnswer:SetText(T({
                  160081380457,
                  "Pay <money(cost)>",
                  cost = const.Imp.CertificateCost
                }))
                local enabled = CanPay(const.Imp.CertificateCost)
                self:SetEnabled(enabled)
                self.idAnswer:SetEnabled(enabled)
                self:Toggle(enabled)
              end,
              "FXMouseIn",
              "buttonRollover",
              "FXPress",
              "buttonPress",
              "FXPressDisabled",
              "IactDisabled"
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "Toggle(self, toggled)",
                "func",
                function(self, toggled)
                  local prev = self.idbtnChecked.Toggled
                  self.idbtnChecked:SetToggled(toggled)
                  self.idbtnChecked:SetIconRow(toggled and 2 or 1)
                  self.idAnswer:SetTextStyle(toggled and "PDAIMPAnswerSelected" or "PDAIMPAnswer")
                  self.idBack:SetBackground(toggled and GameColors.L or RGBA(255, 255, 255, 0))
                  local node = self.parent:ResolveId("node")
                  local dlg = GetDialog(self)
                  dlg.impconfirm.confirm = toggled
                  if toggled then
                    node.idGoBack:Toggle(false)
                    dlg.impconfirm.back = false
                  end
                  dlg:ActionsUpdated()
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnMouseButtonDown(self, pos, button)",
                "func",
                function(self, pos, button)
                  if button == "L" then
                    self.idbtnChecked:OnPress()
                    PlayFX("buttonPress", "start")
                    return "break"
                  end
                end
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XToggleButton",
                "Id",
                "idbtnChecked",
                "Margins",
                box(10, 0, 0, 0),
                "VAlign",
                "center",
                "Background",
                RGBA(255, 255, 255, 0),
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "FXMouseIn",
                "buttonRollover",
                "FXPress",
                "buttonPress",
                "FXPressDisabled",
                "IactDisabled",
                "FocusedBackground",
                RGBA(255, 255, 255, 0),
                "OnPress",
                function(self, gamepad)
                  XTextButton.OnPress(self)
                  self.parent:Toggle(not self.Toggled)
                end,
                "RolloverBackground",
                RGBA(255, 255, 255, 0),
                "PressedBackground",
                RGBA(255, 255, 255, 0),
                "Icon",
                "UI/PDA/imp_radio_button",
                "IconRows",
                2
              }),
              PlaceObj("XTemplateWindow", {
                "Id",
                "idBack",
                "Margins",
                box(35, 4, 4, 4),
                "Dock",
                "box"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idAnswer",
                "VAlign",
                "center",
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "FXMouseIn",
                "buttonRollover",
                "FXPress",
                "buttonPress",
                "FXPressDisabled",
                "IactDisabled",
                "TextStyle",
                "PDAIMPAnswer",
                "Translate",
                true
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnMouseButtonDown(self, pos, button)",
                  "func",
                  function(self, pos, button)
                    XText.OnMouseButtonDown(self, pos, button)
                    if button == "L" then
                      self.parent.idbtnChecked:OnPress()
                      return "break"
                    end
                  end
                })
              })
            })
          })
        })
      })
    })
  })
})
