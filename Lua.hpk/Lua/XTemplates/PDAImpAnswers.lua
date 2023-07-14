PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAImpAnswers",
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
    T(363374219327, "HeaderButtonId")
  }),
  PlaceObj("XTemplateWindow", {
    "LayoutMethod",
    "VList",
    "LayoutVSpacing",
    18
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
      "idQuestion",
      "Image",
      "UI/PDA/imp_panel",
      "FrameBox",
      box(8, 8, 8, 8),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        if context and context.question then
          self.idQuestionText:SetText(context.preset.question)
          self.idQuestionTitle:SetText(T({
            319761572184,
            "Question <idx>",
            idx = context.question
          }))
        end
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(16, 16, 16, 16),
        "LayoutMethod",
        "VList",
        "ChildrenHandleMouse",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idQuestionTitle",
          "TextStyle",
          "PDAIMPContentTitle",
          "Translate",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idQuestionText",
          "TextStyle",
          "PDAIMPContentText",
          "Translate",
          true
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "Id",
      "idAnswers",
      "MaxWidth",
      670,
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextFrame",
        "IdNode",
        false,
        "Image",
        "UI/PDA/imp_panel",
        "FrameBox",
        box(8, 8, 8, 8)
      }, {
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
            "IdNode",
            true,
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
                    idx = ctrl.idx
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
                    idx = ctrl.idx
                    break
                  end
                end
                idx = 1 < idx and idx - 1 or count
                self[idx]:Toggle(true)
              end
            }),
            PlaceObj("XTemplateForEach", {
              "array",
              function(parent, context)
                return context and context.preset.answers
              end,
              "run_after",
              function(child, context, item, i, n, last)
                child.idAnswer:SetText(context.preset.answers[i].answer)
                child.idx = i
                local preset_id = context.preset.id
                local item = table.find_value(g_ImpTest and g_ImpTest.answers or {}, "id", preset_id)
                local toggled = false
                if item and item.idx == i then
                  child:Toggle(true)
                  toggled = true
                end
                if i == 1 and not item then
                  child:Toggle(true)
                end
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextFrame",
                "MinHeight",
                50,
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                10,
                "HandleMouse",
                true,
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "FXMouseIn",
                "buttonRollover",
                "FXPress",
                "buttonPress",
                "FXPressDisabled",
                "IactDisabled",
                "Image",
                "UI/PDA/imp_panel_2",
                "FrameBox",
                box(5, 5, 5, 5)
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
                    local answers = self.parent
                    local context = self:GetContext()
                    local preset_id = context.preset.id
                    local item_idx = table.find(g_ImpTest.answers, "id", preset_id)
                    local dlg = GetDialog(self)
                    if toggled then
                      if not prev then
                        g_ImpTest = g_ImpTest or {}
                        g_ImpTest.answers = g_ImpTest.answers or {}
                        if item_idx then
                          local prev = g_ImpTest.answers[item_idx].idx
                          g_ImpTest.answers[item_idx].idx = self.idx
                          if prev ~= self.idx then
                            g_ImpTest.final = nil
                          end
                        else
                          g_ImpTest.answers[#g_ImpTest.answers + 1] = {
                            id = preset_id,
                            idx = self.idx
                          }
                        end
                      end
                      for i = 1, #answers do
                        if i ~= self.idx then
                          answers[i]:Toggle(false)
                        end
                      end
                    elseif prev and g_ImpTest.answers[item_idx].idx == self.idx then
                      table.remove(g_ImpTest.answers, item_idx)
                    end
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
                  "HAlign",
                  "center",
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
                  "Margins",
                  box(0, 0, 8, 0),
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
                        PlayFX("buttonPress", "start")
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
})
