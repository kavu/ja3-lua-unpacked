PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAImpConfirm",
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
    T(857242053635, "HeaderButtonId")
  }),
  PlaceObj("XTemplateWindow", {
    "MaxWidth",
    670,
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
      "Dock",
      "top",
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
        "ChildrenHandleMouse",
        false
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
          "TextStyle",
          "PDAIMPContentTitle",
          "Translate",
          true,
          "Text",
          T(289666038916, "Welcome to the Institute for Mercenary Profiling (I.M.P.)")
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
          "TextStyle",
          "PDAIMPContentText",
          "Translate",
          true,
          "Text",
          T(649913287419, "At I.M.P. we know the mercenary trade. We can offer you advice that will help you handle the pressures that a mission can put on you, and suggest custom tailored mercenaries for your team. We know you better than yourself!")
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextFrame",
      "Id",
      "idAnswers",
      "Dock",
      "box",
      "Image",
      "UI/PDA/imp_panel",
      "FrameBox",
      box(8, 8, 8, 8),
      "ContextUpdateOnOpen",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XScrollArea",
        "Id",
        "idScrollArea",
        "IdNode",
        false,
        "Margins",
        box(20, 20, 0, 20),
        "VAlign",
        "top",
        "LayoutMethod",
        "VList",
        "VScroll",
        "idScrollbar"
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 0, 20, 0),
          "LayoutMethod",
          "VList"
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
            T(859459210130, "How much")
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
            T(213252108281, [[
You have a group discount: for a mere <money(6999)> (down from <money(11999)>) you can take a P.E.T. (Personality Evaluation Test) and get a mercenary certificate allowing you to field a mercenary right now, free of additional charges!

Your friend, your spouse or you yourself - it's only up to you to decide who gets the action!]])
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
              "VList"
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
                "XContextWindow",
                "Id",
                "idConfirm",
                "IdNode",
                true,
                "MinHeight",
                40,
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                10,
                "Background",
                RGBA(255, 255, 255, 0),
                "HandleMouse",
                true,
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  self:Toggle(true)
                end
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
                    dlg.impconfirm.next = toggled
                    if toggled then
                      node.idSkip:Toggle(false)
                      dlg.impconfirm.skip = false
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
                  "TextStyle",
                  "PDAIMPAnswer",
                  "Translate",
                  true,
                  "Text",
                  T(265050079968, "I will take the P.E.T.")
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnMouseButtonDown(self, pos, button)",
                    "func",
                    function(self, pos, button)
                      XText.OnMouseButtonDown(self, pos, button)
                      if button == "L" then
                        self.parent.idbtnChecked:OnPress()
                        PlayFX("buttonPress", "start")
                        return "break"
                      end
                    end
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextWindow",
                "Id",
                "idSkip",
                "IdNode",
                true,
                "MinHeight",
                40,
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                10,
                "Background",
                RGBA(255, 255, 255, 0),
                "HandleMouse",
                true,
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga"
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
                    dlg.impconfirm.skip = toggled
                    if toggled then
                      node.idConfirm:Toggle(false)
                      dlg.impconfirm.next = false
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
                  "TextStyle",
                  "PDAIMPAnswer",
                  "Translate",
                  true,
                  "Text",
                  T(567105026025, "I will skip this wonderful test and select manually")
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnMouseButtonDown(self, pos, button)",
                    "func",
                    function(self, pos, button)
                      XText.OnMouseButtonDown(self, pos, button)
                      if button == "L" then
                        self.parent.idbtnChecked:OnPress()
                        PlayFX("buttonPress", "start")
                        return "break"
                      end
                    end
                  })
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XZuluScroll",
          "Id",
          "idScrollbar",
          "Margins",
          box(0, 0, 10, 0),
          "Dock",
          "right",
          "UseClipBox",
          false,
          "Target",
          "idScrollArea",
          "AutoHide",
          true
        })
      })
    })
  })
})
